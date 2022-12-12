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
logic PC_ena;
logic [31:0] PC_next; 
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
// Read Data Register
register #(.N(32)) RD_DATA_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(mem_rd_data), .q(Data)
);

// make enum for imm_ext, extend sign depending on the size. 5{0}
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
logic [31:0] rfile_wr_data;
wire [31:0] RD1, RD2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(RegWrite), .wr_addr(rd), .wr_data(rfile_wr_data),
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
  ERROR = 4'b1111
} rv32_state;

//decode variables
logic [6:0] op;
logic [2:0] funct3; 
logic [6:0] funct7;
logic [2:0] ImmSrc;

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
    // A <= 0;
    // mem_wr_data <= 0;
  end else begin
    case(rv32_state)
        FETCH: rv32_state <= FETCH;
        // DECODE: begin
        //   case(op)
        //     OP_LTYPE: rv32_state <= MEM_ADDR;
        //     OP_STYPE: rv32_state <= MEM_ADDR;
        //     OP_RTYPE: rv32_state <= EXECUTE_R;
        //     OP_ITYPE: rv32_state <= EXECUTE_I;
        //     OP_JAL: rv32_state <= JAL;
        //     OP_BTYPE: rv32_state <= BRANCH;
        //     default: rv32_state <= ERROR;
        //   endcase
        // end
        // EXECUTE_I: rv32_state <= ALU_WRITEBACK;
        // ALU_WRITEBACK: rv32_state <= FETCH;
        // MEM_ADDR : begin
        //   case(op)
        //     OP_LTYPE: rv32_state <= MEM_READ;
        //     OP_STYPE: rv32_state <= MEM_WRITE;
        //     default: rv32_state <= FETCH;
        //   endcase
        // end
        default: rv32_state <= ERROR;
    endcase
  end
end

always_ff @(posedge clk) begin : control_unit_cl
  // if (ena) begin
    case(rv32_state)
    FETCH : begin
      // Control PC
      PC_next = alu_result;
      PC_ena = 1'b1;
      SrcA = PC;
      SrcB = 32'd4;
      ALUControl = ALU_ADD;
      // Instruction Code
      IRWrite = 1'b1;
      mem_addr = PC;
      mem_wr_ena = 1'b0;
      // RegWrite = 1'b0;
      // Branch = 0;
    end
    DECODE : begin
      PC_ena = 0;
      mem_wr_ena = 1'b0;
      IRWrite = 1'b0;
      RegWrite = 1'b0;
      Branch = 0;
      ImmSrc = 2'b00; 
      end
    // MEM_ADDR : begin
    //   Branch = 0;
    //   PC_ena = 0;
    //   mem_wr_ena = 0;
    //   IRWrite = 0;
    //   RegWrite = 0;
    //   ImmSrc = 2'b00; 
    //   SrcA = 2'b10;
    //   SrcB = 2'b01;
    //   ALUControl = ALU_AND;
    // end
    // EXECUTE_R : begin
    //   Branch = 0;
    //   ALUSrcA = 2'b10; 
    //   ALUSrcB = 2'b00;
    //   PC_ena = 0;
    //   mem_wr_ena = 0;
    //   IRWrite = 0;
    //   RegWrite = 0;
    //   // rv32_state = ALU_WRITEBACK;
    //   case (funct3)
    //     FUNCT3_ADD: begin 
    //       case(funct7)
    //         7'b0000000: ALUControl = ALU_ADD;
    //         7'b0100000: ALUControl = ALU_SUB;
    //         default: ALUControl = ALU_INVALID;
    //       endcase
    //     end
    //     FUNCT3_SLL: ALUControl = ALU_SLL;
    //     FUNCT3_SLT: ALUControl = ALU_SLT;
    //     FUNCT3_SLTU: ALUControl = ALU_SLTU;
    //     FUNCT3_XOR: ALUControl = ALU_XOR;
    //     FUNCT3_SHIFT_RIGHT: begin 
    //       case(funct7)
    //         7'b0000000: ALUControl = ALU_SRL;
    //         7'b0100000: ALUControl = ALU_SRA;
    //         default: ALUControl = ALU_SUB;
    //       endcase
    //     end
    //     FUNCT3_OR: ALUControl = ALU_OR;
    //     FUNCT3_AND: ALUControl = ALU_AND;
    //     default: ALUControl = ALU_INVALID;
    //   endcase
    //   end
    // EXECUTE_I : begin
    //   PC_ena = 1'b0;
    //   mem_wr_ena = 1'b0;
    //   IRWrite = 1'b0;
    //   RegWrite = 1'b0;
    //   Branch = 0;
    //   ImmSrc = 2'b00; 
    //   ALUSrcA = 2'b10;
    //   ALUSrcB = 2'b01;
    //   ALUControl = ALU_ADD; // need to make this based on funct3
    //   end
    // JAL : begin
    //   end
    // JALR : begin
    //   end
    // BRANCH : begin
    //   Branch = 1;
    //   end
    // ALU_WRITEBACK : begin
    //   Branch = 0;
    //   PC_ena = 0;
    //   mem_wr_ena = 0;
    //   IRWrite = 0;
    //   RegWrite = 1;
    //   ResultSrc = 2'b00;
    //   end
    // MEM_READ : begin
    //   Branch = 0;
    //   ResultSrc = 2'b00; 
    //   PC_ena = 1'b0;
    //   AdrSrc = 1'b1;
    //   mem_wr_ena = 1'b0;
    //   IRWrite = 1'b0;
    //   RegWrite = 1'b0;
    //   ImmSrc = 2'b00; 
    //   end
    // MEM_WRITE : begin
    //   end
    // JUMP_WRITEBACK : begin
    //   end
    // MEM_WRITEBACK : begin
    //   Branch = 0;
    //   PC_ena = 0;
    //   mem_wr_ena = 0;
    //   IRWrite = 0;
    //   RegWrite = 1;
    //   ImmSrc = 2'b00; 
    //   ResultSrc = 2'b01;
      
    //   end
    ERROR : begin
    end
    default: begin
      PC_next = 0;
      PC_ena = 1'b0;
      SrcA = 0;
      SrcB = 0;
      ALUControl = ALU_ADD;
      IRWrite = 1'b0;
      mem_wr_ena = 1'b0;
      // rs1 = 0;
      // rs2 = 0;
      // rd = 0;
    end

    endcase
  // end
end


endmodule
