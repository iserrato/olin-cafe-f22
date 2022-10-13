	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux2(in0, in1, select, out);
	//parameter definitions
	parameter N = 1;
	//port definitions
  // python: print(", ".join([f"in{i:02}" for i in range(32)]))
	input  wire [(N-1):0] in0, in1;
	input  logic select;
	output logic [(N-1):0] out;

  always_comb out = select ? in1 : in0;

endmodule
