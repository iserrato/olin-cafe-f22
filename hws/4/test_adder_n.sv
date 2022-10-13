`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_1;
  parameter N = 32; 
  logic [N-1:0] a;
  logic [N-1:0] b;
  logic c_in;
  logic [N-1:0] sum;
  logic c_out;

  adder_n #(.N(32)) UUT(
    // .name of module_port(name_of_local_wire_or_logic)
    // to avoid confusion about which port is which
    .a(a), 
    .b(b), 
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("adder_n.fst");
    $dumpvars(0, UUT);
    
    $display("a        b       c_in | s         c_out");
    a = 1;
    b = 1;
    c_in = 1;
    #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    a = 7919;
    b = 7907;
    c_in = 0;
    #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    a = 7919;
    b = 7907;
    c_in = 1;
    #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    a = 57381048;
    b = 95729471;
    c_in = 0;
    #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    a = 573812746;
    b = 1;
    c_in = 1;
    #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    $finish;      
	end

endmodule
