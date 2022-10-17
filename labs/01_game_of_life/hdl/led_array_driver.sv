`default_nettype none
`timescale 1ns/1ps

module led_array_driver(ena, x, cells, rows, cols);
// Module I/O and parameters
parameter N=5; // Size of Conway Cell Grid.
parameter ROWS=N;
parameter COLS=N;

// I/O declarations
input wire ena;
input wire [$clog2(N):0] x;
input wire [N*N-1:0] cells;
output logic [N-1:0] rows;
output logic [N-1:0] cols;


// You can check parameters with the $error macro within initial blocks.
initial begin
  if ((N <= 0) || (N > 8)) begin
    $error("N must be within 0 and 8.");
  end
  if (ROWS != COLS) begin
    $error("Non square led arrays are not supported. (%dx%d)", ROWS, COLS);
  end
  if (ROWS < N) begin
    $error("ROWS/COLS must be >= than the size of the Conway Grid.");
  end
end

// wire [N-1:0] x_decoded;
decoder_3_to_8 COL_DECODER(ena, x, cols);
always_comb begin: ROW_LOGIC
  rows[0] = ~(cells[0] | cells[1]| cells[2]| cells[3]| cells[4]);
  rows[1] = ~(cells[5] | cells[6]| cells[7]| cells[8]| cells[9]);
  rows[2] = ~(cells[10] | cells[11]| cells[12]| cells[13]| cells[14]);
  rows[3] = ~(cells[15] | cells[16]| cells[17]| cells[18]| cells[19]);
  rows[4] = ~(cells[20] | cells[21]| cells[22]| cells[23]| cells[24]);
end

endmodule
