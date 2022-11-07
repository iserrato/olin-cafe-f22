`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;    

generate 
    genvar j;
    
    for (j = 0; j < N; j++) begin: shift_left 
        mux32 #(.N(1)) MUX (
            .in00(in[ 0+j]), .in01(in[ 1+j]), .in02(in[ 2+j]), .in03(in[ 3+j]), 
            .in04(in[ 4+j]), .in05(in[ 5+j]), .in06(in[ 6+j]), .in07(in[ 7+j]), 
            .in08(in[ 8+j]), .in09(in[ 9+j]), .in10(in[10+j]), .in11(in[11+j]), 
            .in12(in[12+j]), .in13(in[13+j]), .in14(in[14+j]), .in15(in[15+j]), 
            .in16(in[16+j]), .in17(in[17+j]), .in18(in[18+j]), .in19(in[19+j]), 
            .in20(in[20+j]), .in21(in[21+j]), .in22(in[22+j]), .in23(in[23+j]), 
            .in24(in[24+j]), .in25(in[25+j]), .in26(in[26+j]), .in27(in[27+j]), 
            .in28(in[28+j]), .in29(in[29+j]), .in30(in[30+j]), .in31(in[31+j]),
            .select(shamt), .out(out[N-j-1])
        );
    end
endgenerate






endmodule
