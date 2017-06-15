//-----------------------------------------------------------------------------
//
// Title       : Adder
// Design      : SPARC
// Author      : Dina
//
//-----------------------------------------------------------------------------
//
// File        : Adder.v
// Generated   : Wed Jun 12 22:07:50 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : A module that adds two 32bit input values.
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module Adder(

	input [31:0] a, b, 
	output [31:0] y
);	
	assign y = a + b;

endmodule
