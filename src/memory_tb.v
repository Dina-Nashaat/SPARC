module test;

  reg clk = 0;
  always #1 clk = !clk;

  reg  [31:0] addr_reg = 32'b1;
  wire [31:0] addr_wire = addr_reg;
  reg  [31:0] write_data_reg = 32'b0;
  wire [31:0] write_data_wire = write_data_reg;
  wire [31:0] read_data_wire;
  reg memwrite_reg = 1'b0;
  wire memwrite_wire = memwrite_reg;

  data_memory m1 (addr_wire, write_data_wire, memwrite_wire, clk, read_data_wire);

  initial begin
    #10 write_data_reg = 32'b111;
    memwrite_reg = 1'b1;
    #10 memwrite_reg = 1'b0;
    #320 addr_reg = 32'b101;
    write_data_reg = 32'b11;
    memwrite_reg = 1'b1;
    #10 memwrite_reg = 1'b0;
    #120 addr_reg = 32'b1;
    #500 $finish;
  end

  initial
     $monitor("At time %t, ", $time,
              "memwrite:  %d, ", memwrite_wire,
              "Addr: %d, ", addr_wire,
              "W Data: %d, ", write_data_wire,
              "R Data: %d", read_data_wire);

endmodule
