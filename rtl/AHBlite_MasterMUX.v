module AHBlite_MasterMUX(

    // GLOBLE SIGNAL
    input HCLK,
    input HRESETn,
    input HMASTERSEL,

    // CORE SIDE
    input [31:0] HADDRC, 
    input [1:0] HTRANSC,
    input [2:0] HSIZEC, 
    input [2:0] HBURSTC,
    input [3:0] HPROTC,
    output wire [31:0] HRDATAC,
    input [31:0] HWDATAC, 
    input HWRITEC,
    output wire HREADYC,
    output wire [1:0] HRESPC,  

    // DMA SIDE
    input [31:0]  HADDRD,
    input [1:0]  HTRANSD,
    input [2:0]  HSIZED, 
    input [2:0]  HBURSTD,
    input [3:0]  HPROTD, 
    input [31:0]  HWDATAD,
    input HWRITED,
    output wire [31:0] HRDATAD,
    output wire HREADYD,
    output wire [1:0] HRESPD,

    // OUTPUT SIDE
    input [31:0] HRDATA,
    input HREADY,
    input HRESP, 
    output wire [31:0] HADDR, 
    output wire [31:0] HWDATA,
    output wire [1:0] HTRANS,
    output wire HWRITE,
    output wire [2:0] HSIZE, 
    output wire [2:0] HBURST,
    output wire [3:0] HPROT

);

//------------------------------------------------------------------------------
// CONTROL SIGNAL
//------------------------------------------------------------------------------

assign HADDR = HMASTERSEL ? HADDRC : HADDRD;
assign HTRANS = HMASTERSEL ? HTRANSC : HTRANSD;
assign HWRITE = HMASTERSEL ? HWRITEC : HWRITED;
assign HSIZE = HMASTERSEL ? HSIZEC : HSIZED;
assign HBURST = HMASTERSEL ? HBURSTC : HBURSTD;
assign HPROT = HMASTERSEL ? HPROTC : HPROTD;
assign HWDATA = HMASTERSEL ? HWDATAC : HWDATAD;

//------------------------------------------------------------------------------
// R/W DATA SIGNAL
//------------------------------------------------------------------------------

assign HRDATAC = HRDATA;
assign HRDATAD = HRDATA;

//------------------------------------------------------------------------------
// READY & RESPONSE SIGNAL
//------------------------------------------------------------------------------

assign HREADYC = HREADY;
assign HREADYD = HREADY;

assign HRESPC = HRESP;
assign HRESPD = HRESP;

endmodule