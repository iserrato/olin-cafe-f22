/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter;
logic counter_comparator;

comparator_eq #(.N(N)) COMP(
    .a(ticks),
    .b(counter),
    .out(counter_comparator)
);

always_ff @(posedge clk) begin
  if (rst) counter <= 0;
  else counter <= counter + 1;
end

always_ff @(posedge clk) begin
  if (rst) begin 
    out <= 0;
  end
  else begin
    out <= counter_comparator;
  end
end

endmodule
