module Instruction_Decode(
	input clk;               //The system clock.
	input [31:0]instruction; //The 32 bit instruction.	

	/*Control signals*/
	output mem_write;         		//Control signal that enables writing to memory.
	output mem_read;          		//Control signal that enables reading from memory.
	output reg_write;         		//Control signal that enables writing to register file.
	output [1:0] mem_access_size;   //Control signal that determines whether the memory access is for byte(00), half-word(01), word(10), double-word(11).
	output mem_access_signed;       //Control signal that determines (in case of byte and halfword memory access)whether the memory access is signed or unsigned.
	output [2:0]ALU_op; 			//Control signal that determine ALU Operation; AND(000), OR(001), ADD(010), SUB(011), MUL(100), DIV(101) 
	output signed_mul;				//Conrol signal that determine signed/unsigned multiplication
	output left_shift;			    //Control signal that determine left/right shift
	output arith_shift;			    //Control signal that determine logical/arithmetic shift
	output brach_taken;				//Control signal that determine whether a branch is taken or not 


	/*Input to next stage */	
	output [31:0] src_a;      //The first operand:  The first source register for the address of memory access/ The first source in arithmetic operations
	output [31:0] src_b;      //The second operand: The second source register for the address of memory access/ The second source in arithmetic operations
	output [31:0] src_c;      //The third operand  :the storage value of a store instruction	 
	output [4:0] rd;          //The destination register needed in WB step	
	output [31:0] branch_target; //The branch target address for a branch instruction .
);
	

reg mem_write; 
reg mem_read;              
reg reg_write;
reg	[1:0] mem_access_size;
reg mem_access_signed;    
reg [2:0]ALU_op;
reg signed_mul;
reg [31:0] src_a;       
reg [31:0] src_b;      
reg [31:0] src_c;
reg [4:0] rd; 


always @(posedge clk) 
	begin
/* begin decoding*/ 
	
		mem_write=0;
		mem_read=0;
		reg_write=0;
		case(instruction[31:30])
			/*Memory instructions*/
			2'b11:
				begin 
					/*load instruction*/ 
					if(instruction[24:19]==6'b000000||instruction[24:19]==6'b000001||instruction[24:19]==6'b000010||instruction[24:19]==6'b001001||instruction[24:19]==6'b001001||instruction[24:19]==6'b001010)
						begin
							/*control signals*/
							mem_write=0;
							mem_read=1;
							reg_write=1;
							rd=instruction[29:25];//destination
							/*the first source*/
							src_a=reg_file[instruction[18:14]]///--->call reg_file module here
							/*the second source*/
							if(!instruction[13])//not immediate 
								begin
									src_b=reg_file[instruction[4:0]]///--->call reg_file module here	
								end
							else //immediate->sign extended to be 32 bit
								begin
									src_b={{19{instruction[12]}},instruction[12:0]};
								end
							case (instruction[24:19])
								6'b001001: //(ldsb),Load Signed Byte
									begin 
										mem_access_size=0;
										mem_access_signed=1;
									end	
								6'b000001: //(ldub),Load UnSigned Byte
									begin 
										mem_access_size=0;
										mem_access_signed=0;
									end
								6'b001010: //(ldsh),Load Signed Half-Word
									begin 
										mem_access_size=1;
										mem_access_signed=1;
									end	
								6'b000010: //(lduh),Load UnSigned Half-Word
									begin 
										mem_access_size=1;
										mem_access_signed=0;
									end	
								6'b000000: //(ld),Load Word
									begin 
										mem_access_size=2;
										mem_access_signed=0;
									end
								6'b000011: //(ld1),Load Double Word
									begin 
										mem_access_size=3;
										mem_access_signed=0;
									end
							endcase						
						end //load instructions
					/*store instruction*/
					else if(instruction[24:19]==6'b000100||instruction[24:19]==6'b000101||instruction[24:19]==6'b000110||instruction[24:19]==6'b000111)
						begin
							mem_write=1;
							mem_read=0;
							/*the first source*/
							src_a=reg_file[instruction[29:25]];///--->call reg_file module here
							/*the second source*/
							src_b=reg_file[instruction[18:14]];///--->call reg_file module here
							/*the third source=the memory target adress*/
							if(!instruction[13])//not immediate 
								begin
									src_c=reg_file[instruction[4:0]]///--->call reg_file module here	
								end
							else //immediate->sign extended to be 32 bit
								begin
									src_c={{19{instruction[12]}},instruction[12:0]};
								end
							case (instruction[24:19])
								6'b000101://(stb),Store Byte
									begin 
										mem_access_size=0;
									end 
								6'b000110://(sth),Store Half-Word
									begin 
										mem_access_size=1;
									end
								6'b000100://(stw),Store Word
									begin 
										mem_access_size=2;
									end
								6'b000111://(std),Store Double-Word
									begin 
										mem_access_size=3;
									end
							endcase				 
						end //store instructions	
				end //case(memory instruction)	
			/*aithmetic-shift-logic instruction*/
			2'b10:
				begin
					reg_write=1;//control signals
					rd=instruction[29:25];//destination
					/*the first source*/
					src_a=reg_file[instruction[29:25]];///--->call reg_file module here
					/*the second source*/
					if(!instruction[13])//not immediate 
						begin
							src_b=reg_file[instruction[4:0]]///--->call reg_file module here	
						end
					else //immediate->sign extended to be 32 bit
						begin
							src_b={{19{instruction[12]}},instruction[12:0]};
						end   
					case (instruction[24:19])
						begin
							6'b000000://(add)
								begin
									ALU_op=2;
								end
							6'b00100://(sub)
								begin
									ALU_op=3;
								end	
							6'b001010://(umul),Unsigned Integer Multiply  
								begin 
									ALU_op=4;
									signed_mul=0;
								end
							6'b001011://(smul),Signed Integer Multiply 
								begin
									ALU_op=4;
									signed_mul=1;
								end
							6'b001110://(udiv),Unsigned Integer Divide 
								begin 
									ALU_op=5;
								end
							6'b000001://(and)
								begin 
									ALU_op=0;
								end
							6'b000010://(or)
								begin 
									ALU_op=1;
								end	
							6'b100101://(sll),Shift Left Logical
								begin  	
									left_shift=1;
									arith_shift=0;
								end
							6'b100110://(srl),Shift Right Logical 
								begin 
									left_shift=0;
									arith_shift=0;	
								end
							6'b100111://(sra),Shift Right Arithmetic 
								begin 
									left_shift=0;
									arith_shift=1;
								end	  
						endcase	
				end//case(arithmetic instruction)
			/*Branch & NOP Instruction*/	
			2'b00:
				begin
					/*Branch Instruction */
					case(instruction[28:25])
						begin
							4'b1000 ://(ba),Branch Always taken
								begin 
									branch_taken=1;
									branch_target=instruction[21:0];
								end
							4'b0000 ://(bn),Branch Never taken
								begin 
									branch_taken=0;
                				end
						endcase //branch instruction
				end//case(branch & NOP instruction)
		endcase//case(instruction[31:30])
	end//always @(posedge clk)	
	
	
endmodule
