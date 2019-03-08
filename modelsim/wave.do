onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HCLK
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HRESETn
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HMASTERSEL
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HADDRC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HTRANSC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HSIZEC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWRITEC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HRDATAC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWDATAC
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HADDRD
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HTRANSD
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HSIZED
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWRITED
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HRDATAD
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWDATAD
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HADDR
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HTRANS
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HSIZE
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWRITE
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HRDATA
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/MasterMUX/HWDATA
add wave -noupdate -radix hexadecimal /CortexM0_SoC_vlg_tst/i1/DMAC_Interface/DMAdone
add wave -noupdate -radix unsigned /CortexM0_SoC_vlg_tst/i1/MicroDMA/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35065 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 342
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {34827 ps} {35337 ps}
