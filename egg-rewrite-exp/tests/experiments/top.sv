module top (
        input logic [11:0] i_instr,
        output logic [4:0] o_out
        );
    wire o_op;
    wire o_a;
    wire o_b;
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
