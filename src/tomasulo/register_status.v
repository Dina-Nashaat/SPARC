module REG_STATUS
(
  input clk,

  input wire in_enable,
  input wire [4:0] in_reg_1,
  input wire [4:0] in_reg_2,

  input wire in_bank_enable,
  input wire [4:0] in_bank_reg,
  input wire [4:0] in_bank_tag,

  input wire in_CDB_broadcast,
  input wire [4:0] in_CDB_tag,
  input wire [31:0] in_CDB_val,

  output reg out_enable,
  output reg [31:0] out_val_1,
  output reg [31:0] out_val_2,
  output reg [4:0] out_tag_1,
  output reg [4:0] out_tag_2
);

parameter INVALID_TAG = 5'b11111;
integer i;

reg[36:0] registers[0:31]; // 36:5 val , 4:0 tag

initial begin
  out_enable = 1'b0;
  for (i = 0;i < 32; i=i+1) begin
    registers[i] = {32'bx, INVALID_TAG};
  end
end

always @(posedge in_bank_enable) begin
    registers[in_bank_reg][4:0] = in_bank_tag;
    registers[in_bank_reg][36:5] = 32'bx;
end

always @(posedge in_CDB_broadcast) begin
  for (i = 0;i < 31; i = i+1) begin
    if (registers[i][4:0] == in_CDB_tag) begin
      registers[i][36:5] = in_CDB_val;
      registers[i][4:0] =  INVALID_TAG;
    end
  end
end

always @(posedge in_enable) begin
  out_val_1 <= registers[in_reg_1][36:5];
  out_val_2 <= registers[in_reg_2][36:5];

  // TODO: Write back or reorder buffer should proceed from here.

  out_tag_1 <= registers[in_reg_1][4:0];
  out_tag_2 <= registers[in_reg_2][4:0];
  out_enable = 1'b1;
  #5;
  out_enable = 1'b0;
end

endmodule
