	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux4(in0, in1, in2, in3, select, out);
	//parameter definitions
	parameter N = 4;
	//port definitions
	input  wire [N-1:0] in0, in1, in2, in3;
	input  logic [1:0] select;
	output logic [(N-1):0] out;

  // python: print(", ".join([f"in{i:02}" for i in range(32)]))

	wire [N-1:0] MUX0_out, MUX1_out;
	mux2 #(.N(N)) MUX0( 
		.in0(in0), 
		.in1(in1),
		.select(select[0]), 
		.out(MUX0_out));

	mux2 #(.N(N)) MUX1( 
		.in0(in2), 
		.in1(in3),
		.select(select[0]), 
		.out(MUX1_out));

	mux2 #(.N(N)) MUX2( 
		.in0(MUX0_out), 
		.in1(MUX1_out),
		.select(select[1]), 
		.out(out));

endmodule
