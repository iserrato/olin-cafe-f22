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
logic AdrSrc;
logic [1:0] ALUSrcA;
logic [1:0] ALUSrcB;
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

enum logic {MEM_SRC_PC_2, MEM_SRC_OLD_PC, REG_DATA_1} ALUSrcA;
always_comb begin : ALUSrcA_mux
  case(ALUSrcA)
    MEM_SRC_PC_2 : SrcA = PC;
    MEM_SRC_PC_OLD : SrcA = PC_old;
    REG_DATA_1: SrcA = A;
    default: SrcA = 0;
  endcase
end

enum logic {Src_RD2, Src_IMM_EXT, Src_CONST_FOUR} ALUSrcB;
always_comb begin : ALUSrcB_mux
  case(ALUSrcB)
    Src_RD2 : SrcB = mem_wr_data;
    Src_IMM_EXT : SrcB = IMM_EXT;
    Src_CONST_FOUR: SrcB = 4;
    default: SrcB = 0;
  endcase
end

enum logic {src_ALUOut = 2'b00, src_Data = 2'b01, src_ALUResult = 2'b10} ResultSrc;
always_comb begin : Result_mux
  case(ResultSrc)
    src_ALUOut : RESULT = ALUOut;
    src_Data : RESULT = Data;
    src_ALUResult: RESULT = alu_result;
    default: SrcB = 0;
  endcase
end

// make enum for imm_ext, extend sign depending on the size. 5{0}
enum logic {} imm_ext;


// find op codes, find func3 and func7 for instruction and sign extension


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
  FETCH = 0000,
  DECODE = 0001,
  MEM_ADDR = 0010,
  EXECUTE_R = 0011,
  EXECUTE_I = 0100,
  JAL = 0101,
  JALR = 0110,
  BRANCH = 0111,
  ALU_WRITEBACK = 1000,
  MEM_READ = 1001,
  MEM_WRITE = 1010,
  JUMP_WRITEBACK = 1011,
  MEM_WRITEBACK = 1100,
  ERROR = 1101,
  ERROR = 1110,
  ERROR = 1111 
} rv32_state;

//decode variables
logic [6:0] op;
logic [2:0] func3; 
logic [6:0] func7;

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
      AdrSrc = 0;
      IRWrite = 1;
      mem_wr_ena = 0;
      RegWrite = 0; 
      ALUSrcA = 2'b00;
      ALUSrcB = 2'b10;
      ALUControl = ALU_AND;
      ResultSrc = 2'b10;
    end
    DECODE : begin
      PCWrite = 0;
      mem_wr_ena = 0;
      IRWrite = 0;
      RegWrite = 0;
      ImmSrc = 2'b00; // TODO: define ImmSrc

      op = Instr[6:0]
      rs1 = Instr[19:15]
      rs1 = Instr[24:20]
      rd = Instr[11:7]
      func3 = Instr[14:12]
      func7 = Instr[31:25]
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
      end
    EXECUTE_R : begin
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
      end
    MEM_READ : begin
      ResultSrc = 2'b00; 
      PCWrite = 1'b0;
      AdrSrc = 1'b1;
      mem_wr_ena = 1'b0;
      IRWrite = 1'b0;
      RegWrite = 1'b0;
      ImmSrc = 2'b00; 
      ResultSrc = 2'b00;
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
      ResultSrc = 2'b01;
      
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
