module data_cache #(parameter CACHE_WIDTH = 32, ADDR_WIDTH = 32) // 32-bit Cache
(
  input wire [ADDR_WIDTH-1 : 0] addr,                      // Memory Address
  input wire [CACHE_WIDTH-1 : 0] write_data,               // Memory Address Contents
  input wire memwrite,
  input wire clk,                                          // All synchronous elements,
                                                           // including memories,
                                                           // should have a clock
  output reg [CACHE_WIDTH-1 : 0] read_data                   // Output of Memory
                                                           // Address Contents
);

parameter CACHE_SIZE = 2 ** 13;                            // 4 * 8 Kilo Byte Cache
parameter BLOCKS_IN_SET = 16;                              // 16-way Cache
parameter BLOCK_SIZE = 4;                                  // 4 Bytes per Block
parameter SET_COUNT = CACHE_SIZE / BLOCKS_IN_SET;          // no. of Sets in Cache
parameter TAG_SIZE = 32 - $clog2(SET_COUNT) - $clog2(BLOCK_SIZE);

reg [CACHE_WIDTH-1 : 0] CACHE[0 : CACHE_SIZE-1];
reg [TAG_SIZE-1 : 0]    TAGS[0 : CACHE_SIZE-1];

wire [31 : 0] addr_wire = addr;
wire [31 : 0] write_data_wire = write_data;
wire memwrite_wire = memwrite;
wire [31 : 0] read_data_wire;

reg [31:0] random;
reg flag;
reg [TAG_SIZE-1 : 0] tag_reg;
integer cur_set_num, rand_block_num, loop_set_num, loop_i;

data_memory MEMO (addr_wire, write_data_wire, memwrite_wire, clk, read_data_wire);

always @(posedge clk) begin

  flag = 1'b0;
  // random = $urandom_range(BLOCKS_IN_SET, 0);
  random = $random;
  cur_set_num = (addr/BLOCK_SIZE) % SET_COUNT;
  tag_reg = addr[CACHE_WIDTH-1 : CACHE_WIDTH-TAG_SIZE];
  rand_block_num = BLOCKS_IN_SET*cur_set_num + random;

  if (memwrite == 1'b1) begin                              // Write to Cache
    CACHE[rand_block_num] = #205 write_data;
    TAGS[rand_block_num] <= tag_reg;
  end

  if (memwrite == 1'b0) begin                              // Read from Cache
    for(loop_i = 0 ; loop_i < BLOCKS_IN_SET; loop_i = loop_i+1) begin
      loop_set_num = BLOCKS_IN_SET*cur_set_num + loop_i;
      if(TAGS[loop_set_num] == tag_reg) begin              // Hit (found in Cache)
        read_data <= #5 CACHE[loop_set_num];
        flag = 1'b1;
      end
    end
    if(flag == 1'b0) begin                                 // Miss (not found in Cache)
      CACHE[rand_block_num] = #5 read_data_wire;
      read_data <= CACHE[rand_block_num];
    end
  end

end

endmodule
