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
  if (rst) begin
    counter <= 0;
    out <= 0;
  end
  else begin 
    counter <= counter + 1;
    if (ena) begin
      out <= counter_comparator;
    end
    if (counter_comparator) begin
      counter <= 0;
    end

  end
end

endmodule
