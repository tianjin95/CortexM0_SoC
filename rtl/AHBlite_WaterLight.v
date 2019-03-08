module AHBlite_WaterLight(
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
    output reg     [7:0] WaterLight_mode,
    output reg     [31:0] WaterLight_speed  
);

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;
assign HRDATA = 32'b0;

wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

reg addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 1'b0;
  else if(write_en) addr_reg <= HADDR[2];
end

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) wr_en_reg <= 1'b0;
  else if(write_en) wr_en_reg <= 1'b1;
  else wr_en_reg <= 1'b0;
end

always@(posedge HCLK) begin
    if(~HRESETn) begin
        WaterLight_mode <= 8'h00;
        WaterLight_speed <= 8'h00;
    end else if(wr_en_reg && HREADY) begin
        if(~addr_reg)
            WaterLight_mode <= HWDATA[7:0];
        else    
            WaterLight_speed <= HWDATA;
    end
end

endmodule


