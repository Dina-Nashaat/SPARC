//-----------------------------------------------------------------------------
//
// Title       : IUAdder
// Design      : SPARC
// Author      : Dina
//
//-----------------------------------------------------------------------------
//
// File        : IUAdder.v
// Generated   : Thu Jun 13 01:48:21 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module IUAdder (
	input [31:0] A, B,	 
	input [5:0] op,		 
	input carry,
	output [31:0] result,
	output [4:0] flags,	  					//[n, z, v, c]
	);					
	
	reg [32:0] sum;	 
	reg icc_n, icc_z, icc_c, icc_v;
	initial begin 	   	
		case (op)
			6'b000000: sum = A + B;	  								//ADD
			6'b010000:												//ADDcc
			begin
				sum = A + B;   
				icc_n = sum[31];
				icc_z = (sum == 32'b0);
				icc_c = sum[32];
				icc_v = ~(A[31] ^ B[31]) & (sum[31] ^ A[31]);
			end
			6'b001000: sum = A + B + carry;							 //ADDx
			6'b011000:												 //ADDxcc
			begin
				sum = A + B + carry;
				icc_n = sum[31];
				icc_z = (sum == 32'b0);
				icc_c = sum[32];
				icc_v = ~(A[31] ^ B[31]) & (sum[31] ^ A[31]);
			end	 
			6'b000100: sum = A - B;									 //SUB
			6'b010100: 												 //SUBcc
			begin
				sum = A - B;
				icc_n = sum[31];
				icc_z = (sum == 32'b0);
				icc_c = sum[32];
				icc_v = ~(A[31] ^ B[31]) & (sum[31] ^ A[31]);
			end	
			6'b001100: sum = A - B - carry;							  //SUBx
			6'b011100:												  //SUBxcc
			begin
				sum = A - B - carry;
				icc_n = sum[31];
				icc_z = (sum == 32'b0);
				icc_c = sum[32];
				icc_v = ~(A[31] ^ B[31]) & (sum[31] ^ A[31]);
			end
		endcase	 
	end
	assign result = sum;
	assign flags[0] = icc_c;
	assign flags[1] = icc_v;
	assign flags[2] = icc_z;
	assign flags[3] = icc_n;
endmodule