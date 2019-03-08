// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "12/11/2018 16:27:33"
                                                                                
// Verilog Test Bench template for design : CortexM0_SoC
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ps/ 1 ps
module CortexM0_SoC_vlg_tst();

reg clk;
reg RSTn;
reg TXD;
                        
CortexM0_SoC i1 (
	.clk(clk),
	.RSTn(RSTn)
);

initial begin                                                  
	clk = 0;
	RSTn=0;
	#100
	RSTn=1;

end  
	
always begin                                                  
	#10 clk = ~clk;
end       

endmodule

