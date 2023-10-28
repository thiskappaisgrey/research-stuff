module full_adder
  (
   i_bit1,
   i_bit2,
   i_cin,
   o_sum,
   o_carry
   );
   
   input  i_bit1;
   input  i_bit2;
   input  i_cin;
   output o_sum;
   output o_carry;

   wire	  half_out1;
   wire	  half_out2;
   

   half_adder half_adder1(
			  .i_bit1(i_bit1),
			  .i_bit2(i_bit2),
			  .o_sum(half_out1),
			  .o_carry(half_out2)
			  );
   half_adder half_adder2(
			  .i_bit1(half_out1),
			  .i_bit2(half_out2),
			  .o_sum(o_sum),
			  .o_carry(o_carry)
			  );
   
   
endmodule // full_adder
