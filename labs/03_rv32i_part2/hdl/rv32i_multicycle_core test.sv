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
logic IR_write;
logic [31:0] IR;

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC), .q(PC_old)
);
// Instruction Register
register #(.N(32)) INSTR_REGISTER(
  .clk(clk), .rst(rst), .ena(IR_write), .d(mem_rd_data), .q(IR)
);

//  an example of how to make named inputs for a mux:
/*
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    always_comb begin : memory_read_address_mux
      case(mem_src)
        MEM_SRC_RESULT : mem_rd_addr = alu_result;
        MEM_SRC_PC : mem_rd_addr = PC;
        default: mem_rd_addr = 0;
    end
*/

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
  FETCH = 4'b0000,
  DECODE = 4'b0001,
  // MEM_ADDR = 4'b0010,
  // EXECUTE_R = 4'b0011,
  // EXECUTE_I = 4'b0100,
  // JAL = 4'b0101,
  // JALR = 4'b0110,
  // BRANCH = 4'b0111,
  // ALU_WRITEBACK = 4'b1000,
  // MEM_READ = 4'b1001,
  // MEM_WRITE = 4'b1010,
  // JUMP_WRITEBACK = 4'b1011,
  // MEM_WRITEBACK = 4'b1100,
  ERROR = 4'b1111
} rv32_state;

always_ff @(posedge clk) begin : main_fsm
  if (rst) begin
    rv32_state <= FETCH;
    // A <= 0;
    // mem_wr_data <= 0;
  end else begin
    case(rv32_state)
        FETCH: rv32_state <= FETCH;
        // ERROR: rv32_state <= FETCH;
        default : rv32_state <= ERROR;
    endcase
  end
end


always_comb begin : control_unit_cl
  // if (ena) begin
    case(rv32_state)
      FETCH : begin
        // Control PC
        PC_next = alu_result;
        PC_ena = 1'b1;
        // ALU
        src_a = PC;
        src_b = 32'd1;
        alu_control = ALU_ADD;
        // Instruction Code
        IR_write = 1'b1;
        mem_addr = PC;
        mem_wr_ena = 1'b0;
        // RegWrite = 1'b0;
        // Branch = 0;
      end
          ERROR : begin
      end
      default: begin
        PC_next = 0;
        PC_ena = 1'b0;
        src_a = 0;
        src_b = 0;
        alu_control = ALU_ADD;
        IR_write = 1'b0;
        mem_wr_ena = 1'b0;
      end
    endcase
end

endmodule