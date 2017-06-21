`timescale 1 ns / 1 ps
module shiftBy2 (input [31:0] a, 
	output [31:0] b);
	assign b = {a[29:1],2'b00};
endmodule
