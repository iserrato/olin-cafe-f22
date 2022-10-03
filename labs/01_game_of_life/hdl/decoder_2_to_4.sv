`timescale 1ns/1ps
module decoder_2_to_4(ena, in, out);

input wire ena;
input wire [1:0] in;
output logic [3:0] out;

logic ena_0;
assign ena_0 = ~in[1] & ena;
logic ena_1;
assign ena_1 = in[1] & ena;
decoder_1_to_2 DECODER1 (
    .ena(ena_0),
    .in(in[0]),
    .out(out[1:0])
);

decoder_1_to_2 DECODER2 (
    .ena(ena_1),
    .in(in[0]),
    .out(out[3:2])   
);

endmodule