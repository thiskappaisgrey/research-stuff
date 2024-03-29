module NOT(A, Y);
input A;
output Y = ~A;
endmodule

module XOR(A, B, Y);
input A, B;
// output Y = (A & ~B) | (~A & B);
output Y = A ^ B;
endmodule
module AND(A, B, Y);
input A, B;
output Y = A & B;
endmodule



module NAND(A, B, Y);
input A, B;
output Y = ~(A & B);
endmodule

module NOR(A, B, Y);
input A, B;
output Y = ~(A | B);
endmodule

module DFF(C, D, Q);
input C, D;
output reg Q;
always @(posedge C)
	Q <= D;
endmodule

