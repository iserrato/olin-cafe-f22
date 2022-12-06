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
logic PCWrite;
logic [31:0] PC_next; 

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PCWrite), .d(PC_next), .q(PC)
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
enum logic {MEM_SRC_PC, MEM_SRC_RESULT} AdrSrc;
always_comb begin : memory_read_address_mux
  case(AdrSrc)
    MEM_SRC_PC : mem_addr = PC;
    MEM_SRC_RESULT : mem_addr = alu_result;
    default: mem_addr = 0;
  endcase
end

enum logic [1:0] {MEM_SRC_PC_2 = 2'b00, MEM_SRC_OLD_PC = 2'b01, REG_DATA_1 = 2'b10} ALUSrcA;
always_comb begin : ALUSrcA_mux
  case(ALUSrcA)
    MEM_SRC_PC_2 : SrcA = PC;
    MEM_SRC_OLD_PC : SrcA = PC_old;
    REG_DATA_1: SrcA = A;
    default: SrcA = 0;
  endcase
end

enum logic [1:0] {Src_RD2 = 2'b00, Src_IMM_EXT = 2'b01, Src_CONST_FOUR = 2'b10} ALUSrcB;
always_comb begin : ALUSrcB_mux
  case(ALUSrcB)
    Src_RD2 : SrcB = mem_wr_data;
    Src_IMM_EXT : SrcB = IMM_EXT;
    Src_CONST_FOUR: SrcB = 4;
    default: SrcB = 0;
  endcase
end

enum logic [1:0] {src_ALUOut = 2'b00, src_Data = 2'b01, src_ALUResult = 2'b10} ResultSrc;
always_comb begin : Result_mux
  case(ResultSrc)
    src_ALUOut : RESULT = ALUOut;
    src_Data : RESULT = Data;
    src_ALUResult: RESULT = alu_result;
    default: SrcB = 0;
  endcase
end

// make enum for imm_ext, extend sign depending on the size. 5{0}
enum logic [1:0] {i_type, s_or_b_type, u_or_j_type} imm_sizes;
always_comb begin : sign_extender
  case(op_codes)
  endcase
end



// Register file
logic RegWrite;
logic [4:0] rd, rs1, rs2;
logic [31:0] RESULT;
wire [31:0] RD1, RD2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(RegWrite), .wr_addr(rd), .wr_data(RESULT),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(RD1), .rd_data1(RD2)
);

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] SrcA, SrcB;
alu_control_t ALUControl;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(SrcA), .b(SrcB), .result(alu_result),
  .control(ALUControl),
  .overflow(overflow), .zero(zero), .equal(equal)
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
  ERROR1 = 4'b1101,
  ERROR2 = 4'b1110,
  ERROR3 = 4'b1111 
} rv32_state;

//decode variables
logic [6:0] op;
logic [2:0] func3; 
logic [6:0] func7;
logic [2:0] ImmSrc;

op_type_t op_codes;
funct3_ritype_t rtype_funct3;

always_ff @(posedge clk) begin : rv32i
  if (rst) begin
    mem_wr_ena = 0;
    rv32_state = FETCH;
  end

  if (ena) begin
    case(rv32_state)
    FETCH : begin
      PCWrite = 1; //?? should this be seperated/branching 
      // SrcA = MEM_SRC_PC;
      // SrcB = WriteData;
      // AluOp = 
      AdrSrc = MEM_SRC_PC;
      IRWrite = 1;
      mem_wr_ena = 0;
      RegWrite = 0; 
      ALUSrcA = MEM_SRC_PC_2;
      ALUSrcB = Src_CONST_FOUR;
      ALUControl = ALU_AND;
      ResultSrc = src_ALUResult;
    end
    DECODE : begin
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 0;
      ImmSrc = 2'b00; // TODO: define ImmSrc
      op = Instr[6:0];
      case(op)
        // OP_LTYPE; begin 

        //   end
        OP_ITYPE: begin 
          imm[11:0] = Instr[31:20];
          rs1 = Instr[19:15];
          funct3 = Instr[14:12];
          rd = Instr[11:7];
          end
        // OP_AUIPC; begin 

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
      case(op_codes)
        OP_LTYPE: rv32_state = MEM_ADDR;
        OP_STYPE: rv32_state = MEM_ADDR;
        OP_RTYPE: rv32_state = EXECUTE_R;
        OP_ITYPE: rv32_state = EXECUTE_I;
        OP_JAL: rv32_state = JAL;
        OP_BTYPE: rv32_state = BRANCH;
        default: rv32_state = FETCH;
      endcase
      end
    MEM_ADDR : begin
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 0;
      ImmSrc = 2'b00; 
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b01;
      ALUControl = ALU_AND;
      case(op_codes)
        OP_LTYPE: rv32_state = MEM_READ;
        OP_STYPE: rv32_state = MEM_WRITE;
        default: rv32_state = FETCH;
      endcase
    end
    EXECUTE_R : begin
      ALUSrcA = 2'b10; 
      ALUSrcB = 2'b00;
      AluOp = 2'b10;
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 0;
      rv32_state = ALU_WRITEBACK;
      case (rtype_funct3)
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

    EXECUTE_I : begin
      end
    JAL : begin
      end
    JALR : begin
      end
    BRANCH : begin
      end
    ALU_WRITEBACK : begin
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 1;
      ResultSrc = src_ALUOut;
      rv32_state = FETCH;
      end
    MEM_READ : begin
      ResultSrc = src_ALUOut; 
      PCWrite = 1'b0;
      AdrSrc = MEM_SRC_RESULT;
      mem_wr_ena = 1'b0;
      IRWrite = 1'b0;
      RegWrite = 1'b0;
      ImmSrc = 2'b00; 
      ResultSrc = src_ALUOut;
      end
    MEM_WRITE : begin
      end
    JUMP_WRITEBACK : begin
      end
    MEM_WRITEBACK : begin
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 1;
      ImmSrc = 2'b00; 
      ResultSrc = src_Data;
      
      end
    ERROR : begin
      end
    ERROR : begin
      end
    ERROR : begin
      end
    endcase
  end
end


endmodule
