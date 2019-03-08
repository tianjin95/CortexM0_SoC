module Distributed_RAM #(
    parameter ADDR_WIDTH = 14)(
    input clk,
    input [ADDR_WIDTH-1:0]a,
    input [31:0] d,
    input [3:0] we,
    output reg [31:0] spo
);

reg [31:0] mem [(2**ADDR_WIDTH-1):0];

initial begin
    $readmemh("C:/Users/tianj/Desktop/CortexM0_SoC/keil/code.hex",mem);
end

always@(posedge clk) begin
    if(we[0]) mem[a][7:0] <= d[7:0];
end
always@(posedge clk) begin
    if(we[1]) mem[a][15:8] <= d[15:8];
end
always@(posedge clk) begin
    if(we[2]) mem[a][23:16] <= d[23:16];
end
always@(posedge clk) begin
    if(we[3]) mem[a][31:24] <= d[31:24];
end

always@(*) begin
    spo <= mem[a];
end

endmodule


