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

   wire	  half_sum1;
   wire	  half_carry1;
   wire	  half_carry2;
   
   

   half_adder half_adder1(
			  .i_bit1(i_bit1),
			  .i_bit2(i_bit2),
			  .o_sum(half_sum1),
			  .o_carry(half_carry1)
			  );
   half_adder half_adder2(
			  .i_bit1(i_cin),
			  .i_bit2(half_sum1),
			  .o_sum(o_sum),
			  .o_carry(half_carry2)
			  );
   assign o_carry = half_carry1 | half_carry2;
   
   
   // let's make this a proper full adder..
   
   
endmodule // full_adder
