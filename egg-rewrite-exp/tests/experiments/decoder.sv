// The "decoder" is a component that breaks the "input" into smaller stuff
module decoder (
  input logic [11:0] i_instr,
  output logic [1:0] o_op,
  output logic [4:0] o_a,
  output logic [4:0] o_b
);
        assign o_op = i_instr[1:0];
        assign o_a = i_instr[6:2];
        assign o_b = i_instr[11:7];
endmodule
