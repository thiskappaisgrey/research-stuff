module alu (
  input logic [4:0] i_a,
  input logic [4:0] i_b,
  input logic [1:0] i_control, // Control signal to specify the operation
  output logic [4:0] o_res
  
);
  always_comb  begin
    case (i_control)
      // 4'b0000: o_res = i_a + i_b; // Addition
      2'b00: o_res = i_a + i_b; // Bitwise XOR
      2'b01: o_res = i_a - i_b; // Subtraction
      2'b10: o_res = i_a | i_b; // Bitwise OR
      2'b11: o_res = i_a & i_b; // Bitwise AND
    endcase
  end
endmodule

