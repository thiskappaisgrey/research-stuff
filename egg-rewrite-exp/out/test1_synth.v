/* Generated by Yosys 0.35+29 (git sha1 2a18fe5fa, clang++  -fPIC -Os) */

(* top =  1  *)
(* src = "tests/gate_finding/test1.v:1.1-9.10" *)
module test(a, b, d, c);
  (* src = "tests/gate_finding/test1.v:2.15-2.16" *)
  wire _00_;
  (* src = "./tests/gate_finding/mycells-not-working.v:3.7-3.8" *)
  wire _01_;
  (* src = "./tests/gate_finding/mycells-not-working.v:4.8-4.9" *)
  wire _02_;
  (* src = "./tests/gate_finding/mycells-not-working.v:3.7-3.8" *)
  wire _03_;
  (* src = "./tests/gate_finding/mycells-not-working.v:4.8-4.9" *)
  wire _04_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.7-13.8" *)
  wire _05_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.10-13.11" *)
  wire _06_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.8-14.9" *)
  wire _07_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.7-13.8" *)
  wire _08_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.10-13.11" *)
  wire _09_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.8-14.9" *)
  wire _10_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.7-13.8" *)
  wire _11_;
  (* src = "./tests/gate_finding/mycells-not-working.v:13.10-13.11" *)
  wire _12_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.8-14.9" *)
  wire _13_;
  (* src = "tests/gate_finding/test1.v:3.15-3.16" *)
  wire _14_;
  (* src = "tests/gate_finding/test1.v:5.16-5.17" *)
  wire _15_;
  (* src = "tests/gate_finding/test1.v:4.16-4.17" *)
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  (* src = "./tests/gate_finding/mycells-not-working.v:4.12-4.14" *)
  wire _20_;
  (* src = "./tests/gate_finding/mycells-not-working.v:4.12-4.14" *)
  wire _21_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *)
  wire _22_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *)
  wire _23_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *)
  wire _24_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *)
  wire _25_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *)
  wire _26_;
  (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *)
  wire _27_;
  (* src = "tests/gate_finding/test1.v:2.15-2.16" *)
  input a;
  wire a;
  (* src = "tests/gate_finding/test1.v:3.15-3.16" *)
  input b;
  wire b;
  (* src = "tests/gate_finding/test1.v:5.16-5.17" *)
  output c;
  wire c;
  (* src = "tests/gate_finding/test1.v:4.16-4.17" *)
  output d;
  wire d;
  assign _20_ = ~ (* src = "./tests/gate_finding/mycells-not-working.v:4.12-4.14" *) _01_;
  assign _21_ = ~ (* src = "./tests/gate_finding/mycells-not-working.v:4.12-4.14" *) _03_;
  assign _22_ = ~ (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *) _23_;
  assign _23_ = _05_ | (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *) _06_;
  assign _24_ = ~ (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *) _25_;
  assign _25_ = _08_ | (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *) _09_;
  assign _26_ = ~ (* src = "./tests/gate_finding/mycells-not-working.v:14.12-14.20" *) _27_;
  assign _27_ = _11_ | (* src = "./tests/gate_finding/mycells-not-working.v:14.14-14.19" *) _12_;
  assign _00_ = a;
  assign _14_ = b;
  assign d = _16_;
  assign c = _15_;
  assign _13_ = _26_;
  assign _11_ = _16_;
  assign _12_ = _19_;
  assign _15_ = _13_;
  assign _10_ = _24_;
  assign _08_ = _00_;
  assign _09_ = _14_;
  assign _19_ = _10_;
  assign _07_ = _22_;
  assign _05_ = _17_;
  assign _06_ = _18_;
  assign _16_ = _07_;
  assign _04_ = _21_;
  assign _03_ = _14_;
  assign _18_ = _04_;
  assign _02_ = _20_;
  assign _01_ = _00_;
  assign _17_ = _02_;
endmodule
