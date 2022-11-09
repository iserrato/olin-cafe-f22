`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_sll;
  parameter N = 32; 
  logic [N-1:0] a;
  logic [$clog2(N)-1:0] shamt;
  logic [N-1:0] out;
  

  shift_left_logical #(.N(32)) UUT(
    // .name of module_port(name_of_local_wire_or_logic)
    // to avoid confusion about which port is which
    .in(a), 
    .shamt(shamt), 
    .out(out)
    );

  initial begin
    // Collect waveforms
    $dumpfile("sll.fst");
    $dumpvars(0, UUT);
    
    $display("a        shift       out");
    a = 1;
    shamt = 5'b00001;
    #1 $display("%b %b %b", a, shamt, out);

    a = 1;
    shamt = 5'b00010;
    c_in = 0;
    #1 $display("%b %b %b", a, shamt, out);

    // a = 7919;
    // b = 7907;
    // c_in = 1;
    // #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    // a = 57381048;
    // b = 95729471;
    // c_in = 0;
    // #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    // a = 573812746;
    // b = 1;
    // c_in = 1;
    // #1 $display("%1h %2h %3h | %1h %2h", a, b, c_in, sum, c_out);

    $finish;      
	end

endmodule