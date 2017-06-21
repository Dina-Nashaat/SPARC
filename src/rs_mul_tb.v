//`include "rs_mul.v"
module test;

reg clk = 0;
always #5 clk = !clk;

parameter INVALID_TAG = 5'b11111;

reg in_rs_enable;
reg [4:0] in_operator_type;
reg [31:0] in_val_1;
reg [31:0] in_val_2;
reg [4:0] in_tag_1;
reg [4:0] in_tag_2;

reg in_CDB_broadcast;
reg [4:0] in_CDB_tag;
reg [31:0] in_CDB_val;
reg [31:0] in_Y_val;

wire out_rs_enable;
wire [4:0] out_rs_tag;

wire out_CDB_broadcast;
wire [4:0] out_CDB_tag;
wire [31:0] out_CDB_val;
wire [31:0] out_Y_val;

wire [3:0] out_ICC_flags;

MUL_RS mul_rs (
               clk,

               in_rs_enable,
               in_operator_type,
               in_val_1,
               in_val_2,
               in_tag_1,
               in_tag_2,

               in_CDB_broadcast,
               in_CDB_tag,
               in_CDB_val,

               in_Y_val,

               out_rs_enable,
               out_rs_tag,

               out_CDB_broadcast,
               out_CDB_tag,
               out_CDB_val,

               out_Y_val,
               out_ICC_flags
               );

always @(posedge out_CDB_broadcast) begin
  in_CDB_broadcast = 1'b0;
  #5;
  in_CDB_broadcast = 1'b1;
  in_CDB_tag = out_CDB_tag;
  in_CDB_val = out_CDB_val;
  #5;
  in_CDB_broadcast = 1'b0;
end

initial begin
   in_CDB_broadcast = 1'b0;
   #5;
   in_tag_1 = INVALID_TAG;
   in_tag_2 = INVALID_TAG;
   in_val_1 = 32'h2;
   in_val_2 = 32'h3;
   in_operator_type = 6'b001010;
   in_rs_enable = 1'b1;
   #5
   in_rs_enable = 1'b0;
   #5
   in_tag_1 = INVALID_TAG;
   in_tag_2 = 5'b11;
   in_val_1 = 32'h4;
   in_val_2 = 32'bx;
   in_operator_type = 6'b001010;
   in_rs_enable = 1'b1;
   in_CDB_broadcast = 1'b0;
   #5
   in_CDB_tag = 5'b11;
   in_CDB_val = 32'h1;
   in_CDB_broadcast = 1'b1;
   #5
   in_rs_enable = 1'b0;
   #40
   in_tag_1 = 5'b10;
   in_tag_2 = 5'b11;
   in_val_1 = 32'bx;
   in_val_2 = 32'bx;
   in_operator_type = 6'b001010;
   in_rs_enable = 1'b1;
   in_CDB_broadcast = 1'b0;
   #5
   in_CDB_tag = 5'b10;
   in_CDB_val = 32'h7;
   in_CDB_broadcast = 1'b1;
   #5
   in_CDB_broadcast = 1'b0;
   #5
   in_CDB_tag = 5'b11;
   in_CDB_val = 32'h6;
   in_CDB_broadcast = 1'b1;
  #100 $finish;
end

initial
   $monitor("At time %4t\n", $time,
            "out_rs_enable: %4d\n", out_rs_enable,
            "out_rs_tag: %4d\n", out_rs_tag,
            "out_CDB_broadcast: %4d\n", out_CDB_broadcast,
            "out_CDB_tag: %4d\n", out_CDB_tag,
            "out_CDB_val: %4d\n", out_CDB_val,
            "\n--------------------\n"
            );

endmodule
