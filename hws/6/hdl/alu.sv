`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

case (control)
  ALU_AND: begin 
    adder_n #(.N(N)) ADDER (
        .a(a), .b(b), .c_in(0), .sum(result), .c_out(overflow)
    );
  end
  ALU_OR : begin
    always_comb result = a | b;
  end
  ALU_XOR : begin  
    always_comb result = a ^ b;
  end
  ALU_SLL :begin
    shift_left_logical #(.N(N)) SHIFTER (
        .in(a), .shamt(b), .out(result)
    );
  end
  ALU_SRL  : begin
  end
  ALU_SRA  : begin
  end
  ALU_ADD  : begin
  end
  ALU_SUB  : begin
  end
  ALU_SLT  : begin
  end
  ALU_SLTU : begin
  end
endcase

endmodule