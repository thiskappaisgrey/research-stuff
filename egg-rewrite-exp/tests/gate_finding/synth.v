(* top =  1  *)
(* src = "./test.v:1.1-8.10" *)
module test(a, b, c);
  wire _0_;
  wire _1_;
  wire _2_;
  (* src = "./test.v:2.15-2.16" *)
  input a;
  wire a;
  (* src = "./test.v:3.15-3.16" *)
  input b;
  wire b;
  (* src = "./test.v:4.16-4.17" *)
  output c;
  wire c;
  NOR _3_ (
    .A(a),
    .B(b),
    .Y(_0_)
  );
  NAND _4_ (
    .A(a),
    .B(b),
    .Y(_1_)
  );
  NOT _5_ (
    .A(_1_),
    .Y(_2_)
  );
  NOR _6_ (
    .A(_0_),
    .B(_2_),
    .Y(c)
  );
endmodule
