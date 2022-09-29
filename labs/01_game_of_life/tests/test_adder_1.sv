`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_1;
  logic a;
  logic b;
  logic c_in;
  logic sum;
  logic c_out;

  adder_1 UUT(
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
    $dumpfile("adder_1.fst");
    $dumpvars(0, UUT);
    
    a = 0;
    $display("a b c_in | s c_out");
    for (int j = 0; j < 2; j = j + 1) begin 
      b = j[0];
      for (int i = 0; i < 2; i = i + 1) begin
        c_in = i[0];
        #1 $display("%1b %2b %3b | %1b %2b", a, b, c_in, sum, c_out);
      end
    end

    a = 1;
    for (int j = 0; j < 2; j = j + 1) begin 
      b = j[0];
      for (int i = 0; i < 2; i = i + 1) begin
        c_in = i[0];
        #1 $display("%1b %2b %3b | %1b %2b", a, b, c_in, sum, c_out);
      end
    end


        
    $finish;      
	end

endmodule
