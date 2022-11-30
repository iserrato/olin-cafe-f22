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

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena;
logic [31:0] PC_next; 

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
);

// Select memory address based on address select siganl
enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src; // mem_src = AdrSrc in book
always_comb begin : memory_read_address_mux
  case(mem_src)
    MEM_SRC_RESULT : mem_rd_addr = alu_result;
    MEM_SRC_PC : mem_rd_addr = PC;
    default: mem_rd_addr = 0;
  endcase
end

enum logic {MEM_SRC_PC, MEM_SRC_OLD_PC, REG_DATA_1} alu_src_a; // alu_src_a = ALUSrcA in book
always_comb begin : src_a_select
  case(alu_src_a)
    MEM_SRC_PC : src_a = PC;
    MEM_SRC_PC_OLD : src_a = PC_old;
    REG_DATA_1: src_a = reg_data1;
    default: src_a = 0;
  endcase
end

enum logic {RD2, IMM_EXT, CONST_FOUR} alu_src_b; // alu_src_b = ALUSrcB in book
always_comb begin : src_a_select
  case(alu_src_b)
    MEM_SRC_PC : src_b = RD2;
    MEM_SRC_PC_OLD : src_b = IMM_EXT;
    REG_DATA_1: src_b = CONST_4;
    default: src_b = 0;
  endcase
end

// make enum for imm_ext, extend sign depending on the size. 5{0}
enum logic {} imm_ext;

// find op codes, find func3 and func7 for instruction and sign extension


// Register file
logic reg_write;
logic [4:0] rd, rs1, rs2;
logic [31:0] rfile_wr_data;
wire [31:0] reg_data1, reg_data2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
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

always_ff @(posedge clk) begin : rv32i
  if (rst) begin
    mem_wr_ena = 0;
    rv32_state = FETCH;
  end

  if (ena) begin
    case(rv32_state)
    FETCH : begin
      PC_ena = 1;
      src_a = MEM_SRC_PC;
      src_b = WRITE_DATA;
      AluOp = 

      mem_addr = PC;
    end
    DECODE : begin
      end
    MEM_ADDR : begin
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
      end
    MEM_WRITE : begin
      end
    JUMP_WRITEBACK : begin
      end
    MEM_WRITEBACK : begin
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
