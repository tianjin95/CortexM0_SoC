module AHBlite_Decoder
#(
    parameter RAMCODE_en = 1,
    parameter WaterLight_en = 1,
    parameter RAMDATA_en = 1,
    parameter UART_en = 1,
    parameter DMAC_en = 1
)(
    input [31:0] HADDR,
    output wire RAMCODE_HSEL,
    output wire WaterLight_HSEL,
    output wire RAMDATA_HSEL,
    output wire UART_HSEL,
    output wire DMAC_HSEL       
);

//RAMCODE-----------------------------------

//0x00000000-0x0000ffff
assign RAMCODE_HSEL = (HADDR[31:16] == 16'h0000) ? RAMCODE_en : 1'b0;



//PERIPHRAL-----------------------------

//0X40000000 WaterLight MODE
//0x40000004 WaterLight SPEED
assign WaterLight_HSEL = (HADDR[31:4] == 28'h4000000) ? WaterLight_en : 1'b0;

//0X40000010 UART RX DATA
//0X40000014 UART TX STATE
//0X40000018 UART TX DATA
assign UART_HSEL = (HADDR[31:4] == 28'h4000001) ? UART_en : 1'b0;

//0X40000020 DMA SRC
//0X40000024 DMA DST
//0X40000028 DMA SIZE
//0X4000002d DMA LEN&START
assign DMAC_HSEL = (HADDR[31:4] == 28'h4000002) ? DMAC_en : 1'b0;

//RAMDATA-----------------------------
//0X20000000-0X2000FFFF
assign RAMDATA_HSEL = (HADDR[31:16] == 16'h2000) ? RAMDATA_en : 1'b0;

endmodule