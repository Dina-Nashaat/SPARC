module data_memory #(parameter CACHE_WIDTH = 32, ADDR_WIDTH = 32)
(
  input wire [ADDR_WIDTH-1 : 0] addr,                      // Memory Address
  input wire [CACHE_WIDTH-1 : 0] write_data,               // Memory Address Contents
  input wire memwrite,
  input wire clk,                                          // All synchronous elements,
                                                           // including memories,
                                                           // should have a clock
  output reg [CACHE_WIDTH-1 : 0] read_data                            // Output of Memory
                                                           // Address Contents
);

parameter MEMORY_SIZE = 2 ** 20;                           // 4 * 1 Mega Byte Memory
parameter MEMORY_WIDTH = 32;                               // 32-bit (4 bytes) Line

reg [MEMORY_WIDTH-1 : 0] MEMORY[0 : MEMORY_SIZE-1];

always @(posedge clk) begin

  if (memwrite == 1'b1) begin                              // Write to Memory
    MEMORY[addr[MEMORY_WIDTH-1 : $clog2(MEMORY_WIDTH/8)]] <= #100 write_data;
  end
  if (memwrite == 1'b0) begin                              // Read from Memory
    read_data <= #100 MEMORY[addr[MEMORY_WIDTH-1 : $clog2(MEMORY_WIDTH/8)]];
  end

end

endmodule
