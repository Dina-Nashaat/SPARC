/*
  88:88 busy
  87:82 dest_tag
  81:76 operator
  75:44 data_2
  43:12 data_1
  11:6 tag_2
  5:0 tag_1
*/

module MUL_RS (
  input wire in_clock,
  input wire[5:0] in_operator_type,
  input wire[31:0] in_data1,
  input wire[31:0] in_data2,
  input wire[5:0] in_tag1,
  input wire[5:0] in_tag2,

  input wire in_CDB_is_cast,
  input wire[5:0] in_CDB_tag,
  input wire[31:0] in_CDB_data,

  input wire in_unit_enable,

  output reg[5:0] out_tag,
  output reg[31:0] out_data,
  output reg out_broadcast,
  output reg out_available
);

parameter UMUL = 6'b001010;
parameter SMUL = 6'b001011;
parameter UMUL_CC = 6'b011010;
parameter SMUL_CC = 6'b011011;

parameter INVALID_NUM = 6'b111111;

reg icc_n, icc_z, icc_c, icc_v;

reg signed [31:0] signed_a;
reg signed [31:0] signed_b;
reg signed [63:0] result;
reg signed [31:0] remain_result;

reg[88:0] rs[0:3];
integer i;

reg breakmark;

initial begin
  out_broadcast = 1'b0;
  for (i = 0;i < 4; i=i+1) begin
    rs[i] = {89{1'b0}};
  end
  out_available = 1'b1;
  //busy = 1'b0;
end

always @(posedge in_CDB_is_cast) begin
  for (i = 0;i < 4; i=i+1) begin
    if (rs[i][88:88] == 1'b1 && in_CDB_is_cast == 1'b1) begin
      if (rs[i][5:0] == in_CDB_tag) begin
        rs[i][43:12] = in_CDB_data;
        rs[i][5:0] =  INVALID_NUM;
      end
      if (rs[i][11:6] == in_CDB_tag) begin
        rs[i][75:44] = in_CDB_data;
        rs[i][11:6] = INVALID_NUM;
      end
      /*if (rs[i][5:0] == invalidNum and rs[i][11:6] == invalidNum) begin
        rs[i][88:88] = 1'b0;
        data_out = rs[i][75:44]+rs[i][43:12];
        broadcast = 1'b1;
        available = 1'b1;
      end*/
    end
  end
end

always @(posedge in_clock) begin
  #50
  out_broadcast = 1'b0;
  //busy = 1'b1;
  // breakmark = 1'b0;
  //robNum_out = robNum;
  for (i = 0;i < 4; i = i+1) begin
    if (rs[i][88:88] == 1'b1) begin
      if (rs[i][5:0] == INVALID_NUM && rs[i][11:6] == INVALID_NUM) begin

        if (rs[i][81:76] == UMUL || rs[i][81:76] == UMUL_CC) begin
          result =  rs[i][43:12] * rs[i][75:44];
          out_data = result[31:0];
          remain_result = result[63:32];
        end

        if (rs[i][81:76] == SMUL || rs[i][81:76] == SMUL_CC) begin
          signed_a = rs[i][43:12];   //Convert to signed
          signed_b = rs[i][75:44];   //Convert to signed
          result = signed_a * signed_b;
          out_data = result[31:0];
          remain_result = result[63:32];
          end

        // modify icc
        if (in_operator_type[4] == 1) begin
          icc_n = result[31];
          icc_z = (result[31:0] == 32'b0);
          icc_v = 1'b0;
          icc_c = 1'b0;
        end

        rs[i][88:88] = 1'b0;
        out_tag = rs[i][87:82];
        out_broadcast = 1'b1;
        out_available = 1'b1;
      end
    end
  end
end

reg[31:0] data1_tmp;
reg[5:0] tag1_tmp;
reg[31:0] data2_tmp;
reg[5:0] tag2_tmp;

always @(posedge in_unit_enable) begin
  if (in_operator_type == UMUL || in_operator_type == SMUL || in_operator_type == UMUL_CC || in_operator_type == SMUL_CC) begin
    /*if (q1 == invalidNum and q2 == invalidNum) begin
      data_out <= data1+data2;
      broadcast <= 1'b1;
    end else */

    begin

      #0.01
      data1_tmp = in_data1;
      tag1_tmp = in_tag1;

      data1_tmp = in_data1;
      tag1_tmp = in_tag1;

      #0.01
      /*if (q1 == invalidNum and q2 == invalidNum) begin
        data_out <= data1+data2;
        broadcast <= 1'b1;
      end else */
        //broadcast <= 1'b0;

        for (i = 0; i < 4; i=i+1) begin
          if (rs[i][88:88] == 1'b0) begin
            rs[i][5:0] = in_tag1;
            rs[i][11:6] = in_tag2;
            rs[i][43:12] = in_data1;
            rs[i][75:44] = in_data2;
            rs[i][81:76] = in_operator_type;
            rs[i][87:82] = {2'b01, i};
            rs[i][88:88] = 1'b1;
          end
        end
        out_available = 1'b0;
        for (i = 0; i < 4; i=i+1) begin
          if (rs[i][88:88] == 1'b0) begin
            out_available = 1'b1;
          end
        end
    end
  end
end

endmodule
