//-----------------------------------------------------------------------------
//
// Title       : IUMultiplier
// Design      : SPARC//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module IULogical (
	input [31:0] A, B,	 	  //A -> Multiplier, B->Multiplicand, default:unsigned
	input [5:0] op,		 
	output reg [31:0] rd, 	//lsb of product
	output reg [31:0] Yreg, //msb of product
	output flags[3:0],
	);
	//Note that
	//negative (N) and zero (Z) are set according to the less significant word of the
 	//product.
	reg icc_n, icc_z, icc_c, icc_v;								
	initial begin					   
		case (op)					   
			6'b001010:								//UMUL
			begin	  
				reg [63:0] product;
				
				product = A * B;  							
				
				rd = product[31:0];
				Yreg = product[63:32];
			end									 	//SMUL
			
			6'b001011:
			begin
				reg signed [63:0] product;
				reg signed [31:0] signed_A;
				reg signed [31:0] signed_B;
				
				assign signed_A = A;		//Convert A to signed
				assign signed_B = B;		//Convert B to signed
				
				product = signed_A * signed_B; 
				
				rd = product[31:0];
				Yreg = product[63:32];
			end
			
			6'b011010:								//UMULcc
			begin
				reg [63:0] product;
				
				product = A * B;  							
				
				rd = product[31:0];
				Yreg = product[63:32];
				
				icc_n = product[31];
				icc_z = (product[31:0] == 32'b0);
				icc_v = 1'b0;
				icc_c = 1'b0;
			end				 
			
			6'b011011:								//SMULcc
			begin
				reg signed [63:0] product;
				reg signed [31:0] signed_A;
				reg signed [31:0] signed_B;
				
				assign signed_A = A;		//Convert A to signed
				assign signed_B = B;		//Convert B to signed
				
				product = signed_A * signed_B; 
				
				rd = product[31:0];
				Yreg = product[63:32];
				
				
				icc_n = product[31];
				icc_z = (product[31:0] == 32'b0);
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
