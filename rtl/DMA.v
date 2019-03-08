module DMA(
    input wire HCLK,
    input wire HRESETn,
    output wire [31:0] HADDRD, 
    output wire [1:0] HTRANSD, 
    output wire [2:0] HSIZED, 
    output wire [2:0] HBURSTD, 
    output wire [3:0] HPROTD, 
    output wire HWRITED, 
    output reg [31:0] HWDATAD, 
    input wire [31:0] HRDATAD,
    input wire HREADYD,
    input wire HRESPD,
    input wire DMAstart,
    output wire DMAdone,
    input wire [31:0] DMAsrc,
    input wire [31:0] DMAdst,
    input wire [1:0] DMAsize,
    input wire [31:0] DMAlen
);

//CONSTANT SIGNAL
assign HPROTD = 4'b0011;
assign HBURSTD = 3'b000;

//FSM
parameter idle = 2'b00;
parameter wait_for_ready = 2'b01;
parameter read = 2'b10;
parameter write = 2'b11;

reg [1:0] state_c,state_n;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) state_c <= idle;
    else state_c <= state_n;
end

always@(*) begin
    case(state_c)
    idle : begin
        if(DMAstart) state_n = wait_for_ready;
        else state_n = state_c;
    end wait_for_ready : begin
        if(HREADYD) state_n = read;
        else state_n = state_c;
    end read : begin
        if(HREADYD) state_n =write;
        else state_n =state_c;
    end write : begin
        if(DMAdone) state_n = idle;
        else begin
            if(HREADYD) state_n = read;
            else state_n =state_c;
        end
    end
    endcase
end

//SIZE REG
reg [1:0] size;
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) size <= 2'b0;
    else if(DMAstart) size <= DMAsize;
end

wire [2:0] size_dec;
assign size_dec = (size == 2'b00) ? 3'b001 : (
                  (size == 2'b01) ? 3'b010 : (
                  (size == 2'b10) ? 3'b100 : 3'b000));    
                  
//LEN REG
reg [31:0] len;
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) len <= 32'b0;
    else if(DMAstart) len <= DMAlen;
end

//READ ADDRESS CONTROL
reg [31:0] read_addr;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) read_addr <= 32'b0;
    else if(state_c == idle) begin
        if(DMAstart) read_addr <= DMAsrc;
    end else if(state_c == read) begin
        if(HREADYD) read_addr <= read_addr + size_dec;
    end
end

//WRITE ADDRESS CONTROL
reg [31:0] write_addr;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) write_addr <= 32'b0;
    else if(state_c == idle) begin
        if(DMAstart) write_addr <= DMAdst;
    end else if(state_c == write) begin
        if(HREADYD) write_addr <= write_addr + size_dec;
    end
end

//HSIZE
assign HSIZED = {1'b0,size};

//HTRANS
assign HTRANSD = ((state_c == read) || (state_c == write)) ? 2'b10 : 2'b00;

//COUNTER
reg [31:0] cnt;

always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) cnt <= 32'b0;
    else if(DMAdone) cnt <= 32'b0;
    else if((state_c == write) && HREADYD) cnt <= cnt + 1'b1;
end

assign DMAdone = (cnt == len) & (state_c == write) & HREADYD;
assign HWRITED = (state_c == write);
assign HADDRD = HWRITED ? write_addr : read_addr;

//HWDATA
always@(posedge HCLK or negedge HRESETn) begin
    if(~HRESETn) HWDATAD <= 32'b0;
    else if((state_c == write) && HREADYD) HWDATAD <= HRDATAD;
end

endmodule