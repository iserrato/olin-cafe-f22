`timescale 1ns/1ps
`default_nettype none

module practice(rst, clk, ena, seed, out);
    input wire rst;
    input wire clk;
    input wire ena;
    input wire seed;
    output logic out;

    logic XOR_out, d, d0, q0, d1, q1, d2;

    mux2 MUX0 (.in0(seed),
        .in1(XOR_out), 
        .select(ena), 
        .out(d));

	always_comb begin 
        XOR_out = d1 ^ d2;
        d0 = ~rst ? d : 1'b0;
        d1 = ~rst ? q0 : 1'b0;
        d2 = ~rst ? q1 : 1'b0;
    end

    always_ff @(posedge clk) begin
        q0 <= d0;
        q1 <= d1;
        out <= d2;
    end 
    
endmodule
