`timescale 1ns/1ps
module Write_Back_TB();
  
  reg clk, reset;
  reg [4:0] dest_reg;
  reg [31:0] value_to_write;
  wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 , R10, R11 , R12, R13, R14,
 R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28,
 R29, R30 , R31;
  
  Write_Back  DUT
	( .clk(clk) , .reset(reset),  .dest_reg(dest_reg), .value_to_write(value_to_write),
 .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),
 .R8(R8), .R9(R9) , .R10(R10), .R11(R11) , .R12(R12), .R13(R13), .R14(R14),
 .R15(R15), .R16(R16), .R17(R17), .R18(R18), .R19(R19), .R20(R20), .R21(R21), .R22(R22),
 .R23(R23), .R24(R24), .R25(R25), .R26(R26), .R27(R27), .R28(R28), .R29(R29), .R30(R30) , .R31(R31));



always 
#5  clk =  ! clk;
 
  initial begin
    clk = 0;
    reset=1;
	#10 reset = 0; 
	#10 reset = 1;
	#10 dest_reg = 5'b00000;
	value_to_write=32'd100;
	#10 dest_reg = 5'b00001;
	value_to_write=32'd200;
	#10 dest_reg = 5'b00010; 
	value_to_write=32'd300;
	#10 dest_reg = 5'b00011;
	value_to_write=32'd400;
    #10 dest_reg = 5'b00100;
	value_to_write=32'd500;
	#10 dest_reg = 5'b00101;
	value_to_write=32'd600;
    #10 dest_reg = 5'b00110;
	value_to_write=32'd700;
	#10 dest_reg = 5'b00111;
	value_to_write=32'd800;
	#10 dest_reg = 5'b01000;
	value_to_write=32'd900;
	#10 dest_reg = 5'b01001;
	value_to_write=32'd1000;
	#10 dest_reg = 5'b01010;
	value_to_write=32'd1100;
	#10 dest_reg = 5'b01011;
	value_to_write=32'd1200;
	#10 dest_reg = 5'b01100;
	value_to_write=32'd1300;
	#10 dest_reg = 5'b01101;
	value_to_write=32'd1400;
	#10 dest_reg = 5'b01110;
	value_to_write=32'd1500;
	#10 dest_reg = 5'b01111;
	value_to_write=32'd1600;
	
	#10 dest_reg = 5'b10000;
	value_to_write=32'd1700;
	#10 dest_reg = 5'b10001;
	value_to_write=32'd1800;
	#10 dest_reg = 5'b10010; 
	value_to_write=32'd1900;
	#10 dest_reg = 5'b10011;
	value_to_write=32'd2000;
    #10 dest_reg = 5'b10100;
	value_to_write=32'd2100;
	#10 dest_reg = 5'b10101;
	value_to_write=32'd2200;
    #10 dest_reg = 5'b10110;
	value_to_write=32'd2300;
	#10 dest_reg = 5'b10111;
	value_to_write=32'd2400;
	#10 dest_reg = 5'b11000;
	value_to_write=32'd2500;
	#10 dest_reg = 5'b11001;
	value_to_write=32'd2600;
	#10 dest_reg = 5'b11010;
	value_to_write=32'd2700;
	#10 dest_reg = 5'b11011;
	value_to_write=32'd2800;
	#10 dest_reg = 5'b11011;
	value_to_write=32'd2900;
	#10 dest_reg = 5'b11100;
	value_to_write=32'd3000;
	#10 dest_reg = 5'b11101;
	value_to_write=32'd3100;
	#10 dest_reg = 5'b11110;
	value_to_write=32'd3200;
	#10 dest_reg = 5'b11111;
	value_to_write=32'd3300;
    #20 
	reset = 0; 
	#30 
	
    $finish;
  end
  
endmodule
