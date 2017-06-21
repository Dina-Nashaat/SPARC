`include "rs_mux.v"
`include "cdb.v"
`include "current_instruction.v"
`include "register_status.v"
`include "rs_mul.v"
`include "rs_add.v"
`include "rs_logic.v"
module test;

reg clk = 0;
always #5 clk = !clk;

parameter INVALID_TAG = 5'b11111;

parameter UMUL = 6'b001010;
parameter ADD = 6'b000000;
parameter ADDX = 6'b001000;
parameter SLL = 6'b100101;
parameter SRL = 6'b100110;

reg out_fetch_next;
reg [5:0] out_operator_type;
reg [4:0] out_reg_1;
reg [4:0] out_reg_2;
reg [4:0] out_reg_3;
reg [3:0] out_ICC_flags;

reg [31:0] out_Y_val;

RS_MUX rs_mux (
               .clk(clk),

               .in_enable_add(rs_add.out_rs_enable),
               .in_tag_add(rs_add.out_rs_tag),

               .in_enable_logic(rs_logic.out_rs_enable),
               .in_tag_logic(rs_logic.out_rs_tag),

               .in_enable_mul(rs_mul.out_rs_enable),
               .in_tag_mul(rs_mul.out_rs_tag),

               .in_enable_load(1'b0),
               .in_tag_load(5'b0),

               .in_enable_store(1'b0),
               .in_tag_store(5'b0)
               );

CUR_INST cur_inst (
                   .clk(clk),

                   .in_fetch_next(out_fetch_next),
                   .in_operator_type(out_operator_type),
                   .in_reg_1(out_reg_1),
                   .in_reg_2(out_reg_2),
                   .in_reg_3(out_reg_3),
                   .in_ICC_flags(out_ICC_flags),

                   .in_enable(reg_status.out_enable),
                   .in_val_1(reg_status.out_val_1),
                   .in_val_2(reg_status.out_val_2),
                   .in_tag_1(reg_status.out_tag_1),
                   .in_tag_2(reg_status.out_tag_2),

                   .in_CDB_broadcast(cdb.out_broadcast),
                   .in_CDB_tag(cdb.out_tag),
                   .in_CDB_val(cdb.out_val),

                   .in_rs_enable(rs_mux.out_enable),
                   .in_rs_tag(rs_mux.out_tag)
               );

REG_STATUS reg_status (
                       .clk(clk),

                       .in_enable(cur_inst.out_enable),
                       .in_reg_1(cur_inst.out_reg_1),
                       .in_reg_2(cur_inst.out_reg_2),

                       .in_bank_enable(cur_inst.out_bank_enable),
                       .in_bank_reg(cur_inst.out_bank_reg),
                       .in_bank_tag(cur_inst.out_bank_tag),

                       .in_CDB_broadcast(cdb.out_broadcast),
                       .in_CDB_tag(cdb.out_tag),
                       .in_CDB_val(cdb.out_val)
                       );

CDB cdb (
         .clk(clk),

         .in_request_add(rs_add.out_CDB_broadcast),
         .in_tag_add(rs_add.out_CDB_tag),
         .in_val_add(rs_add.out_CDB_val),

         .in_request_logic(rs_logic.out_CDB_broadcast),
         .in_tag_logic(rs_logic.out_CDB_tag),
         .in_val_logic(rs_logic.out_CDB_val),

         .in_request_mul(rs_mul.out_CDB_broadcast),
         .in_tag_mul(rs_mul.out_CDB_tag),
         .in_val_mul(rs_mul.out_CDB_val),

         .in_request_load(1'b0),
         .in_tag_load(5'b0),
         .in_val_load(32'b0),

         .in_request_store(1'b0),
         .in_tag_store(5'b0),
         .in_val_store(32'b0)
         );

MUL_RS rs_mul(
              .clk(clk),

              .in_rs_enable(cur_inst.out_rs_enable),
              .in_operator_type(cur_inst.out_operator_type),
              .in_val_1(cur_inst.out_val_1),
              .in_val_2(cur_inst.out_val_2),
              .in_tag_1(cur_inst.out_tag_1),
              .in_tag_2(cur_inst.out_tag_2),

              .in_CDB_broadcast(cdb.out_broadcast),
              .in_CDB_tag(cdb.out_tag),
              .in_CDB_val(cdb.out_val),

              .in_Y_val(out_Y_val)
              );

ADD_RS rs_add(
              .clk(clk),

              .in_rs_enable(cur_inst.out_rs_enable),
              .in_operator_type(cur_inst.out_operator_type),
              .in_val_1(cur_inst.out_val_1),
              .in_val_2(cur_inst.out_val_2),
              .in_tag_1(cur_inst.out_tag_1),
              .in_tag_2(cur_inst.out_tag_2),
              .in_ICC_flags(cur_inst.out_ICC_flags),

              .in_CDB_broadcast(cdb.out_broadcast),
              .in_CDB_tag(cdb.out_tag),
              .in_CDB_val(cdb.out_val)
              );

LOGIC_RS rs_logic(
              .clk(clk),

              .in_rs_enable(cur_inst.out_rs_enable),
              .in_operator_type(cur_inst.out_operator_type),
              .in_val_1(cur_inst.out_val_1),
              .in_val_2(cur_inst.out_val_2),
              .in_tag_1(cur_inst.out_tag_1),
              .in_tag_2(cur_inst.out_tag_2),

              .in_CDB_broadcast(cdb.out_broadcast),
              .in_CDB_tag(cdb.out_tag),
              .in_CDB_val(cdb.out_val)
              );

initial begin
  out_ICC_flags = 4'b0;
  #1000 $finish;
end

integer i = 0;
always @(posedge cur_inst.out_fetch_next) begin
  if (i == 0) begin
    out_operator_type = UMUL;
    out_reg_1 = 5'h0;
    out_reg_2 = 5'h1;
    out_reg_3 = 5'h2;
    out_fetch_next = 1'b0;
    i = i + 1;
    #5;
    out_fetch_next = 1'b1;
    #5;
    out_fetch_next = 1'b0;
  end else begin
    if (i == 1) begin
      out_operator_type = UMUL;
      // out_reg_1 = 5'h3;
      out_reg_1 = 5'h2;
      out_reg_2 = 5'h4;
      out_reg_3 = 5'h5;
      out_fetch_next = 1'b0;
      i = i + 1;
      #5;
      out_fetch_next = 1'b1;
    end else begin
      if (i == 2) begin
        // out_ICC_flags = 4'b1000;
        out_ICC_flags = 4'b0;
        out_operator_type = ADDX;
        out_reg_1 = 5'h0;
        out_reg_2 = 5'h3;
        out_reg_3 = 5'h7;
        out_fetch_next = 1'b0;
        i = i + 1;
        #5;
        out_fetch_next = 1'b1;
      end else begin
        if (i == 3) begin
          // $display("## At cycle %4t\n", $time/5);
          out_operator_type = SRL;
          out_reg_1 = 5'h8;
          out_reg_2 = 5'h0;
          out_reg_3 = 5'h9;
          out_fetch_next = 1'b0;
          i = i + 1;
          #5;
          out_fetch_next = 1'b1;
        end
      end
    end
  end
end

endmodule
