`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

// equality
always_comb equal = &(a ~^ b);

// zeros
always_comb zero = &(result ~^ 0);

// and
logic [N-1:0] alu_and;
always_comb alu_and = a & b;

// or
logic [N-1:0] alu_or;
always_comb alu_or = a | b;

// xor
logic [N-1:0] alu_xor;
always_comb alu_xor = a ^ b;

// check to see that MSBs are 0
// logic zero_msbs;
// always_comb zero_msbs = &(b[N-1:5] ~^ 27'b0);

// shift left - doesn't work, not sure why!
logic [N-1:0] shift_l;
shift_left_logical #(.N(N)) SHIFT_LEFT (
    .in(a), .shamt(b[4:0]), .out(shift_l)
);

logic [N-1:0] alu_sll;
always_comb alu_sll = shift_l;
// always_comb alu_sll = zero_msbs ? shift_l : 32'b0;

// shift right logic
logic [N-1:0] shift_r_l;
shift_right_logical #(.N(N)) SHIFT_RIGHT (
  .in(a), .shamt(b[4:0]), .out(shift_r_l)
);
logic [N-1:0] alu_srl;
// always_comb alu_srl = zero_msbs ? shift_r_l : 32'b0;
always_comb alu_srl = shift_r_l;

// shift right arithmetic
logic [N-1:0] shift_r_a;
shift_right_arithmetic #(.N(N)) SHIFT_R_A (
  .in(a), .shamt(b[4:0]), .out(shift_r_a)
);

logic [N-1:0] alu_sra;
// always_comb alu_sra = zero_msbs ? shift_r_a : 32'b0;
always_comb alu_sra = shift_r_a;

// adder
logic [N-1:0] alu_add;
logic added_over;
adder_n #(.N(N)) ADDER (
    .a(a), 
    .b(b), 
    .c_in(1'b0), 
    .sum(alu_add), 
    .c_out(added_over)
);

// subtractor
logic [N-1:0] b_bar;
logic [N-1:0] alu_sub;
logic subbed_over;
assign b_bar = ~b;

adder_n #(.N(N)) SUB (
  .a(a),
  .b(b_bar),
  .c_in(1'b1),
  .sum(alu_sub),
  .c_out(subbed_over)
);

// less than
logic [N-1:0] alu_slt;
assign alu_slt[N-1:1] = 0;
logic lsb;
always_comb lsb = equal ? alu_sub[N-1] : 1'b0;
assign alu_slt[0] = lsb;

// unsigned less than
logic [N-1:0] alu_sltu;
assign alu_sltu[N-1:1] = 0;
assign alu_sltu[0] = subbed_over;


logic [N-1:0] and_sll, or_xor, srl_sra, add_sub, slt_sltu, mid, s, big;
logic add_sub_over, over;
always_comb begin
  and_sll = control[3] ? alu_sll : alu_and;
  or_xor = control[0] ? alu_xor : alu_or;
  srl_sra = control[0] ? alu_sra : alu_srl;
  add_sub = control[2] ? alu_sub : alu_add;
  slt_sltu = control[1] ? alu_sltu : alu_slt;
  mid = control[3] ? srl_sra : or_xor;
  s = control[1] ? mid : and_sll;
  big = control[0] ? slt_sltu : add_sub;
  result = control[3] ? big : s;
end

always_comb begin
  add_sub_over = control[2] ? subbed_over : added_over;
  over = control[0] ? subbed_over : add_sub_over;
  overflow = control[3] ? over : 1'b0;
end

endmodule