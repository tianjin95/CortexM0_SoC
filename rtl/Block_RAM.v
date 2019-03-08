module Block_RAM #(
    parameter ADDR_WIDTH = 14)(
    input clka,
    input [ADDR_WIDTH-1:0] addra,
    input [31:0] dina,
    input [3:0] wea,
    output reg [31:0] douta
);

reg [7:0] mem0 [(2**ADDR_WIDTH-1):0];
reg [7:0] mem1 [(2**ADDR_WIDTH-1):0];
reg [7:0] mem2 [(2**ADDR_WIDTH-1):0];
reg [7:0] mem3 [(2**ADDR_WIDTH-1):0];

always@(posedge clka) begin
    if(~wea[0]) douta[7:0] <= mem0[addra];
end

always@(posedge clka) begin
    if(wea[0]) mem0[addra] <= dina[7:0];
end 

always@(posedge clka) begin
    if(wea[1]) mem1[addra] <= dina[15:8];
end 

always@(posedge clka) begin
    if(~wea[1]) douta[15:8] <= mem1[addra];
end

always@(posedge clka) begin
    if(wea[2]) mem2[addra] <= dina[23:16];
end 

always@(posedge clka) begin
    if(~wea[2]) douta[23:16] <= mem2[addra];
end

always@(posedge clka) begin
    if(wea[3]) mem3[addra] <= dina[31:24];
end 

always@(posedge clka) begin
    if(~wea[3]) douta[31:24] <= mem3[addra];
end

endmodule