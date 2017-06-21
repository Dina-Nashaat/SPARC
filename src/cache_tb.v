//`include "cache.v"
module test;

  reg clk = 0;
  always #1 clk = !clk;

  reg  enable;
  reg  [31:0] addr_reg = 32'b1;
  wire [31:0] addr_wire = addr_reg;
  reg  [31:0] write_data_reg = 32'b0;
  wire [31:0] write_data_wire = write_data_reg;
  wire [31:0] read_data_wire;

  wire read_finished_wire;
  wire write_finished_wire;
  reg memwrite_reg = 1'b0;
  wire memwrite_wire = memwrite_reg;

  data_cache CACHE (addr_wire, write_data_wire, memwrite_wire, clk, enable,
                    read_data_wire, write_finished_wire, read_finished_wire);

  initial begin
    enable = 1'b0;
    #10
    write_data_reg = 32'b111;
    memwrite_reg = 1'b1;
    enable = 1'b1;
    #10
    enable = 1'b0;
    #400
    memwrite_reg = 1'b0;
    enable = 1'b1;
    #5;
    enable = 1'b0;
    #320;
    addr_reg = 32'b100000;
    write_data_reg = 32'b11;
    memwrite_reg = 1'b1;
    enable = 1'b1;
    #10 memwrite_reg = 1'b0;
    enable = 1'b0;
    #120;
    addr_reg = 32'b1;
    enable = 1'b1;
    #10;
    enable = 1'b0;
    #300;
     addr_reg = 32'b100000;
     enable = 1'b1;
    #500 $finish;
  end

  initial begin
    $monitor(
             "memwrite:  %d, ", memwrite_wire,
             "Addr: %d, ", addr_wire,
             "W Data: %d, ", write_data_wire,
             "R Data: %d, ", read_data_wire,
             "write_finished: %d, ", write_finished_wire,
             "read_finished: %d, ", read_finished_wire
             );
  end

endmodule
