module top (
        input logic [3:0] i_instr,
        output logic  o_out
        );
    logic [1:0] o_op;
    logic  o_a;
    logic  o_b;
    decoder decoder(.i_instr (i_instr), 
          .o_op (o_op),
          .o_a (o_a),
          .o_b (o_b)
          );
    alu alu(
           .i_a (o_a), 
          .i_b (o_b),
          .i_control (o_op),
          .o_res (o_out)
          );
endmodule
