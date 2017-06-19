/*
  108:108 CDB_R
  107:107 busy
  106:85 bank_val
  84:80 bank_tag
  79:74 operator
  73:42 val_2
  41:10 val_1
  9:5 tag_2
  4:0 tag_1
*/

module ADD_RS (
  input wire clk,

  input wire [4:0] in_operator_type,
  input wire [31:0] in_val_1,
  input wire [31:0] in_val_2,
  input wire [4:0] in_tag_1,
  input wire [4:0] in_tag_2,

  input wire in_CDB_broadcast,
  input wire [4:0] in_CDB_tag,
  input wire [31:0] in_CDB_val,

  input wire in_rs_enable,

  output reg out_rs_enable,
  output reg[4:0] out_rs_tag,

  output reg out_CDB_broadcast,
  output reg [4:0] out_CDB_tag,
  output reg [31:0] out_CDB_val,

  output reg [3:0] out_ICC_flags
);

parameter UMUL = 6'b001010;
parameter SMUL = 6'b001011;
parameter UMUL_CC = 6'b011010;
parameter SMUL_CC = 6'b011011;

parameter INVALID_TAG = 5'b11111;

reg icc_n, icc_z, icc_c, icc_v;

reg signed [31:0] signed_a;
reg signed [31:0] signed_b;
reg signed [63:0] result;
reg signed [31:0] remain_result;

reg[108:0] rs[0:3];
integer i;

initial begin
  out_CDB_broadcast = 1'b0;
  for (i = 0;i < 4; i=i+1) begin
    rs[i] = {86{1'b0}};
  end
end

always @(posedge in_CDB_broadcast) begin
  for (i = 0;i < 4; i=i+1) begin
    if (rs[i][107:107] == 1'b1) begin
      if (rs[i][4:0] == in_CDB_tag) begin
        rs[i][41:10] = in_CDB_val;
        rs[i][4:0] =  INVALID_TAG;
      end
      if (rs[i][9:5] == in_CDB_tag) begin
        rs[i][73:42] = in_CDB_val;
        rs[i][9:5] = INVALID_TAG;
      end
    end
  end
end

always @(posedge clk) begin
  #50
  out_CDB_broadcast = 1'b0;
  for (i = 0;i < 4; i = i+1) begin
    if (rs[i][107:107] == 1'b1) begin
      if (rs[i][4:0] == INVALID_TAG && rs[i][9:5] == INVALID_TAG) begin

        if (rs[i][79:74] == UMUL || rs[i][79:74] == UMUL_CC) begin
          result = rs[i][41:10] * rs[i][73:42];
          out_CDB_val = result[31:0];
          remain_result = result[63:32];
        end

        if (rs[i][79:74] == SMUL || rs[i][79:74] == SMUL_CC) begin
          signed_a = rs[i][41:10];   //Convert to signed
          signed_b = rs[i][73:42];   //Convert to signed
          result = signed_a * signed_b;
          out_CDB_val = result[31:0];
          remain_result = result[63:32];
        end

        // modify icc
        if (in_operator_type[4] == 1) begin
          icc_n = result[31];
          icc_z = (result[31:0] == 32'b0);
          icc_v = 1'b0;
          icc_c = 1'b0;
        end

        rs[i][107:107] = 1'b0;
        out_CDB_tag = rs[i][84:80];
        out_ICC_flags = {icc_c, icc_v, icc_z, icc_n};
        out_CDB_broadcast = 1'b1;
      end
    end
  end
end

always @(posedge in_rs_enable) begin
  if (in_operator_type == UMUL || in_operator_type == SMUL
      || in_operator_type == UMUL_CC || in_operator_type == SMUL_CC) begin

    begin

      #0.01
      for (i = 0; i < 4; i=i+1) begin
        if (rs[i][107:107] == 1'b0) begin
          out_rs_tag = {2'b01, i};
          rs[i][4:0] = in_tag_1;
          rs[i][9:5] = in_tag_2;
          rs[i][41:10] = in_val_1;
          rs[i][73:42] = in_val_2;
          rs[i][79:74] = in_operator_type;
          rs[i][84:80] = {2'b01, i};
          rs[i][107:107] = 1'b1;
        end
      end
    end

  end
end

endmodule
