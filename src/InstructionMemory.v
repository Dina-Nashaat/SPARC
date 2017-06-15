//-----------------------------------------------------------------------------
//
// Title       : InstructionMemory
// Design      : SPARC
// Author      : Dina
//
//-----------------------------------------------------------------------------
//
// File        : InstructionMemory.v
// Generated   : Wed Jun 12 22:17:47 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
module InstructionMemory (
	input [5:0] a, 
	output [31:0] rd
	);					
	
	reg[31:0] RAM[63:0];
	
	initial 
		begin
			$readmemh("memfile.dat", RAM);
		end
	
	assign rd = RAM[a];
endmodule
