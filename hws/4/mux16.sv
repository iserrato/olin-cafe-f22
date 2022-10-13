	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux16(in0, in1, in2, in3, in4, 
			in5, in6, in7, in8, in9, 
			in10, in11, in12, in13, 
			in14, in15, 
			select, out);
	//parameter definitions
	parameter N = 16;
	//port definitions
	input  wire [N-1:0] in0, in1, in2, in3, in4, 
			in5, in6, in7, in8, in9, 
			in10, in11, in12, in13, 
			in14, in15;
	input  logic [3:0] select;
	output logic [(N-1):0] out;

  // python: print(", ".join([f"in{i:02}" for i in range(32)]))

  wire [N-1:0] MUX0_out, MUX1_out, MUX2_out, MUX3_out;
	mux4 #(.N(N)) MUX4_0( 
		.in0(in0), 
		.in1(in1),
    	.in2(in2),
    	.in3(in3),
		.select(select[1:0]), 
		.out(MUX0_out));

	mux4 #(.N(N)) MUX4_1( 
		.in0(in4), 
		.in1(in5),
   		.in2(in6),
   		.in3(in7),
		.select(select[1:0]), 
		.out(MUX1_out));

	mux4 #(.N(N)) MUX4_2( 
		.in0(in8), 
		.in1(in9),
    	.in2(in10),
   		.in3(in11),
		.select(select[1:0]), 
		.out(MUX2_out));

	mux4 #(.N(N)) MUX4_3( 
		.in0(in12), 
		.in1(in13),
		.in2(in14),
   		.in3(in15),
		.select(select[1:0]), 
		.out(MUX3_out));

	mux4 #(.N(N)) MUX4_4(
		.in0(MUX0_out),
		.in1(MUX1_out),
		.in2(MUX2_out),
		.in3(MUX3_out),
		.select(select[3:2]),
		.out(out)
	);

endmodule
