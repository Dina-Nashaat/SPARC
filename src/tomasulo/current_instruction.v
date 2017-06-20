module CUR_INST
(
  input clk,

  input wire in_fetch_next,
  input wire [4:0] in_operator_type,
  input wire [4:0] in_reg_1,
  input wire [4:0] in_reg_2,
  input wire [4:0] in_reg_3,

  input wire in_enable,
  input wire [31:0] in_val_1,
  input wire [31:0] in_val_2,
  input wire [4:0] in_tag_1,
  input wire [4:0] in_tag_2,

  input wire in_CDB_broadcast,
  input wire [4:0] in_CDB_tag,
  input wire [31:0] in_CDB_val,

  input wire in_rs_enable,
  input wire [4:0] in_rs_tag,

  output reg out_fetch_next,

  output reg out_enable,
  output reg [4:0] out_reg_1,
  output reg [4:0] out_reg_2,

  output reg out_bank_enable,
  output reg [4:0] out_bank_reg,
  output reg [4:0] out_bank_tag,

  output reg out_rs_enable,
  output reg [4:0] out_operator_type,
  output reg [31:0] out_val_1,
  output reg [31:0] out_val_2,
  output reg [4:0] out_tag_1,
  output reg [4:0] out_tag_2
);

parameter INVALID_TAG = 5'b11111;

reg [31:0] out_val_1_reg;
reg [31:0] out_val_2_reg;
reg [4:0] out_tag_1_reg;
reg [4:0] out_tag_2_reg;

initial begin
  out_fetch_next = 1'b0;
  out_enable = 1'b0;
  out_bank_enable = 1'b0;
  out_rs_enable = 1'b0;
  #5;
  out_fetch_next = 1'b1;
end

always @(posedge in_CDB_broadcast) begin
  // out_reg_1 = in_reg_1;
  // out_reg_2 = in_reg_2;
  // out_enable = 1'b1;
  // #5;
  // out_enable = 1'b0;
  if (out_tag_1_reg == in_CDB_tag) begin
    out_val_1_reg = in_CDB_val;
    out_tag_1_reg = INVALID_TAG;
  end
  if (out_tag_2_reg == in_CDB_tag) begin
    out_val_2_reg = in_CDB_val;
    out_tag_2_reg = INVALID_TAG;
  end
end

always @(posedge in_rs_enable) begin
  $display("At time %4t, issue tag: %4d\n", $time, in_rs_tag);
  out_bank_reg = in_reg_3;
  out_bank_tag = in_rs_tag;
  out_bank_enable = 1'b1;
  #5;
  out_bank_enable = 1'b0;
  out_fetch_next = 1'b1;
end

integer j = 1;
always @(posedge in_fetch_next) begin
  // $display("At time %4t, fetch: %3d\n", $time, j);
  j = j + 1;
  out_fetch_next = 1'b0;
  out_reg_1 = in_reg_1;
  out_reg_2 = in_reg_2;
  out_enable = 1'b1;
  #5;
  out_enable = 1'b0;
end

always @(posedge in_enable) begin
  out_operator_type = in_operator_type;
  out_val_1_reg = in_val_1;
  out_val_2_reg = in_val_2;
  out_tag_1_reg = in_tag_1;
  out_tag_2_reg = in_tag_2;

  out_val_1 = out_val_1_reg;
  out_val_2 = out_val_2_reg;
  out_tag_1 = out_tag_1_reg;
  out_tag_2 = out_tag_2_reg;
  out_rs_enable = 1'b1;
  #5;
  out_rs_enable = 1'b0;
end

endmodule
