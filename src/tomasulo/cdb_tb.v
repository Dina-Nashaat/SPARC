`include "cdb.v"
module test;

reg clk = 0;
always #5 clk = !clk;

reg in_request_add;
reg [4:0] in_tag_add;
reg [31:0] in_val_add;

reg in_request_logic;
reg [4:0] in_tag_logic;
reg [31:0] in_val_logic;

reg in_request_mul;
reg [4:0] in_tag_mul;
reg [31:0] in_val_mul;

reg in_request_load;
reg [4:0] in_tag_load;
reg [31:0] in_val_load;

reg in_request_store;
reg [4:0] in_tag_store;
reg [31:0] in_val_store;

wire out_broadcast;
wire [4:0] out_tag;
wire [31:0] out_val;

CDB cdb (
         clk,

         in_request_add,
         in_tag_add,
         in_val_add,

         in_request_logic,
         in_tag_logic,
         in_val_logic,

         in_request_mul,
         in_tag_mul,
         in_val_mul,

         in_request_load,
         in_tag_load,
         in_val_load,

         in_request_store,
         in_tag_store,
         in_val_store,

         out_broadcast,
         out_tag,
         out_val
         );

initial begin
  in_request_add = 1'b0;
  in_request_logic = 1'b0;
  in_request_load = 1'b0;

  #5;
  in_tag_logic = 5'b11;
  in_val_logic = 32'b111;
  in_request_logic = 1'b1;

  #5;
  in_tag_add = 5'b101;
  in_val_add = 32'b1;
  in_tag_load = 5'b1001;
  in_val_load = 32'b1111;
  in_request_add = 1'b1;
  in_request_load = 1'b1;
  #50 $finish;
end

always @(posedge out_broadcast) begin
  $display(
       "At time %4t\n", $time,
       "(posedge out_broadcast)\n",
       "\n--------------------\n"
       );
  if (out_tag == 5'b11) in_request_logic = 1'b0;
  if (out_tag == 5'b101) in_request_add = 1'b0;
  if (out_tag == 5'b1001) in_request_load = 1'b0;
end

initial
   $monitor(
            "At time %4t\n", $time,
            "out_broadcast: %4d\n", out_broadcast,
            "out_tag: %4d\n", out_tag,
            "out_val: %4d\n", out_val,
            "\n--------------------\n"
            );

endmodule
