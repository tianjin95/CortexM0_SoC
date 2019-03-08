module AHBlite_Distributed_RAM #(
    parameter            ADDR_WIDTH = 14)(
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,    
    input  wire          HREADY,
    output wire          HREADYOUT, 
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    output wire   [ADDR_WIDTH-1:0] DRAM_ADDR,
    input  wire   [31:0] DRAM_RDATA,
    output wire   [31:0] DRAM_WDATA,
    output wire   [3:0]  DRAM_WRITE
);

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;
assign HRDATA = DRAM_RDATA;

wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

wire read_en;
assign read_en = HSEL & HTRANS[1] & (~HWRITE) & HREADY;

wire [3:0] size_dec;
assign size_dec = (HSIZE == 3'b000) ? 4'h1 : (
                  (HSIZE == 3'b001) ? 4'h3 : (
                  (HSIZE == 3'b010) ? 4'hf : 4'h0));

reg [3:0] size_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) size_reg <= 0;
  else if(write_en) size_reg <= size_dec;
end


reg [13:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 0;
  else if(read_en || write_en) addr_reg <= HADDR[(ADDR_WIDTH+1):2];
end

assign DRAM_ADDR = addr_reg;

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) wr_en_reg <= 1'b0;
  else if(write_en) wr_en_reg <= 1'b1;
  else wr_en_reg <= 1'b0;
end

assign DRAM_WRITE = wr_en_reg ? size_reg : 4'h0;
assign DRAM_WDATA = HWDATA; 

endmodule
