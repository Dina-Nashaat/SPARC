//-----------------------------------------------------------------------------
//
// Title       : IULogical
// Design      : SPARC
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module IULogical (
	input [31:0] A, B,	 
	input [5:0] op,		 
	output reg [31:0] result, 
	output flags[3:0],
	);
	
	reg icc_n, icc_z, icc_c, icc_v;
	initial begin
		case (op)
			6'b000001:	   						//AND
			result = A & B;
			6'b000101:							//ANDN
			result = A & ~(B);	 				
			6'b000010:							//OR
			result = A | B;
			6'b000110:							//ORN
			result =  A | ~(B);						
			6'b000011:							//XOR
			result = A ^ B;							 
			6'b000111:							//XNOR
			result = ~(A ^ B); 	
			
			6'b010001: 							//ANDcc
			begin
			result = A & B;
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end			 
			6'b010101: 							//ANDNcc
			begin
			result = A & ~(B);
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end
			6'b010010: 							//ORcc
			begin
			result = A | B;
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end
			6'b010110: 							//ORNcc
			begin
			result = A | ~(B);
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end
			6'b010011: 							//XORcc
			begin
			result = A ^ B;
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end
			6'b010111: 							//XNORcc
			begin
			result = ~(A ^ B);
			icc_n = result[31];
			icc_z = (result == 31'b0);
			icc_v = 1'b0;
			icc_c = 1'b0;
			end
		endcase
	end	
	assign flags[0] = icc_c;
	assign flags[1] = icc_v;
	assign flags[2] = icc_z;
	assign flags[3] = icc_n;
endmodule
