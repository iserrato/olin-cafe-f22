`timescale 1ns/1ps
`default_nettype none

module test_mux4;

// logics for all inputs to the UUT
parameter N = 8;
logic [N-1:0] in0, in1, in2, in3;
logic [1:0] select;
// wires for all outputs
wire [N-1:0] out;

mux4 #(.N(N)) UUT(
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .out(out),
  .select(select)
);

initial begin
  $dumpfile("mux4.fst");
  $dumpvars(0, UUT);

  in0 = 8'd1;
  in1 = 8'd2;
  in2 = 8'd3;
  in3 = 8'd4;
  $display("Running simulation...");

  // int i is 32 bits, want only 2 bits of that.
  for(int i = 0; i < 4; i = i + 1) begin
    select = i[1:0]; // get the lower two bits of i.
    #10;
  end
  
  $display("... done. Use gtkwave to see what this does!");
  $finish;
end

endmodule
