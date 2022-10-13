	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux32(
  in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, 
  in22, in23, in24, in25, in26, in27, in28, in29, in30, in31,
  select, out
);
	//parameter definitions
	parameter N = 32;
	//port definitions
  // python: print(", ".join([f"in{i:02}" for i in range(32)]))
	input  wire [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
    in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
	input  wire [4:0] select;
	output logic [(N-1):0] out;

  wire [N-1:0] MUX0_out, MUX1_out, MUX2_out;
	mux16 #(.N(N)) MUX16_0( 
		.in0(in00), 
		.in1(in01),
    .in2(in02),
    .in3(in03),
    .in4(in04), 
		.in5(in05),
    .in6(in06),
    .in7(in07),
    .in8(in08), 
		.in9(in09),
    .in10(in10),
    .in11(in11),
    .in12(in12), 
		.in13(in13),
    .in14(in14),
    .in15(in15),
		.select(select[3:0]), 
		.out(MUX0_out));

    mux16 #(.N(N)) MUX16_1( 
		.in0(in16), 
		.in1(in17),
    .in2(in18),
    .in3(in19),
    .in4(in20), 
		.in5(in21),
    .in6(in22),
    .in7(in23),
    .in8(in24), 
		.in9(in25),
    .in10(in26),
    .in11(in27),
    .in12(in28), 
		.in13(in29),
    .in14(in30),
    .in15(in31),
		.select(select[3:0]), 
		.out(MUX1_out));
  
  mux2 #(.N(N)) MUX2_2 (
    .in0(MUX0_out),
    .in1(MUX1_out),
    .select(select[4]),
    .out(out)
  );

endmodule
