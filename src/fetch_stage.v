module fetch_stage (input clk, reset,
	input [31:0] instr,
	output [31:0] pc,
	);
	
	//FETCH LOGIC	  
	wire [31:0] pcnext, pcplus4, pcbranch;
	wire [31:0] signimm, signimmsh;		
	wire [31:0] RD;
	
	flopr #(32) pcreg(clk, reset, pcnext, pc);
	Adder		pcadd_next_inst(pc,32'b100, pcplus4);
	shiftBy2 	imm_shift(signimm, signimmsh); 
	Adder 		pcadd_branch(pcplus4, signimmsh, pcbranch);
	MUX2 #(32)	pcbranchMux(pcplus4, pcbranch, 0, pcnext); //pcsrc = 0 	
endmodule
