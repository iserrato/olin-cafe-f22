`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors, neighbor_sum, exactly_three, exactly_two);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;
output logic [3:0] neighbor_sum;
output logic exactly_three;
output logic exactly_two;

assign state_q = state_0;

input wire [7:0] neighbors;
logic [1:0] out_0, out_1, out_2, out_3;
logic [2:0] out_4, out_5;

adder_1 ADDER0 (
  .a(neighbors[0]),
  .b(neighbors[1]),
  .c_in(1'b0),
  .sum(out_0[0]),
  .c_out(out_0[1])
);

adder_1 ADDER1 (
  .a(neighbors[2]),
  .b(neighbors[3]),
  .c_in(1'b0),
  .sum(out_1[0]),
  .c_out(out_1[1])
);

adder_1 ADDER2 (
  .a(neighbors[5]),
  .b(neighbors[4]),
  .c_in(1'b0),
  .sum(out_2[0]),
  .c_out(out_2[1])
);

adder_1 ADDER3 (
  .a(neighbors[7]),
  .b(neighbors[6]),
  .c_in(1'b0),
  .sum(out_3[0]),
  .c_out(out_3[1])
);

adder_n #(.N(2)) ADDER4 (
  .a(out_0),
  .b(out_1),
  .c_in(1'b0),
  .sum(out_4[1:0]),
  .c_out(out_4[2])
);

adder_n #(.N(2)) ADDER5 (
  .a(out_2),
  .b(out_3),
  .c_in(1'b0),
  .sum(out_5[1:0]),
  .c_out(out_5[2])
);

adder_n #(.N(3)) ADDER6 (
  .a(out_4),
  .b(out_5),
  .c_in(1'b0),
  .sum(neighbor_sum[2:0]),
  .c_out(neighbor_sum[3])
);

// logic new_state;

always_comb begin
  exactly_three = ~(neighbor_sum[0] ^ 1'b1) & ~(neighbor_sum[1] ^ 1'b1) & ~(neighbor_sum[2] ^ 1'b0) & ~(neighbor_sum[3] ^ 1'b0);
  exactly_two = ~(neighbor_sum[0] ^ 1'b0) & ~(neighbor_sum[1] ^ 1'b1) & ~(neighbor_sum[2] ^ 1'b0) & ~(neighbor_sum[3] ^ 1'b0);
  state_d = state_0 ? (exactly_three  | exactly_two) : exactly_three;
end

always_ff @(posedge clk) begin
  // ?
end

endmodule