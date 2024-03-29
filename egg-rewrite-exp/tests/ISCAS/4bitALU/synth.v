/* Generated by Yosys 0.35+29 (git sha1 c3621ce19, gcc 12.3.0 -fPIC -Os) */

module Circuit74181(S, A, B, M, CNb, F, X, Y, CN4b, AEB);
  wire _000_;
  wire _001_;
  wire _002_;
  wire _003_;
  wire _004_;
  wire _005_;
  wire _006_;
  wire _007_;
  wire _008_;
  wire _009_;
  wire _010_;
  wire _011_;
  wire _012_;
  wire _013_;
  wire _014_;
  wire _015_;
  wire _016_;
  wire _017_;
  wire _018_;
  wire _019_;
  wire _020_;
  wire _021_;
  wire _022_;
  wire _023_;
  wire _024_;
  wire _025_;
  wire _026_;
  wire _027_;
  wire _028_;
  wire _029_;
  wire _030_;
  wire _031_;
  wire _032_;
  wire _033_;
  wire _034_;
  wire _035_;
  wire _036_;
  wire _037_;
  wire _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire _060_;
  wire _061_;
  wire _062_;
  wire _063_;
  wire _064_;
  wire _065_;
  wire _066_;
  wire _067_;
  wire _068_;
  wire _069_;
  wire _070_;
  wire _071_;
  wire _072_;
  wire _073_;
  wire _074_;
  wire _075_;
  wire _076_;
  wire _077_;
  wire _078_;
  wire _079_;
  wire _080_;
  wire _081_;
  wire _082_;
  wire _083_;
  wire _084_;
  wire _085_;
  wire _086_;
  wire _087_;
  wire _088_;
  wire _089_;
  wire _090_;
  wire _091_;
  wire _092_;
  wire _093_;
  wire _094_;
  wire _095_;
  wire _096_;
  wire _097_;
  wire _098_;
  wire _099_;
  wire _100_;
  wire _101_;
  wire _102_;
  wire _103_;
  input [3:0] A;
  wire [3:0] A;
  output AEB;
  wire AEB;
  input [3:0] B;
  wire [3:0] B;
  output CN4b;
  wire CN4b;
  input CNb;
  wire CNb;
  wire [3:0] \Ckt74181.A ;
  wire \Ckt74181.AEB ;
  wire [3:0] \Ckt74181.B ;
  wire [3:0] \Ckt74181.Bb ;
  wire [3:0] \Ckt74181.C ;
  wire [3:0] \Ckt74181.CLAmod3.C ;
  wire \Ckt74181.CLAmod3.CN4b ;
  wire \Ckt74181.CLAmod3.CNb ;
  wire \Ckt74181.CLAmod3.CNbGb0 ;
  wire \Ckt74181.CLAmod3.CNbGb01 ;
  wire \Ckt74181.CLAmod3.CNbGb012 ;
  wire [3:0] \Ckt74181.CLAmod3.Gb ;
  wire [3:0] \Ckt74181.CLAmod3.Pb ;
  wire \Ckt74181.CLAmod3.Pb0 ;
  wire \Ckt74181.CLAmod3.Pb0Gb1 ;
  wire \Ckt74181.CLAmod3.Pb0Gb12 ;
  wire \Ckt74181.CLAmod3.Pb0Gb123 ;
  wire \Ckt74181.CLAmod3.Pb1 ;
  wire \Ckt74181.CLAmod3.Pb1Gb2 ;
  wire \Ckt74181.CLAmod3.Pb1Gb23 ;
  wire \Ckt74181.CLAmod3.Pb2 ;
  wire \Ckt74181.CLAmod3.Pb2Gb3 ;
  wire \Ckt74181.CLAmod3.Pb3 ;
  wire \Ckt74181.CLAmod3.X ;
  wire \Ckt74181.CLAmod3.XCNb ;
  wire \Ckt74181.CLAmod3.Y ;
  wire \Ckt74181.CN4b ;
  wire \Ckt74181.CNb ;
  wire [3:0] \Ckt74181.D ;
  wire [3:0] \Ckt74181.Dmod2.A ;
  wire [3:0] \Ckt74181.Dmod2.B ;
  wire [3:0] \Ckt74181.Dmod2.BS0 ;
  wire [3:0] \Ckt74181.Dmod2.Bb ;
  wire [3:0] \Ckt74181.Dmod2.BbS1 ;
  wire [3:0] \Ckt74181.Dmod2.D ;
  wire [3:0] \Ckt74181.Dmod2.S ;
  wire [3:0] \Ckt74181.E ;
  wire [3:0] \Ckt74181.Emod1.A ;
  wire [3:0] \Ckt74181.Emod1.ABS3 ;
  wire [3:0] \Ckt74181.Emod1.ABbS2 ;
  wire [3:0] \Ckt74181.Emod1.B ;
  wire [3:0] \Ckt74181.Emod1.Bb ;
  wire [3:0] \Ckt74181.Emod1.E ;
  wire [3:0] \Ckt74181.Emod1.S ;
  wire [3:0] \Ckt74181.F ;
  wire \Ckt74181.M ;
  wire [3:0] \Ckt74181.S ;
  wire \Ckt74181.Summod4.AEB ;
  wire [3:0] \Ckt74181.Summod4.C ;
  wire [3:0] \Ckt74181.Summod4.CM ;
  wire [3:0] \Ckt74181.Summod4.D ;
  wire [3:0] \Ckt74181.Summod4.E ;
  wire [3:0] \Ckt74181.Summod4.EXD ;
  wire [3:0] \Ckt74181.Summod4.F ;
  wire \Ckt74181.Summod4.M ;
  wire \Ckt74181.X ;
  wire \Ckt74181.Y ;
  output [3:0] F;
  wire [3:0] F;
  input M;
  wire M;
  input [3:0] S;
  wire [3:0] S;
  output X;
  wire X;
  output Y;
  wire Y;
  assign _000_ = \Ckt74181.CLAmod3.CNb  & \Ckt74181.CLAmod3.Gb [0];
  assign _001_ = \Ckt74181.CLAmod3.Pb [0] & \Ckt74181.CLAmod3.Gb [1];
  assign _002_ = \Ckt74181.CLAmod3.CNb  & \Ckt74181.CLAmod3.Gb [0];
  assign _003_ = _002_ & \Ckt74181.CLAmod3.Gb [1];
  assign _004_ = \Ckt74181.CLAmod3.Pb [1] & \Ckt74181.CLAmod3.Gb [2];
  assign _005_ = \Ckt74181.CLAmod3.Pb [0] & \Ckt74181.CLAmod3.Gb [1];
  assign _006_ = _005_ & \Ckt74181.CLAmod3.Gb [2];
  assign _007_ = \Ckt74181.CLAmod3.CNb  & \Ckt74181.CLAmod3.Gb [0];
  assign _008_ = _007_ & \Ckt74181.CLAmod3.Gb [1];
  assign _009_ = _008_ & \Ckt74181.CLAmod3.Gb [2];
  assign _010_ = \Ckt74181.CLAmod3.Pb [2] & \Ckt74181.CLAmod3.Gb [3];
  assign _011_ = \Ckt74181.CLAmod3.Pb [1] & \Ckt74181.CLAmod3.Gb [2];
  assign _012_ = _011_ & \Ckt74181.CLAmod3.Gb [3];
  assign _013_ = \Ckt74181.CLAmod3.Pb [0] & \Ckt74181.CLAmod3.Gb [1];
  assign _014_ = _013_ & \Ckt74181.CLAmod3.Gb [2];
  assign _015_ = _014_ & \Ckt74181.CLAmod3.Gb [3];
  assign _016_ = \Ckt74181.CLAmod3.Gb [0] & \Ckt74181.CLAmod3.Gb [1];
  assign _017_ = _016_ & \Ckt74181.CLAmod3.Gb [2];
  assign _018_ = _017_ & \Ckt74181.CLAmod3.Gb [3];
  assign _019_ = \Ckt74181.CLAmod3.Gb [0] & \Ckt74181.CLAmod3.Gb [1];
  assign _020_ = _019_ & \Ckt74181.CLAmod3.Gb [2];
  assign _021_ = _020_ & \Ckt74181.CLAmod3.Gb [3];
  assign _022_ = _021_ & \Ckt74181.CLAmod3.CNb ;
  assign _023_ = \Ckt74181.CLAmod3.Y  & \Ckt74181.CLAmod3.XCNb ;
  assign _024_ = ~ _018_;
  assign _025_ = ~ _034_;
  assign _026_ = ~ _022_;
  assign _027_ = ~ _023_;
  assign _028_ = ~ _037_;
  assign _029_ = ~ _039_;
  assign _030_ = ~ _040_;
  assign _031_ = ~ \Ckt74181.CLAmod3.CNb ;
  assign _032_ = \Ckt74181.CLAmod3.Pb3  | \Ckt74181.CLAmod3.Pb2Gb3 ;
  assign _033_ = _032_ | \Ckt74181.CLAmod3.Pb1Gb23 ;
  assign _034_ = _033_ | \Ckt74181.CLAmod3.Pb0Gb123 ;
  assign _035_ = \Ckt74181.CLAmod3.Pb2  | \Ckt74181.CLAmod3.Pb1Gb2 ;
  assign _036_ = _035_ | \Ckt74181.CLAmod3.Pb0Gb12 ;
  assign _037_ = _036_ | \Ckt74181.CLAmod3.CNbGb012 ;
  assign _038_ = \Ckt74181.CLAmod3.Pb1  | \Ckt74181.CLAmod3.Pb0Gb1 ;
  assign _039_ = _038_ | \Ckt74181.CLAmod3.CNbGb01 ;
  assign _040_ = \Ckt74181.CLAmod3.Pb0  | \Ckt74181.CLAmod3.CNbGb0 ;
  assign _041_ = \Ckt74181.Dmod2.Bb [0] & \Ckt74181.Dmod2.S [1];
  assign _042_ = \Ckt74181.Dmod2.Bb [1] & \Ckt74181.Dmod2.S [1];
  assign _043_ = \Ckt74181.Dmod2.Bb [2] & \Ckt74181.Dmod2.S [1];
  assign _044_ = \Ckt74181.Dmod2.Bb [3] & \Ckt74181.Dmod2.S [1];
  assign _045_ = \Ckt74181.Dmod2.B [0] & \Ckt74181.Dmod2.S [0];
  assign _046_ = \Ckt74181.Dmod2.B [1] & \Ckt74181.Dmod2.S [0];
  assign _047_ = \Ckt74181.Dmod2.B [2] & \Ckt74181.Dmod2.S [0];
  assign _048_ = \Ckt74181.Dmod2.B [3] & \Ckt74181.Dmod2.S [0];
  assign _049_ = ~ _054_;
  assign _050_ = ~ _056_;
  assign _051_ = ~ _058_;
  assign _052_ = ~ _060_;
  assign _053_ = \Ckt74181.Dmod2.BbS1 [0] | \Ckt74181.Dmod2.BS0 [0];
  assign _054_ = _053_ | \Ckt74181.Dmod2.A [0];
  assign _055_ = \Ckt74181.Dmod2.BbS1 [1] | \Ckt74181.Dmod2.BS0 [1];
  assign _056_ = _055_ | \Ckt74181.Dmod2.A [1];
  assign _057_ = \Ckt74181.Dmod2.BbS1 [2] | \Ckt74181.Dmod2.BS0 [2];
  assign _058_ = _057_ | \Ckt74181.Dmod2.A [2];
  assign _059_ = \Ckt74181.Dmod2.BbS1 [3] | \Ckt74181.Dmod2.BS0 [3];
  assign _060_ = _059_ | \Ckt74181.Dmod2.A [3];
  assign _061_ = \Ckt74181.Emod1.A [0] & \Ckt74181.Emod1.B [0];
  assign _062_ = _061_ & \Ckt74181.Emod1.S [3];
  assign _063_ = \Ckt74181.Emod1.A [1] & \Ckt74181.Emod1.B [1];
  assign _064_ = _063_ & \Ckt74181.Emod1.S [3];
  assign _065_ = \Ckt74181.Emod1.A [2] & \Ckt74181.Emod1.B [2];
  assign _066_ = _065_ & \Ckt74181.Emod1.S [3];
  assign _067_ = \Ckt74181.Emod1.A [3] & \Ckt74181.Emod1.B [3];
  assign _068_ = _067_ & \Ckt74181.Emod1.S [3];
  assign _069_ = _070_ & \Ckt74181.Emod1.S [2];
  assign _070_ = \Ckt74181.Emod1.A [0] & \Ckt74181.Emod1.Bb [0];
  assign _071_ = \Ckt74181.Emod1.A [1] & \Ckt74181.Emod1.Bb [1];
  assign _072_ = _071_ & \Ckt74181.Emod1.S [2];
  assign _073_ = \Ckt74181.Emod1.A [2] & \Ckt74181.Emod1.Bb [2];
  assign _074_ = _073_ & \Ckt74181.Emod1.S [2];
  assign _075_ = \Ckt74181.Emod1.A [3] & \Ckt74181.Emod1.Bb [3];
  assign _076_ = _075_ & \Ckt74181.Emod1.S [2];
  assign _077_ = ~ _085_;
  assign _078_ = ~ _086_;
  assign _079_ = ~ _087_;
  assign _080_ = ~ _088_;
  assign _081_ = ~ \Ckt74181.Emod1.B [0];
  assign _082_ = ~ \Ckt74181.Emod1.B [1];
  assign _083_ = ~ \Ckt74181.Emod1.B [2];
  assign _084_ = ~ \Ckt74181.Emod1.B [3];
  assign _085_ = \Ckt74181.Emod1.ABS3 [0] | \Ckt74181.Emod1.ABbS2 [0];
  assign _086_ = \Ckt74181.Emod1.ABS3 [1] | \Ckt74181.Emod1.ABbS2 [1];
  assign _087_ = \Ckt74181.Emod1.ABS3 [2] | \Ckt74181.Emod1.ABbS2 [2];
  assign _088_ = \Ckt74181.Emod1.ABS3 [3] | \Ckt74181.Emod1.ABbS2 [3];
  assign _089_ = \Ckt74181.Summod4.F [0] & \Ckt74181.Summod4.F [1];
  assign _090_ = _089_ & \Ckt74181.Summod4.F [2];
  assign _091_ = _090_ & \Ckt74181.Summod4.F [3];
  assign _092_ = \Ckt74181.Summod4.C [0] | \Ckt74181.Summod4.M ;
  assign _093_ = \Ckt74181.Summod4.C [1] | \Ckt74181.Summod4.M ;
  assign _094_ = \Ckt74181.Summod4.C [2] | \Ckt74181.Summod4.M ;
  assign _095_ = \Ckt74181.Summod4.C [3] | \Ckt74181.Summod4.M ;
  assign _096_ = \Ckt74181.Summod4.E [0] ^ \Ckt74181.Summod4.D [0];
  assign _097_ = \Ckt74181.Summod4.E [1] ^ \Ckt74181.Summod4.D [1];
  assign _098_ = \Ckt74181.Summod4.E [2] ^ \Ckt74181.Summod4.D [2];
  assign _099_ = \Ckt74181.Summod4.E [3] ^ \Ckt74181.Summod4.D [3];
  assign _100_ = \Ckt74181.Summod4.EXD [0] ^ \Ckt74181.Summod4.CM [0];
  assign _101_ = \Ckt74181.Summod4.EXD [1] ^ \Ckt74181.Summod4.CM [1];
  assign _102_ = \Ckt74181.Summod4.EXD [2] ^ \Ckt74181.Summod4.CM [2];
  assign _103_ = \Ckt74181.Summod4.EXD [3] ^ \Ckt74181.Summod4.CM [3];
  assign \Ckt74181.Emod1.ABS3 [0] = _062_;
  assign \Ckt74181.Emod1.ABS3 [1] = _064_;
  assign \Ckt74181.Emod1.ABS3 [2] = _066_;
  assign \Ckt74181.Emod1.ABS3 [3] = _068_;
  assign \Ckt74181.Emod1.ABbS2 [0] = _069_;
  assign \Ckt74181.Emod1.ABbS2 [1] = _072_;
  assign \Ckt74181.Emod1.ABbS2 [2] = _074_;
  assign \Ckt74181.Emod1.ABbS2 [3] = _076_;
  assign \Ckt74181.Emod1.E [0] = _077_;
  assign \Ckt74181.Emod1.E [1] = _078_;
  assign \Ckt74181.Emod1.E [2] = _079_;
  assign \Ckt74181.Emod1.E [3] = _080_;
  assign \Ckt74181.Emod1.Bb [0] = _081_;
  assign \Ckt74181.Emod1.Bb [1] = _082_;
  assign \Ckt74181.Emod1.Bb [2] = _083_;
  assign \Ckt74181.Emod1.Bb [3] = _084_;
  assign \Ckt74181.Emod1.A  = \Ckt74181.A ;
  assign \Ckt74181.Emod1.B  = \Ckt74181.B ;
  assign \Ckt74181.Emod1.S  = \Ckt74181.S ;
  assign \Ckt74181.E  = \Ckt74181.Emod1.E ;
  assign \Ckt74181.Bb  = \Ckt74181.Emod1.Bb ;
  assign \Ckt74181.Dmod2.BbS1 [0] = _041_;
  assign \Ckt74181.Dmod2.BbS1 [1] = _042_;
  assign \Ckt74181.Dmod2.BbS1 [2] = _043_;
  assign \Ckt74181.Dmod2.BbS1 [3] = _044_;
  assign \Ckt74181.Dmod2.BS0 [0] = _045_;
  assign \Ckt74181.Dmod2.BS0 [1] = _046_;
  assign \Ckt74181.Dmod2.BS0 [2] = _047_;
  assign \Ckt74181.Dmod2.BS0 [3] = _048_;
  assign \Ckt74181.Dmod2.D [0] = _049_;
  assign \Ckt74181.Dmod2.D [1] = _050_;
  assign \Ckt74181.Dmod2.D [2] = _051_;
  assign \Ckt74181.Dmod2.D [3] = _052_;
  assign \Ckt74181.Dmod2.A  = \Ckt74181.A ;
  assign \Ckt74181.Dmod2.B  = \Ckt74181.B ;
  assign \Ckt74181.Dmod2.Bb  = \Ckt74181.Bb ;
  assign \Ckt74181.Dmod2.S  = \Ckt74181.S ;
  assign \Ckt74181.D  = \Ckt74181.Dmod2.D ;
  assign \Ckt74181.CLAmod3.CNbGb0  = _000_;
  assign \Ckt74181.CLAmod3.Pb0Gb1  = _001_;
  assign \Ckt74181.CLAmod3.CNbGb01  = _003_;
  assign \Ckt74181.CLAmod3.Pb1Gb2  = _004_;
  assign \Ckt74181.CLAmod3.Pb0Gb12  = _006_;
  assign \Ckt74181.CLAmod3.CNbGb012  = _009_;
  assign \Ckt74181.CLAmod3.Pb2Gb3  = _010_;
  assign \Ckt74181.CLAmod3.Pb1Gb23  = _012_;
  assign \Ckt74181.CLAmod3.Pb0Gb123  = _015_;
  assign \Ckt74181.CLAmod3.X  = _024_;
  assign \Ckt74181.CLAmod3.Y  = _025_;
  assign \Ckt74181.CLAmod3.XCNb  = _026_;
  assign \Ckt74181.CLAmod3.CN4b  = _027_;
  assign \Ckt74181.CLAmod3.C [3] = _028_;
  assign \Ckt74181.CLAmod3.C [2] = _029_;
  assign \Ckt74181.CLAmod3.C [1] = _030_;
  assign \Ckt74181.CLAmod3.C [0] = _031_;
  assign \Ckt74181.CLAmod3.Pb0  = \Ckt74181.CLAmod3.Pb [0];
  assign \Ckt74181.CLAmod3.Pb1  = \Ckt74181.CLAmod3.Pb [1];
  assign \Ckt74181.CLAmod3.Pb2  = \Ckt74181.CLAmod3.Pb [2];
  assign \Ckt74181.CLAmod3.Pb3  = \Ckt74181.CLAmod3.Pb [3];
  assign \Ckt74181.CLAmod3.Gb  = \Ckt74181.E ;
  assign \Ckt74181.CLAmod3.Pb  = \Ckt74181.D ;
  assign \Ckt74181.CLAmod3.CNb  = \Ckt74181.CNb ;
  assign \Ckt74181.C  = \Ckt74181.CLAmod3.C ;
  assign \Ckt74181.X  = \Ckt74181.CLAmod3.X ;
  assign \Ckt74181.Y  = \Ckt74181.CLAmod3.Y ;
  assign \Ckt74181.CN4b  = \Ckt74181.CLAmod3.CN4b ;
  assign \Ckt74181.Summod4.EXD [0] = _096_;
  assign \Ckt74181.Summod4.EXD [1] = _097_;
  assign \Ckt74181.Summod4.EXD [2] = _098_;
  assign \Ckt74181.Summod4.EXD [3] = _099_;
  assign \Ckt74181.Summod4.CM [0] = _092_;
  assign \Ckt74181.Summod4.CM [1] = _093_;
  assign \Ckt74181.Summod4.CM [2] = _094_;
  assign \Ckt74181.Summod4.CM [3] = _095_;
  assign \Ckt74181.Summod4.F [0] = _100_;
  assign \Ckt74181.Summod4.F [1] = _101_;
  assign \Ckt74181.Summod4.F [2] = _102_;
  assign \Ckt74181.Summod4.F [3] = _103_;
  assign \Ckt74181.Summod4.AEB  = _091_;
  assign \Ckt74181.Summod4.E  = \Ckt74181.E ;
  assign \Ckt74181.Summod4.D  = \Ckt74181.D ;
  assign \Ckt74181.Summod4.C  = \Ckt74181.C ;
  assign \Ckt74181.Summod4.M  = \Ckt74181.M ;
  assign \Ckt74181.F  = \Ckt74181.Summod4.F ;
  assign \Ckt74181.AEB  = \Ckt74181.Summod4.AEB ;
  assign \Ckt74181.S  = S;
  assign \Ckt74181.A  = A;
  assign \Ckt74181.B  = B;
  assign \Ckt74181.M  = M;
  assign \Ckt74181.CNb  = CNb;
  assign F = \Ckt74181.F ;
  assign X = \Ckt74181.X ;
  assign Y = \Ckt74181.Y ;
  assign CN4b = \Ckt74181.CN4b ;
  assign AEB = \Ckt74181.AEB ;
endmodule
