/*
  114:111 ICC_flags
  110:110 CDB_r
  109:109 executing
  108:108 busy
  107:86 bank_val
  85:81 bank_tag
  80:74 operator
  73:42 val_2
  41:10 val_1
  9:5 tag_2
  4:0 tag_1
*/

module ADD_RS (
  input wire clk,

  input wire in_rs_enable,
  input wire [5:0] in_operator_type,
  input wire [31:0] in_val_1,
  input wire [31:0] in_val_2,
  input wire [4:0] in_tag_1,
  input wire [4:0] in_tag_2,
  input wire [3:0] in_ICC_flags,

  input wire in_CDB_broadcast,
  input wire [4:0] in_CDB_tag,
  input wire [31:0] in_CDB_val,

  output reg out_rs_enable,
  output reg [4:0] out_rs_tag,

  output reg out_CDB_broadcast,
  output reg [4:0] out_CDB_tag,
  output reg [31:0] out_CDB_val,

  output reg [3:0] out_ICC_flags
);

parameter ADD = 6'b000000;
parameter ADD_CC = 6'b010000;
parameter ADDX = 6'b001000;
parameter ADDX_CC = 6'b011000;
parameter SUB = 6'b000100;
parameter SUB_CC = 6'b010100;
parameter SUBX = 6'b001100;
parameter SUBX_CC = 6'b011100;

parameter INVALID_TAG = 5'b11111;

reg out_icc_n, out_icc_z, out_icc_c, out_icc_v;
reg in_icc_c;

reg [1:0] pos;
reg is_set, bank_done, is_waiting, CDB_r_selected;
reg signed [31:0] signed_a;
reg signed [31:0] signed_b;
reg signed [32:0] result;

reg[114:0] rs[0:3];

integer i_0;
initial begin
  bank_done = 1'b0;
  is_set = 1'b0;
  is_waiting = 1'b0;
  CDB_r_selected = 1'b0;
  out_rs_enable = 1'b0;
  out_CDB_broadcast = 1'b0;
  for (i_0 = 0; i_0 < 4; i_0=i_0+1) begin
    rs[i_0] = {110{1'b0}};
    rs[i_0][107:86] = 32'bx;
    pos = i_0;
    rs[i_0][85:81] = {3'b01, pos};
  end
end

integer i_1;
always @(posedge in_CDB_broadcast) begin
  for (i_1 = 0; i_1 < 4; i_1=i_1+1) begin
    if (rs[i_1][108:108] == 1'b1 && rs[i_1][110:110] == 1'b1
        && rs[i_1][85:81] == in_CDB_tag) begin
      out_CDB_broadcast = 1'b0;
      rs[i_1][108:108] = 1'b0;
      rs[i_1][110:110] = 1'b0;
      if (is_waiting == 1'b1) begin
        bank_done = !bank_done;
      end
    end else begin
      if (rs[i_1][108:108] == 1'b1) begin
        if (rs[i_1][4:0] == in_CDB_tag) begin
          rs[i_1][41:10] = in_CDB_val;
          rs[i_1][4:0] =  INVALID_TAG;
        end
        if (rs[i_1][9:5] == in_CDB_tag) begin
          rs[i_1][73:42] = in_CDB_val;
          rs[i_1][9:5] = INVALID_TAG;
        end
      end
    end
  end
end

integer i_2;
always @(posedge in_rs_enable or bank_done) begin
  if (in_operator_type == ADD || in_operator_type == ADD_CC
      || in_operator_type == ADDX || in_operator_type == ADDX_CC
      || in_operator_type == SUB || in_operator_type == SUB_CC
      || in_operator_type == SUBX || in_operator_type == SUBX_CC) begin

      is_set = 1'b0;
      for (i_2 = 0; i_2 < 4 && is_set == 1'b0; i_2=i_2+1) begin
        if (rs[i_2][108:108] == 1'b0) begin
          rs[i_2][4:0] = in_tag_1;
          rs[i_2][9:5] = in_tag_2;
          rs[i_2][41:10] = in_val_1;
          rs[i_2][73:42] = in_val_2;
          rs[i_2][80:74] = in_operator_type;
          rs[i_2][114:111] = {in_ICC_flags[0:0], in_ICC_flags[1:1], in_ICC_flags[2:2], in_ICC_flags[3:3]};
          rs[i_2][107:86] = 32'bx;
          rs[i_2][109:109] = 1'b0;
          rs[i_2][110:110] = 1'b0;
          out_rs_tag = rs[i_2][85:81];
          out_rs_enable = 1'b1;
          rs[i_2][108:108] = 1'b1;
          #5;
          out_rs_enable = 1'b0;
          is_set = 1'b1;
        end
      end

      if (is_set == 1'b0) begin
        is_waiting = 1'b1;
      end else begin
        is_waiting = 1'b0;
      end

  end
end

integer i_3;
always @(rs[0][110:110] or rs[1][110:110]
         or rs[2][110:110] or rs[3][110:110]) begin
  CDB_r_selected = 1'b0;
  for (i_3 = 0; i_3 < 4 && CDB_r_selected == 1'b0; i_3=i_3+1) begin
    if (rs[i_3][110:110] == 1'b1) begin
      #5;
      out_CDB_tag = rs[i_3][85:81];
      out_CDB_val = rs[i_3][107:86];
      out_ICC_flags = {out_icc_c, out_icc_v, out_icc_z, out_icc_n};
      out_CDB_broadcast = 1'b1;
      CDB_r_selected = 1'b1;
    end
  end
end

integer i_4;
always @(posedge clk) begin
  for (i_4 = 0; i_4 < 4; i_4=i_4+1) fork
    if (rs[i_4][108:108] == 1'b1 && rs[i_4][110:110] == 1'b0) begin
      if (rs[i_4][4:0] == INVALID_TAG && rs[i_4][9:5] == INVALID_TAG) begin

        rs[i_4][108:108] = 1'b1;
        $display("At cycle %4t, adder execute tag : %3d\n", $time/5, rs[i_4][85:81]);

        if (rs[i_4][80:74] == ADD || rs[i_4][80:74] == ADD_CC) begin
          signed_a = rs[i_4][41:10];   // convert to signed
          signed_b = rs[i_4][73:42];   // convert to signed
          result = #10 signed_a + signed_b;
          rs[i_4][107:86] = result;
          rs[i_4][110:110] = 1'b1;
        end

        if (rs[i_4][80:74] == ADDX || rs[i_4][80:74] == ADDX_CC) begin
          signed_a = rs[i_4][41:10];   // convert to signed
          signed_b = rs[i_4][73:42];   // convert to signed
          in_icc_c = rs[i_4][111:111];
          result = #10 signed_a + signed_b + in_icc_c;
          rs[i_4][107:86] = result;
          rs[i_4][110:110] = 1'b1;
        end

        if (rs[i_4][80:74] == SUB || rs[i_4][80:74] == SUB_CC) begin
          signed_a = rs[i_4][41:10];   // convert to signed
          signed_b = rs[i_4][73:42];   // convert to signed
          result = #10 signed_a - signed_b;
          rs[i_4][107:86] = result;
          rs[i_4][110:110] = 1'b1;
        end

        if (rs[i_4][80:74] == SUBX || rs[i_4][80:74] == SUBX_CC) begin
          signed_a = rs[i_4][41:10];   // convert to signed
          signed_b = rs[i_4][73:42];   // convert to signed
          in_icc_c = rs[i_4][111:111];
          result = #10 signed_a - signed_b - in_icc_c;
          rs[i_4][107:86] = result;
          rs[i_4][110:110] = 1'b1;
        end

        // modify iccs
        if (in_operator_type[4] == 1) begin
          out_icc_n = result[31];
          out_icc_z = (result == 33'b0);
          out_icc_c = result[32];
          out_icc_v = ~(rs[i_4][75] ^ rs[i_4][43]) & (result[31] ^ rs[i_4][75]);
        end

      end
    end
  join
end

endmodule
