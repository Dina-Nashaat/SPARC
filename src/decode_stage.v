module decode_stage(
	input clk,
	input wire [31:0] instr,
	output reg [4:0] out_reg_1, out_reg_2, out_reg_3,
	output reg [5:0] out_operator_type,);
	
	always@(posedge clk)
		begin
			out_reg_1 = instr[18:14];
			out_reg_2 = instr[4:0];
			out_reg_3 = instr[29:25];
			out_operator_type = instr[24:19];
		end
endmodule
