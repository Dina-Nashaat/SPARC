module RS_MUX
(
  input wire clk,

  input wire in_enable_add,
  input wire [4:0] in_tag_add,

  input wire in_enable_logic,
  input wire [4:0] in_tag_logic,

  input wire in_enable_mul,
  input wire [4:0] in_tag_mul,

  input wire in_enable_load,
  input wire [4:0] in_tag_load,

  input wire in_enable_store,
  input wire [4:0] in_tag_store,

  output reg out_enable,
  output reg [4:0] out_tag
);

always @(in_enable_add or in_enable_logic or in_enable_mul
         or in_enable_load or in_enable_store) begin
  if (in_enable_add == 1'b1) begin
    out_enable = 1'b0;
    #5;
    out_tag = in_tag_add;
    out_enable = 1'b1;
  end

  if (in_enable_logic == 1'b1) begin
    out_enable = 1'b0;
    #5;
    out_tag = in_tag_logic;
    out_enable = 1'b1;
  end

  if (in_enable_mul == 1'b1) begin
    out_enable = 1'b0;
    #5;
    out_tag = in_tag_mul;
    out_enable = 1'b1;
  end

  if (in_enable_load == 1'b1) begin
    out_enable = 1'b0;
    #5;
    out_tag = in_tag_load;
    out_enable = 1'b1;
  end

  if (in_enable_store == 1'b1) begin
    out_enable = 1'b0;
    #5;
    out_tag = in_tag_store;
    out_enable = 1'b1;
  end
end

endmodule
