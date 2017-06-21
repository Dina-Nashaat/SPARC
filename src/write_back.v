 module Write_Back(clk , reset, dest_reg, value_to_write,
 R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 , R10, R11 , R12, R13, R14,
 R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28,
 R29, R30 , R31);
 
 input clk;
 input reset;
 input [4:0]dest_reg;
 input [31:0] value_to_write;
 output reg [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9 , R10, R11 , R12, R13, R14,
 R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28,
 R29, R30 , R31;
 
 
 
 always @(posedge clk or negedge reset)
 begin
 if (!reset)
 begin 
 R0=0;
 R1=0;
 R2=0;
 R3=0;
 R4=0;
 R5=0;
 R6=0;
 R7=0;
 R8=0;
 R9=0;
 R10=0;
 R11=0;
 R12=0;
 R13=0;
 R14=0;
 R15=0;
 R16=0;
 R17=0;
 R18=0;
 R19=0;
 R20=0;
 R21=0;
 R22=0;
 R23=0;
 R24=0;
 R25=0;
 R26=0;
 R27=0;
 R28=0;
 R29=0;
 R30=0;
 R31=0;
 end
 else 
 begin 
 case(dest_reg)
 5'b00000: R0 = value_to_write;
 5'b00001: R1 = value_to_write;
 5'b00010: R2 = value_to_write;
 5'b00011: R3 = value_to_write;
 5'b00100: R4 = value_to_write;
 5'b00101: R5 = value_to_write;
 5'b00110: R6 = value_to_write;
 5'b00111: R7 = value_to_write;
 5'b01000: R8 = value_to_write;
 5'b01001: R9 = value_to_write;
 5'b01010: R10 = value_to_write;
 5'b01011: R11 = value_to_write;
 5'b01100: R12 = value_to_write;
 5'b01101: R13 = value_to_write;
 5'b01110: R14 = value_to_write;
 5'b01111: R15 = value_to_write;
 5'b10000: R16 = value_to_write;
 5'b10001: R17 = value_to_write;
 5'b10010: R18 = value_to_write;
 5'b10011: R19 = value_to_write;
 5'b10100: R20 = value_to_write;
 5'b10101: R21 = value_to_write;
 5'b10110: R22 = value_to_write;
 5'b10111: R23 = value_to_write;
 5'b11000: R24 = value_to_write;
 5'b11001: R25 = value_to_write;
 5'b11010: R26 = value_to_write;
 5'b11011: R27 = value_to_write;
 5'b11100: R28 = value_to_write;
 5'b11101: R29 = value_to_write;
 5'b11110: R30 = value_to_write;
 5'b11111: R31 = value_to_write;
 endcase
 end
 end //always
 
 
 endmodule