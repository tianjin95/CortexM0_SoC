module AHBlite_DMAC(
    //AHB SLAVE
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
    input  wire          HMASTERC,
    //DMA CONTROL
    input  wire          DMAdone,
    input  wire          SLEEPing,
    output wire          DMAstart,
    output reg    [31:0] DMAsrc,
    output reg    [31:0] DMAdst,
    output reg     [1:0] DMAsize,
    output reg    [31:0] DMAlen,
    output wire          HMASTERSEL
);

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;
assign HRDATA = 32'b0;

wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) wr_en_reg <= 1'b0;
  else if(write_en) wr_en_reg <= 1'b1;
  else wr_en_reg <= 1'b0;
end

reg [1:0] addr_reg;
always@(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) addr_reg <= 2'b0;
  else if(write_en) addr_reg <= HADDR[3:2];
end


always@(posedge HCLK) begin
    if(~HRESETn) begin
        DMAsrc <= 32'b0;
        DMAdst <= 32'b0;
        DMAsize <= 2'b0;
        DMAlen <= 32'b0;
    end else if(wr_en_reg) begin
        if(addr_reg == 2'b0)
            DMAsrc <= HWDATA;
        else if(addr_reg == 2'b01)
            DMAdst <= HWDATA;
        else if(addr_reg == 2'b10)
            DMAsize <= HWDATA[1:0];
        else begin
            DMAlen <= HWDATA;
        end
    end
end

parameter idle = 2'b00;
parameter wait_for_trans = 2'b01;
parameter trans = 2'b10;
parameter wait_for_stop = 2'b11;

reg [1:0] state_c,state_n;

always@(posedge HCLK) begin
    if(~HRESETn) state_c <= idle;
    else state_c <= state_n;
end

always@(*) begin
    case(state_c)
    idle : begin
        if(wr_en_reg  && (addr_reg == 2'b11)) state_n = wait_for_trans;
        else state_n = state_c;
    end wait_for_trans : begin
        if(SLEEPing) state_n = trans;
        else state_n = state_c;
    end trans : begin
        if(DMAdone) state_n = wait_for_stop;
        else state_n =state_c;
    end wait_for_stop : begin
        if(~SLEEPing) state_n = idle;
        else state_n = state_c;
    end
    endcase
end

assign DMAstart = (state_c == wait_for_trans) & SLEEPing;
assign HMASTERSEL = ~((state_c == trans) & HMASTERC);

endmodule