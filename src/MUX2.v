//-----------------------------------------------------------------------------
//
// Title       : MUX2
// Design      : SPARC
// Author      : Dina
// Company     : Dina
//
//-----------------------------------------------------------------------------
//
// File        : MUX2.v
// Generated   : Wed Jun 12 22:01:22 2013
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : A two input Multiplexer
// Parameters : Input data width 
// Return : Multiplexed value depending on signal value
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
module MUX2 #(parameter WIDTH = 8)
	
	(input [WIDTH-1:0] d0, d1,
	input s, 
	output [WIDTH-1:0] y);
	
	assign y = s ? d1 : d0;
	
endmodule
