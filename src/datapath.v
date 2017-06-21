`timescale 1 ns / 1 ps
module datapath();
	
	reg clk;		
	reg reset;
	
	wire [31:0] pc, instr;
	
	fetch_stage		fetch(clk, reset, instr, pc);
	
	instr_memory	imem(pc[7:2], instr);
	
	wire [4:0] out_reg_1, out_reg_2, out_reg_3;
	wire [5:0] out_operator_type;
	
	decode_stage	decode(clk, instr, out_reg_1, out_reg_2, out_reg_3, out_operator_type);  
	
	tomasulo	    tomasulo_t(clk, out_operator_type, out_reg_1,
							   out_reg_2, out_reg_3);
	
	initial 
		begin
			reset <= 1; 
			#22;
			reset <= 0;		
		//Generate clk sequence	
		end
	always
		begin
			clk <= 1;
			#5;
			clk <= 0;
			#5;		 
		end			 	
endmodule
