# CortexM0_SoC

  Strongly thank arm for the designstar project.
  With it, I have the opportunity to learn to build a SoC.

file arrange:

    /CortexM0_SoC/rtl   
        all the verilog file without the CM0 core
    /CortexM0_SoC/keil  
        keil project file,u can open the project in keil directly
    /CortexM0_SoC/modelsim 
        modelsim simulation project file,u can open the project in modelsim directly
    /CortexM0_SoC/xilinx
        vivado project file,u can open the project in vivado directly

  U should download the M0 designstart eval pack at https://www.arm.com/resources/designstart/designstart-eval and move the "cortexm0ds_logic.v" to /CortexM0_SoC/rtl/ 

  If u want to simulate, open the /CortexM0_SoC/rtl/Distributed_RAM.v and edit the absolute path at "readmemh".

  U can open the picture "architecture" to learn about the current SoC architecture.

  DMA needs to be used with the WFE command, when the dmac is configured, the DMA will automatically start running, so you should use the WFE command to ensure the bus is contrulled by DMA.

