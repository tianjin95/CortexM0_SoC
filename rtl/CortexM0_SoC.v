
module CortexM0_SoC (
        input  wire  clk,
        input  wire  RSTn,
        inout  wire  SWDIO,  
        input  wire  SWCLK,
        output wire [7:0] LED,
        output wire  LEDclk,
        output  wire  RXD,
        input wire  TXD
);

//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

wire SWDO;
wire SWDOEN;
wire SWDI;

assign SWDI = SWDIO;
assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// Interrupt
//------------------------------------------------------------------------------

wire [31:0] IRQ;
wire interrupt_UART;
assign IRQ = {31'b0,interrupt_UART};

//------------------------------------------------------------------------------
// AHB
//------------------------------------------------------------------------------

wire [31:0] HADDRC;
wire [ 2:0] HBURSTC;
wire [ 3:0] HPROTC;
wire [ 2:0] HSIZEC;
wire [ 1:0] HTRANSC;
wire [31:0] HWDATAC;
wire        HWRITEC;
wire [31:0] HRDATAC;
wire        HRESPC;
wire        HMASTERC;
wire        HREADYC;

//------------------------------------------------------------------------------
// RESET AND DEBUG
//------------------------------------------------------------------------------

wire SYSRESETREQ;
reg cpuresetn;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) cpuresetn <= 1'b0;
        else if (SYSRESETREQ) cpuresetn <= 1'b0;
        else cpuresetn <= 1'b1;
end

wire CDBGPWRUPREQ;
reg CDBGPWRUPACK;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) CDBGPWRUPACK <= 1'b0;
        else CDBGPWRUPACK <= CDBGPWRUPREQ;
end

wire SLEEPHOLDACKn;
reg SLEEPHOLDREQn;

always @(posedge clk or negedge RSTn)begin
        if (~RSTn) SLEEPHOLDREQn <= 1'b1;
        else SLEEPHOLDREQn <= SLEEPHOLDACKn;
end

wire SLEEPing;
wire DMAdone;

//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------

cortexm0ds_logic u_logic (

        // System inputs
        .FCLK           (clk),           //FREE running clock 
        .SCLK           (clk),           //system clock
        .HCLK           (clk),           //AHB clock
        .DCLK           (clk),           //Debug clock
        .PORESETn       (RSTn),          //Power on reset
        .HRESETn        (cpuresetn),     //AHB and System reset
        .DBGRESETn      (RSTn),          //Debug Reset
        .RSTBYPASS      (1'b0),          //Reset bypass
        .SE             (1'b0),          // dummy scan enable port for synthesis

        // Power management inputs
        .SLEEPHOLDREQn  (SLEEPHOLDREQn),          // Sleep extension request from PMU
        .WICENREQ       (1'b0),          // WIC enable request from PMU
        .CDBGPWRUPACK   (CDBGPWRUPACK),  // Debug Power Up ACK from PMU
        .SLEEPING       (SLEEPing),
        .SLEEPHOLDACKn  (SLEEPHOLDACKn),

        // Power management outputs
        .CDBGPWRUPREQ   (CDBGPWRUPREQ),
        .SYSRESETREQ    (SYSRESETREQ),

        // System bus
        .HADDR          (HADDRC),
        .HTRANS         (HTRANSC),
        .HSIZE          (HSIZEC),
        .HBURST         (HBURSTC),
        .HPROT          (HPROTC),
        .HWRITE         (HWRITEC),
        .HWDATA         (HWDATAC),
        .HRDATA         (HRDATAC),
        .HREADY         (HREADYC),
        .HRESP          (HRESPC),
        .HMASTER        (HMASTERC),

        // Interrupts
        .IRQ            (IRQ),          //Interrupt
        .NMI            (1'b0),         //Watch dog interrupt
        .IRQLATENCY     (8'h0),
        .ECOREVNUM      (28'h0),

        // Systick
        .STCLKEN        (1'b0),
        .STCALIB        (26'h0),

        // Debug - JTAG or Serial wire
        // Inputs
        .nTRST          (1'b1),
        .SWDITMS        (SWDI),
        .SWCLKTCK       (SWCLK),
        .TDI            (1'b0),
        // Outputs
        .SWDO           (SWDO),
        .SWDOEN         (SWDOEN),

        .DBGRESTART     (1'b0),

        // Event communication
        .RXEV           (DMAdone),         // Generate event when a DMA operation completed.
        .EDBGRQ         (1'b0)          // multi-core synchronous halt request
);

//------------------------------------------------------------------------------
// AHB DMA MASTER
//------------------------------------------------------------------------------
wire [31:0] HADDRD;
wire [ 2:0] HBURSTD;
wire [ 3:0] HPROTD;
wire [ 2:0] HSIZED;
wire [ 1:0] HTRANSD;
wire [31:0] HWDATAD;
wire        HWRITED;
wire [31:0] HRDATAD;
wire        HRESPD;
wire        HMASTERD;
wire        HREADYD;
wire [31:0] DMAdst;
wire [31:0] DMAsrc;
wire [1:0] DMAsize;
wire [31:0] DMAlen;
wire DMAstart;

DMA MicroDMA(
        .HCLK(clk),
        .HRESETn(RSTn),
        .HADDRD(HADDRD),
        .HTRANSD(HTRANSD),
        .HSIZED(HSIZED),
        .HBURSTD(HBURSTD),
        .HPROTD(HPROTD),
        .HWRITED(HWRITED),
        .HWDATAD(HWDATAD),
        .HRDATAD(HRDATAD),
        .HREADYD(HREADYD),
        .HRESPD(HRESPD),
        .DMAstart(DMAstart),
        .DMAdst(DMAdst),
        .DMAdone(DMAdone),
        .DMAsrc(DMAsrc),
        .DMAsize(DMAsize),
        .DMAlen(DMAlen)
);

//------------------------------------------------------------------------------
// AHB MASTER MUX
//------------------------------------------------------------------------------

wire [31:0] HADDR;
wire [ 2:0] HBURST;
wire [ 3:0] HPROT;
wire [ 2:0] HSIZE;
wire [ 1:0] HTRANS;
wire [31:0] HWDATA;
wire        HWRITE;
wire [31:0] HRDATA;
wire        HRESP;
wire        HREADY;
wire HMASTERSEL;

AHBlite_MasterMUX MasterMUX(
        .HCLK(clk),
        .HRESETn(RSTn),
        .HMASTERSEL(HMASTERSEL),
        // CORE SIDE
        .HADDRC(HADDRC),
        .HTRANSC(HTRANSC),
        .HSIZEC(HSIZEC),
        .HBURSTC(HBURSTC),
        .HPROTC(HPROTC),
        .HRDATAC(HRDATAC),
        .HWDATAC(HWDATAC),
        .HWRITEC(HWRITEC),
        .HREADYC(HREADYC),
        .HRESPC(HRESPC),
        // DMA SIDE
        .HADDRD(HADDRD),
        .HTRANSD(HTRANSD),
        .HSIZED(HSIZED),
        .HBURSTD(HBURSTD),
        .HPROTD(HPROTD),
        .HRDATAD(HRDATAD),
        .HWDATAD(HWDATAD),
        .HWRITED(HWRITED),
        .HREADYD(HREADYD),
        .HRESPD(HRESPD),
        // OUTPUT SIDE
        .HADDR(HADDR),
        .HTRANS(HTRANS),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HPROT(HPROT),
        .HRDATA(HRDATA),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HREADY(HREADYOUT),
        .HRESP(HRESP)
);

//------------------------------------------------------------------------------
// AHB BUS SLAVE DECODER
//------------------------------------------------------------------------------

wire RAMCODE_HSEL;
wire RAMDATA_HSEL;
wire WaterLight_HSEL;
wire DMAC_HSEL;

AHBlite_Decoder #(
        .RAMCODE_en(1'b1),
        .WaterLight_en(1'b1),
        .RAMDATA_en(1'b1),
        .UART_en(1'b1),
        .DMAC_en(1'b1)
) Decoder (
        .HADDR(HADDR),
        .RAMCODE_HSEL(RAMCODE_HSEL),
        .WaterLight_HSEL(WaterLight_HSEL),
        .RAMDATA_HSEL(RAMDATA_HSEL),
        .UART_HSEL(UART_HSEL),
        .DMAC_HSEL(DMAC_HSEL)
);

//------------------------------------------------------------------------------
// AHB RAMCODE
//------------------------------------------------------------------------------
wire [31:0] RAMCODE_HRDATA;
wire RAMCODE_HREADYOUT;
wire RAMCODE_HRESP;
wire [31:0] RAMCODE_RDATA,RAMCODE_WDATA;
wire [13:0] RAMCODE_ADDR;
wire [3:0] RAMCODE_WRITE;

AHBlite_Distributed_RAM RAMCODE_Interface(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HSEL(RAMCODE_HSEL),
        .HADDR(HADDR),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(RAMCODE_HRDATA),
        .HREADY(HREADYOUT),
        .HREADYOUT(RAMCODE_HREADYOUT),
        .HRESP(RAMCODE_HRESP),
        .DRAM_ADDR(RAMCODE_ADDR),
        .DRAM_RDATA(RAMCODE_RDATA),
        .DRAM_WDATA(RAMCODE_WDATA),
        .DRAM_WRITE(RAMCODE_WRITE)
);

//------------------------------------------------------------------------------
// AHB WaterLight
//------------------------------------------------------------------------------

wire [31:0] WaterLight_HRDATA;
wire WaterLight_HREADYOUT;
wire WaterLight_HRESP;
wire [7:0] WaterLight_mode;
wire [31:0] WaterLight_speed;

AHBlite_WaterLight WaterLight_Interface(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HSEL(WaterLight_HSEL),
        .HADDR(HADDR),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(WaterLight_HRDATA),
        .HREADY(HREADYOUT),
        .HREADYOUT(WaterLight_HREADYOUT),
        .HRESP(WaterLight_HRESP),
        .WaterLight_mode(WaterLight_mode),
        .WaterLight_speed(WaterLight_speed)
);

//------------------------------------------------------------------------------
// AHB RAMDATA
//------------------------------------------------------------------------------

wire [31:0] RAMDATA_HRDATA;
wire RAMDATA_HREADYOUT;
wire RAMDATA_HRESP;
wire [31:0] RAMDATA_RDATA;
wire [31:0] RAMDATA_WDATA;
wire [13:0] RAMDATA_ADDR;
wire [3:0] RAMDATA_WRITE;

AHBlite_Block_RAM RAMDATA_Interface(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HSEL(RAMDATA_HSEL),
        .HADDR(HADDR),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(RAMDATA_HRDATA),
        .HREADY(HREADYOUT),
        .HREADYOUT(RAMDATA_HREADYOUT),
        .HRESP(RAMDATA_HRESP),
        .BRAM_ADDR(RAMDATA_ADDR),
        .BRAM_WDATA(RAMDATA_WDATA),
        .BRAM_RDATA(RAMDATA_RDATA),
        .BRAM_WRITE(RAMDATA_WRITE)
);

//------------------------------------------------------------------------------
// AHB UART
//------------------------------------------------------------------------------

wire [31:0] UART_HRDATA;
wire UART_HREADYOUT;
wire UART_HRESP;
wire state;
wire [7:0] UART_RX_data;
wire [7:0] UART_TX_data;
wire tx_en;

AHBlite_UART UART_Interface(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HSEL(UART_HSEL),
        .HADDR(HADDR),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(UART_HRDATA),
        .HREADY(HREADYOUT),
        .HREADYOUT(UART_HREADYOUT),
        .HRESP(UART_HRESP),
        .UART_RX(UART_RX_data),
        .state(state),
        .tx_en(tx_en),
        .UART_TX(UART_TX_data)
);

//------------------------------------------------------------------------------
// AHB DMAC
//------------------------------------------------------------------------------

wire [31:0] DMAC_HRDATA;
wire DMAC_HREADYOUT;
wire DMAC_HRESP;

AHBlite_DMAC DMAC_Interface(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HSEL(DMAC_HSEL),
        .HADDR(HADDR),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(DMAC_HRDATA),
        .HREADY(HREADYOUT),
        .HREADYOUT(DMAC_HREADYOUT),
        .HRESP(DMAC_HRESP),
        .HMASTERC(HMASTERC),
        .DMAdone(DMAdone),
        .DMAsrc(DMAsrc),
        .DMAdst(DMAdst),
        .DMAsize(DMAsize),
        .DMAlen(DMAlen),
        .SLEEPing(SLEEPing),
        .DMAstart(DMAstart),
        .HMASTERSEL(HMASTERSEL)
);

//------------------------------------------------------------------------------
// AHB BUS SLAVE MUX
//------------------------------------------------------------------------------

AHBlite_SlaveMUX SlaveMUX(
        .HCLK(clk),
        .HRESETn(cpuresetn),
        .HREADY(HREADYOUT),

        // PORT 0
        .P0_HSEL(RAMCODE_HSEL),
        .P0_HREADYOUT(RAMCODE_HREADYOUT),
        .P0_HRESP(RAMCODE_HRESP),
        .P0_HRDATA(RAMCODE_HRDATA),

        // PORT 1
        .P1_HSEL(RAMDATA_HSEL),
        .P1_HREADYOUT(RAMDATA_HREADYOUT),
        .P1_HRESP(RAMDATA_HRESP),
        .P1_HRDATA(RAMDATA_HRDATA),
 
        // PORT 2
        .P2_HSEL(WaterLight_HSEL),
        .P2_HREADYOUT(WaterLight_HREADYOUT),
        .P2_HRESP(WaterLight_HRESP),
        .P2_HRDATA(WaterLight_HRDATA),

        // PORT 3
        .P3_HSEL(UART_HSEL),
        .P3_HREADYOUT(UART_HREADYOUT),
        .P3_HRESP(UART_HRESP),
        .P3_HRDATA(UART_HRDATA),

        //OUTPUT
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP),
        .HRDATA(HRDATA)
);

//------------------------------------------------------------------------------
// RAM
//------------------------------------------------------------------------------

Distributed_RAM RAM_CODE(
        .clk(clk),
        .a(RAMCODE_ADDR),
        .d(RAMCODE_WDATA),
        .spo(RAMCODE_RDATA),
        .we(RAMCODE_WRITE)
);

Block_RAM RAM_DATA(
        .clka(clk),
        .addra(RAMDATA_ADDR),
        .dina(RAMDATA_WDATA),
        .wea(RAMDATA_WRITE),
        .douta(RAMDATA_RDATA)
);

//------------------------------------------------------------------------------
// WaterLight
//------------------------------------------------------------------------------

WaterLight WaterLight(
        .WaterLight_mode(WaterLight_mode),
        .WaterLight_speed(WaterLight_speed),
        .clk(clk),
        .RSTn(cpuresetn),
        .LED(LED),
        .LEDclk(LEDclk)
);

//------------------------------------------------------------------------------
// UART
//------------------------------------------------------------------------------

wire clk_uart;
wire bps_en;
wire bps_en_rx,bps_en_tx;

assign bps_en = bps_en_rx | bps_en_tx;

clkuart_pwm clkuart_pwm(
        .clk(clk),
        .RSTn(cpuresetn),
        .clk_uart(clk_uart),
        .bps_en(bps_en)
);

UART_RX UART_RX(
        .clk(clk),
        .clk_uart(clk_uart),
        .RSTn(cpuresetn),
        .TXD(TXD),
        .data(UART_RX_data),
        .interrupt(interrupt_UART),
        .bps_en(bps_en_rx)
);

UART_TX UART_TX(
        .clk(clk),
        .clk_uart(clk_uart),
        .RSTn(cpuresetn),
        .data(UART_TX_data),
        .tx_en(tx_en),
        .RXD(RXD),
        .state(state),
        .bps_en(bps_en_tx)
);

endmodule
