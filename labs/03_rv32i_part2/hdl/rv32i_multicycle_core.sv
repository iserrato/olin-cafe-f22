`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;

// Control Unit
logic IRWrite;
logic [31:0] Instr;
logic [31:0] ALUOut;
logic [31:0] A;
logic [31:0] Data;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic [31:0] PC_next; 
logic PC_ena;
logic Branch;

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(IRWrite), .d(PC), .q(PC_old)
);
// Instruction Register
register #(.N(32)) INSTR_REGISTER(
  .clk(clk), .rst(rst), .ena(IRWrite), .d(mem_rd_data), .q(Instr)
);
// Register Register
register #(.N(32)) REG_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(RD1), .q(A)
);

// Register Register 1
register #(.N(32)) REG_REGISTER_1(
  .clk(clk), .rst(rst), .ena(1'b1), .d(RD2), .q(mem_wr_data)
);

// ALU Out Register
register #(.N(32)) ALU_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(alu_result), .q(ALUOut)
);

// Read Data Register
register #(.N(32)) RD_DATA_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(mem_rd_data), .q(Data)
);

// Select memory address based on address select siganl
enum logic [1:0] {MEM_SRC_PC, MEM_SRC_RESULT, ADR_DEFAULT} AdrSrc;
always_comb begin : memory_read_address_mux
  case(AdrSrc)
    MEM_SRC_PC : mem_addr = PC;
    MEM_SRC_RESULT : mem_addr = RESULT;
    ADR_DEFAULT : mem_addr = 0;
    default: mem_addr = 0;
  endcase
end

enum logic [1:0] {SRC_PC = 2'b00, MEM_SRC_OLD_PC = 2'b01, REG_DATA_1 = 2'b10, A_DEFAULT} ALUSrcA;
always_comb begin : ALUSrcA_mux
  case(ALUSrcA)
    SRC_PC : SrcA = PC;
    MEM_SRC_OLD_PC : SrcA = PC_old;
    REG_DATA_1: SrcA = A;
    A_DEFAULT : SrcA = 0;
    default: SrcA = 0;
  endcase
end

enum logic [1:0] {SRC_RD2 = 2'b00, SRC_IMM_EXT = 2'b01, SRC_FOUR = 2'b10, B_DEFAULT} ALUSrcB;
always_comb begin : ALUSrcB_mux
  case(ALUSrcB)
    SRC_RD2 : SrcB = mem_wr_data;
    SRC_IMM_EXT : SrcB = imm;
    SRC_FOUR: SrcB = 4;
    B_DEFAULT: SrcB = 0;
    default: SrcB = 0;
  endcase
end

enum logic [1:0] {SRC_ALU_OUT = 2'b00, SRC_MEM_DATA = 2'b01, SRC_ALU_RESULT = 2'b10, R_DEFAULT = 2'b11} ResultSrc;
always_comb begin : Result_mux
  case(ResultSrc)
    SRC_ALU_OUT : RESULT = ALUOut;
    SRC_MEM_DATA : RESULT = Data;
    SRC_ALU_RESULT: RESULT = alu_result;
    R_DEFAULT: RESULT = 0;
    default: RESULT = 0;
  endcase
end

logic [31:0] imm;
always_comb begin : sign_extender
  case(Instr[6:0])
    OP_LTYPE: imm[31:12] = {20{imm[11]}};
    OP_ITYPE: imm[31:12] = {20{imm[11]}};
    OP_AUIPC: imm[11:0] = {20{1'b0}};
    OP_STYPE: imm[31:12] = {20{imm[11]}};
    OP_LUI  : imm[11:0] = {20{1'b0}};
    OP_BTYPE: begin
      imm[0] = 1'b0;
      imm[31:13] = {19{imm[12]}};
    end
    OP_JALR : begin
      imm[0] = 1'b0;
      imm[31:21] = {11{imm[20]}};
    end
    OP_JAL  : begin
      imm[0] = 1'b0;
      imm[31:21] = {11{imm[20]}};
    end
  endcase
end

// Register file
logic RegWrite;
logic [4:0] rd, rs1, rs2;
logic [31:0] RESULT;
wire [31:0] RD1, RD2;
register_file REGISTER_FILE(
  .clk(clk), .rst(rst),
  .wr_ena(RegWrite), .wr_addr(rd), .wr_data(RESULT),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(RD1), .rd_data1(RD2)
);

// ALU and related control signals
logic [31:0] SrcA, SrcB;
alu_control_t ALUControl;
wire [31:0] alu_result;
wire overflow, alu_zero, alu_equal;
alu_behavioural ALU (
  .a(SrcA), .b(SrcB), .result(alu_result),
  .control(ALUControl),
  .overflow(overflow), .zero(alu_zero), .equal(alu_equal)
);

// Implement your multicycle rv32i CPU here!

enum logic [3:0] {
  FETCH = 4'b0000,
  DECODE = 4'b0001,
  MEM_ADDR = 4'b0010,
  EXECUTE_R = 4'b0011,
  EXECUTE_I = 4'b0100,
  JAL = 4'b0101,
  JALR = 4'b0110,
  BRANCH = 4'b0111,
  ALU_WRITEBACK = 4'b1000,
  MEM_READ = 4'b1001,
  MEM_WRITE = 4'b1010,
  JUMP_WRITEBACK = 4'b1011,
  MEM_WRITEBACK = 4'b1100,
  ERROR = 4'b1111
} rv32_state;

//decode variables
logic [6:0] op;
logic [2:0] funct3; 
logic [6:0] funct7;

op_type_t op_codes;
funct3_ritype_t enum_funct3;

always_comb begin : DECODER 
  op = Instr[6:0];
  case(op)
    OP_LTYPE: begin 
      imm[11:0] = Instr[31:20];
      rs1 = Instr[19:15];
      funct3 = Instr[14:12]; //explicitly define when needed
      rd = Instr[11:7];
      end
    OP_ITYPE: begin 
      imm[11:0] = Instr[31:20];
      rs1 = Instr[19:15];
      funct3 = Instr[14:12];
      funct7 = Instr[31:25];
      rd = Instr[11:7];
      end
    // OP_AUIPC: begin 

    //   end
    OP_STYPE: begin 
      imm[11:5] = Instr[31:25]; //define imm TODO
      rs1 = Instr[19:15];
      rs2 = Instr[24:20];
      funct3 = Instr[14:12];
      imm[4:0] = Instr[11:7];
      end
    OP_RTYPE: begin 
      funct7 = Instr[31:25];
      rs1 = Instr[19:15];
      rs2 = Instr[24:20];
      funct3 = Instr[14:12];
      rd = Instr[11:7];
      end
    OP_LUI  : begin 
      end
    OP_BTYPE: begin 
      imm[12] = Instr[31];
      imm[10:5] = Instr[30:25];
      rs1 = Instr[19:15];
      rs2 = Instr[24:20];
      funct3 = Instr[14:12];
      imm[4:1] = Instr[11:8];
      imm[11] = Instr[7];
      end
    OP_JALR : begin //TODO: finish this!
      imm[20] = Instr[31];
      imm[10:1] = Instr[30:21];
      imm[21] = Instr[20];
      imm[19:12] = Instr[19:12];
      rd = Instr[11:7];
      end
    OP_JAL  : begin 
      imm[20] = Instr[31];
      imm[10:1] = Instr[30:21];
      imm[21] = Instr[20];
      imm[19:12] = Instr[19:12];
      rd = Instr[11:7];
      end     
  endcase
end

always_ff @(posedge clk) begin : main_fsm
  if (rst) begin
    rv32_state <= FETCH;
  end else begin
    case(rv32_state)
        FETCH: rv32_state <= DECODE;
        DECODE: begin
          case(op)
            OP_LTYPE: rv32_state <= MEM_ADDR;
            OP_STYPE: rv32_state <= MEM_ADDR;
            OP_RTYPE: rv32_state <= EXECUTE_R;
            OP_ITYPE: rv32_state <= EXECUTE_I;
            OP_JAL: rv32_state <= JAL;
            OP_BTYPE: rv32_state <= BRANCH;
            default: rv32_state <= ERROR;
          endcase
        end
        EXECUTE_I: rv32_state <= ALU_WRITEBACK;
        EXECUTE_R: rv32_state <= ALU_WRITEBACK;
        ALU_WRITEBACK: rv32_state <= FETCH;
        MEM_ADDR : begin
          case(op)
            OP_LTYPE: rv32_state <= MEM_READ;
            OP_STYPE: rv32_state <= MEM_WRITE;
            default: rv32_state <= FETCH;
          endcase
        end
        MEM_WRITE : rv32_state <= FETCH;
        MEM_READ : rv32_state <= MEM_WRITEBACK;
        MEM_WRITEBACK : rv32_state <= FETCH;
        BRANCH : rv32_state <= FETCH;
        default: rv32_state <= ERROR;
    endcase
  end
end

logic branch_taken;
always_comb begin: BRANCHING
  if (rv32_state == BRANCH) begin
      case(funct3)
        FUNCT3_BEQ: branch_taken = alu_equal;
        FUNCT3_BNE: branch_taken = ~alu_equal;
        FUNCT3_BLT, FUNCT3_BLTU: branch_taken = alu_result[0];
        FUNCT3_BGE, FUNCT3_BGEU: branch_taken = ~alu_result[0];
        default: branch_taken = 0;
      endcase
  end
end

always_comb begin: PC_Control_Unit
  PC_next = RESULT;
  case (rv32_state)
    FETCH: begin
      PC_ena = 1'b1;
    end
    JAL: PC_ena = 1'b1;
    BRANCH:  PC_ena = branch_taken; // TODO: Branch Cases
    default: begin
      PC_ena = 0;
    end
  endcase
end

always_comb begin: ALU_Control_Unit
  case (rv32_state)
    FETCH: begin
      ALUSrcA = SRC_PC;
      ALUSrcB = SRC_FOUR;
      ALUControl = ALU_ADD;
    end
    DECODE: begin
      ALUSrcA = MEM_SRC_OLD_PC;
      ALUSrcB = SRC_IMM_EXT;
      ALUControl = ALU_ADD;
    end
    MEM_ADDR: begin
      ALUSrcA = REG_DATA_1;
      ALUSrcB = SRC_IMM_EXT;
      ALUControl = ALU_ADD;
    end
    EXECUTE_R: begin
      ALUSrcA = REG_DATA_1; 
      ALUSrcB = SRC_RD2;
      case (funct3)
        FUNCT3_ADD: begin 
          case(funct7)
            7'b0000000: ALUControl = ALU_ADD;
            7'b0100000: ALUControl = ALU_SUB;
            default: ALUControl = ALU_INVALID;
          endcase
        end
        FUNCT3_SLL: ALUControl = ALU_SLL;
        FUNCT3_SLT: ALUControl = ALU_SLT;
        FUNCT3_SLTU: ALUControl = ALU_SLTU;
        FUNCT3_XOR: ALUControl = ALU_XOR;
        FUNCT3_SHIFT_RIGHT: begin 
          case(funct7)
            7'b0000000: ALUControl = ALU_SRL;
            7'b0100000: ALUControl = ALU_SRA;
            default: ALUControl = ALU_SUB;
          endcase
        end
        FUNCT3_OR: ALUControl = ALU_OR;
        FUNCT3_AND: ALUControl = ALU_AND;
        default: ALUControl = ALU_INVALID;
      endcase
    end
    EXECUTE_I: begin
      ALUSrcA = REG_DATA_1;
      ALUSrcB = SRC_IMM_EXT;
      case(funct3)
        FUNCT3_ADD: ALUControl = ALU_ADD;
        FUNCT3_SLL: ALUControl = ALU_SLL;
        FUNCT3_SLT: ALUControl = ALU_SLT;
        FUNCT3_SLTU: ALUControl = ALU_SLTU;
        FUNCT3_XOR: ALUControl = ALU_XOR;
        FUNCT3_SHIFT_RIGHT: begin 
          case(funct7)
            7'b0000000: ALUControl = ALU_SRL;
            7'b0100000: ALUControl = ALU_SRA;
            default: ALUControl = ALU_SUB;
          endcase
        end
        FUNCT3_OR: ALUControl = ALU_OR;
        FUNCT3_AND: ALUControl = ALU_AND;
        default: ALUControl = ALU_INVALID;
      endcase
    end
    ALU_WRITEBACK: begin
      ALUSrcA = REG_DATA_1;
      ALUSrcB = SRC_IMM_EXT;
      ALUControl = ALU_ADD;
    end
    BRANCH: begin
      ALUSrcA = REG_DATA_1;
      ALUSrcB = SRC_RD2;
      if(funct3[1]) ALUControl = ALU_SLTU;
      else ALUControl = ALU_SLT;
      // ALUControl = ALU_SUB;
    end
    JAL : begin
      ALUSrcA = MEM_SRC_OLD_PC;
      ALUSrcB = SRC_FOUR;
      ALUControl = ALU_ADD;
    end
    default: begin
      ALUSrcA = A_DEFAULT;
      ALUSrcB = B_DEFAULT;
      ALUControl = ALU_ADD;
    end
  endcase
end

always_comb begin: Memory_Control_Unit
  case (rv32_state)
    MEM_READ: begin
      mem_wr_ena = 1'b0;
      AdrSrc = MEM_SRC_RESULT;
    end
    MEM_WRITE: begin
      mem_wr_ena = 1'b1;
      AdrSrc = MEM_SRC_RESULT;
    end
    default: begin
      mem_wr_ena = 1'b0;
      AdrSrc = MEM_SRC_PC;
    end
  endcase
end

always_comb begin : RegWrite_Control_Unit
  RegWrite = (rv32_state == MEM_WRITEBACK | rv32_state == ALU_WRITEBACK);
end

always_comb begin: Result_Control_Unit
  case (rv32_state)
    FETCH: ResultSrc = SRC_ALU_RESULT;
    MEM_WRITEBACK: ResultSrc = SRC_MEM_DATA;
    default: ResultSrc = SRC_ALU_OUT;
  endcase
end

// always_comb begin: Branch_Control_Unit
//   Branch = (rv32_state == BRANCH);
// end

always_comb begin: Instruction_Control_Unit
  case (rv32_state)
    FETCH: IRWrite = 1'b1;
    default: IRWrite = 1'b0;
  endcase
end

always_comb begin : control_unit_cl
  case(rv32_state)
  FETCH : begin
    AdrSrc = MEM_SRC_PC;
  end
  MEM_READ : begin
    AdrSrc = MEM_SRC_RESULT;
    end
  default: AdrSrc = ADR_DEFAULT;
  endcase
end

endmodule