//-----------------------------------------------------------------------------
//
// Title       : SignExtend
// Design      : SPARC
// Author      : Dina
//
//-----------------------------------------------------------------------------
//
// File        : SignExtend.v
// Generated   : Wed Jun 12 00:02:02 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module SignExtend (
	input [15:0] a,
	output [31:0] y
	);
	
	assign y = {{16{a[15]}} , a}; //Concatenation {a,b} - Replication {REPEAT_NUM{value}}
	
endmodule
