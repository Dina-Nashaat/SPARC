`include "register_status.v"
module test;

reg clk = 0;
always #5 clk = !clk;

reg [4:0] in_reg_1;
reg [4:0] in_reg_2;

reg in_bank_enable;
reg [4:0] in_bank_reg;
reg [4:0] in_bank_tag;

reg in_CDB_broadcast;
reg [4:0] in_CDB_tag;
reg [31:0] in_CDB_val;

wire out_enable;
wire [31:0] out_val_1;
wire [31:0] out_val_2;
wire [4:0] out_tag_1;
wire [4:0] out_tag_2;

REG_STATUS reg_status (
                       clk,

                       clk,
                       in_reg_1,
                       in_reg_2,

                       in_bank_enable,
                       in_bank_reg,
                       in_bank_tag,

                       in_CDB_broadcast,
                       in_CDB_tag,
                       in_CDB_val,

                       out_enable,
                       out_val_1,
                       out_val_2,
                       out_tag_1,
                       out_tag_2
                       );

initial begin
  in_bank_enable = 1'b0;
  in_CDB_broadcast = 1'b0;

  #5;
  in_reg_1 = 5'b101;

  #5;
  in_bank_reg = 5'b101;
  in_bank_tag = 5'b1;
  in_bank_enable = 1'b1;

  #5;
  in_CDB_tag = 5'b1;
  in_CDB_val = 32'b111;
  in_CDB_broadcast = 1'b1;

  #5;
  in_reg_2 = 5'b1;
  #10 $finish;
end

initial
   $monitor(
            "At time %4t\n", $time,
            "in_reg_1: %4d\n", in_reg_1,
            "in_reg_2: %4d\n", in_reg_2,
            "out_val_1: %4d\n", out_val_1,
            "out_val_2: %4d\n", out_val_2,
            "out_tag_1: %4d\n", out_tag_1,
            "out_tag_2: %4d\n", out_tag_2,
            "out_enable: %4d\n", out_enable,
            "\n--------------------\n"
            );

endmodule
