module datapath (input clk, reset,
	output [31:0] pc,
	input [31:0] instr,
	);
	//FETCH LOGIC	  
	wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
	wire [31:0] signimm, signimmsh;		
	wire [31:0] RD;
	
	Adder		pcadder(pc,32'b100, pcplus4);
	shiftBy2 	immsh(signimm, signimmsh); 
	Adder 		pcadd2(pcplus4, signimmsh, pcbranch);
	MUX2 #(32)	pcbranchMux(pcplus4, pcbranch, pcsrc, pcnextbr);
	
	InstructionMemory	instmem(pcnextbr[7:2], RD);
	
endmodule
