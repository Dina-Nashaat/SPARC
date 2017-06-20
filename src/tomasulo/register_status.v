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

reg[36:0] registers[0:31]; // 36:5 val , 4:0 tag

integer i_0;
initial begin
  out_enable = 1'b0;
  for (i_0 = 0; i_0 < 32; i_0=i_0+1) begin
    registers[i_0] = {32'bx, INVALID_TAG};
  end
  registers[0] = {32'h1, INVALID_TAG};
  registers[1] = {32'h3, INVALID_TAG};
  registers[3] = {32'h6, INVALID_TAG};
  registers[4] = {32'h7, INVALID_TAG};
end

always @(posedge in_bank_enable) begin
    registers[in_bank_reg][4:0] = in_bank_tag;
    registers[in_bank_reg][36:5] = 32'bx;
end

integer i_1;
always @(posedge in_CDB_broadcast) begin
  $display("At time %4t, write back tag: %4d with value: %4d\n", $time, in_CDB_tag, in_CDB_val);
  for (i_1 = 0; i_1 < 31; i_1=i_1+1) begin
    if (registers[i_1][4:0] == in_CDB_tag) begin
      registers[i_1][36:5] = in_CDB_val;
      registers[i_1][4:0] =  INVALID_TAG;
    end
  end
end

always @(posedge in_enable) begin
  #5;
  out_val_1 = registers[in_reg_1][36:5];
  out_val_2 = registers[in_reg_2][36:5];

  // TODO: Write back or reorder buffer should proceed from here.

  out_tag_1 = registers[in_reg_1][4:0];
  out_tag_2 = registers[in_reg_2][4:0];
  out_enable = 1'b1;
  #5;
  out_enable = 1'b0;
end

endmodule
