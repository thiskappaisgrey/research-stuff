module test(
        input a,
        input b,
        output d,
        output c
);
        assign d = a & b; 
        assign c = a ^ b;
endmodule
