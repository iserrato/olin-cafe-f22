// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

typedef enum logic {COUNTING_UP = 1'b0, COUNTING_DOWN = 1'b1} state_t;
state_t state;

always_ff @(posedge clk) begin
  if (rst) begin
    out <= 0;
    state <= COUNTING_UP;
  end
  else begin 
    if (ena) begin
      case (state)
        COUNTING_DOWN: begin
          if (out == 0) begin
            state <= COUNTING_UP;
            out <= out + 1;
          end
          else out <= out - 1;
        end
        COUNTING_UP: begin
          if (out == '1) begin
            state <= COUNTING_DOWN;
            out <= out - 1;
          end
          else out <= out + 1;
        end
        default: 
        state <= COUNTING_UP;
      endcase
    end
  end
end

endmodule