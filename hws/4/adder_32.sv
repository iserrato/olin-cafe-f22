`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module adder_32(a, b, c_in, sum, c_out);

parameter N = 5; 
input wire [N-1:0] a, b;
input wire c_in;
output logic [N-1:0] sum;
output wire c_out;

logic g0, g1, g2, g3, p0, p1, p2, p3;
logic c0, c1, c2, c3, c4, c5, c6, c7;

always_comb c_out = (c_in & (p0&p1&p2&p3)) | ((((((g0&p1) | g1) & p2) | g2) & p3) | g3); 

adder_n #(.N(4)) ADD0 (
  .a(a[3:0]),
  .b(b[3:0]),
  .c_in(c_in),
  .sum(sum[3:0]),
  .c_out(c0)
);

adder_n #(.N(4)) ADD1 (
  .a(a[7:4]),
  .b(b[7:4]),
  .c_in(c0),
  .sum(sum[7:4]),
  .c_out(c1)
);

adder_n #(.N(4)) ADD2 (
  .a(a[11:8]),
  .b(b[11:8]),
  .c_in(c1),
  .sum(sum[11:8]),
  .c_out(c2)
);

adder_n #(.N(4)) ADD3 (
  .a(a[15:12]),
  .b(b[15:12]),
  .c_in(c2),
  .sum(sum[15:12]),
  .c_out(c3)
);

adder_n #(.N(4)) ADD4 (
  .a(a[19:16]),
  .b(b[19:16]),
  .c_in(c3),
  .sum(sum[19:16]),
  .c_out(c4)
);

adder_n #(.N(4)) ADD5 (
  .a(a[23:20]),
  .b(b[23:20]),
  .c_in(c4),
  .sum(sum[23:20]),
  .c_out(c5)
);

adder_n #(.N(4)) ADD6 (
  .a(a[27:24]),
  .b(b[27:24]),
  .c_in(c5),
  .sum(sum[27:24]),
  .c_out(c6)
);

adder_n #(.N(4)) ADD7 (
  .a(a[28:31]),
  .b(b[28:31]),
  .c_in(c6),
  .sum(sum[28:31]),
  .c_out(c7)
);

endmodule
