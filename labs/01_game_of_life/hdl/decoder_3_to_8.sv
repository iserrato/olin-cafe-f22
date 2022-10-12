`timescale 1ns/1ps
module decoder_3_to_8(ena, in, out);

  input wire ena;
  input wire [2:0] in;
  output logic [7:0] out;


  logic [1:0] ena_out;
  decoder_1_to_2 ENA_DECODER (
    .ena(ena),
    .in(in[2]),
    .out(ena_out[1:0])
  );

  logic ena_0; 
  assign ena_0 = ena_out[0];
  logic ena_1;
  assign ena_1 = ena_out[1];

  decoder_2_to_4 DECODER0 (
    .ena(ena_0),
    .in(in[1:0]),
    .out(out[3:0])
  );

  decoder_2_to_4 DECODER1 (
      .ena(ena_1),
      .in(in[1:0]),
      .out(out[7:4])
  );


endmodule