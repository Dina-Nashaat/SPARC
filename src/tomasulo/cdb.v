module CDB(
  input wire clk,

  input wire in_request_add,
  input wire [4:0] in_tag_add,
  input wire [31:0] in_val_add,

  input wire in_request_logic,
  input wire [4:0] in_tag_logic,
  input wire [31:0] in_val_logic,

  input wire in_request_mul,
  input wire [4:0] in_tag_mul,
  input wire [31:0] in_val_mul,

  input wire in_request_load,
  input wire [4:0] in_tag_load,
  input wire [31:0] in_val_load,

  input wire in_request_store,
  input wire [4:0] in_tag_store,
  input wire [31:0] in_val_store,

  output reg out_broadcast,
  output reg [4:0] out_tag,
  output reg [31:0] out_val
);

parameter INVALID_TAG = 5'b11111;

initial begin
  out_broadcast = 1'b0;
  out_tag = INVALID_TAG;
  out_val = 32'bx;
end

always @(in_request_add or in_request_logic or in_request_mul or in_request_load or in_request_store) begin

  if (in_request_add == 1'b1) begin
    out_broadcast = 1'b0;
    #5;
    out_tag = in_tag_add;
    out_val = in_val_add;
    out_broadcast = 1'b1;
  end

  if (in_request_logic == 1'b1) begin
    out_broadcast = 1'b0;
    #5;
    out_tag = in_tag_logic;
    out_val = in_val_logic;
    out_broadcast = 1'b1;
  end

  if (in_request_mul == 1'b1) begin
    out_broadcast = 1'b0;
    #5;
    out_tag = in_tag_mul;
    out_val = in_val_mul;
    out_broadcast = 1'b1;
  end

  if (in_request_load == 1'b1) begin
    out_broadcast = 1'b0;
    #5;
    out_tag = in_tag_load;
    out_val = in_val_load;
    out_broadcast = 1'b1;
  end

  if (in_request_store == 1'b1) begin
    out_broadcast = 1'b0;
    #5;
    out_tag = in_tag_store;
    out_val = in_val_store;
    out_broadcast = 1'b1;
  end

end

endmodule
