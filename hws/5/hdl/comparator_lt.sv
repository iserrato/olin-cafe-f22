module comparator_lt(a, b, out, sum, first_comp);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out, first_comp;
output wire [N-2:0] sum;

// Using only *structural* combinational logic, make a module that computes if a is less than b!
// Note: this assumes that the two inputs are signed: aka should be interpreted as two's complement.

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.

logic [N-1:0] b_bar;
assign b_bar = ~b;
logic carries;
// wire signed [N-1:0] sum;
// logic first_comp;

comparator_eq #(.N(1)) COMP(
    .a(a[N-1]),
    .b(b[N-1]),
    .out(first_comp)
);

adder_n #(.N(N-1)) SUB (
    .a(a[N-2:0]),
    .b(b_bar[N-2:0]),
    .c_in(1'sb1),
    .sum(sum),
    .c_out(carries)
);

always_comb out = first_comp ? sum[N-2] : a[N-1];

endmodule


