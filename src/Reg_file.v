module Reg_file(
<<<<<<< HEAD
	input clk; //The system clock.	
	input reg_write; //control signal 1 for write to the register file, 0 for read from the register file	
	input [4:0] reg_adress; //adress of the register
	input [31:0] data_write; //data to be written to the register file of (reg_write=1)
	output [31:0] data_read; //data to be read from the register file of (reg_write=0)
=======
	input clk,					//The system clock.	
	input reg_write,			//control signal 1 for write to the register file, 0 for read from the register file	
	input [4:0] reg_adress,		//adress of the register
	input [31:0] data_write,	//data to be written to the register file of (reg_write=1)
	output reg [31:0] data_read,	//data to be read from the register file of (reg_write=0)
>>>>>>> 4b1bc16b0b666276319515d9e81a99467c41451a
);
 

//reg reg_write;
//reg	[4:0] reg_adress;
//reg [31:0] data_write;
//reg [31:0] data_read;

reg [31:0] REG_FILE [0:31]; //32*32 register file  

always @(posedge clk) 
	begin
		if (reg_write) 
			begin
				REG_FILE[reg_adress] <= data_write;
			end
		else  
			begin
				data_read <= REG_FILE[reg_adress];
			end
	end

endmodule