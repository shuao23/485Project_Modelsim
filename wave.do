onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu32_testbench/clk
add wave -noupdate /cpu32_testbench/memory32_test/wrln
add wave -noupdate /cpu32_testbench/memory32_test/rdln
add wave -noupdate /cpu32_testbench/cpu32_test/unitcontrol/state_in
add wave -noupdate /cpu32_testbench/memory32_test/adr
add wave -noupdate /cpu32_testbench/memory32_test/wrdat
add wave -noupdate /cpu32_testbench/memory32_test/rddat
add wave -noupdate /cpu32_testbench/cpu32_test/reg32_a/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/reg32_b/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/reg32_pc/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/reg32_inst/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/reg32_aluout/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/mux_IorD/s
add wave -noupdate /cpu32_testbench/cpu32_test/mux_IorD/i0
add wave -noupdate /cpu32_testbench/cpu32_test/mux_IorD/i1
add wave -noupdate /cpu32_testbench/cpu32_test/mux_IorD/o
add wave -noupdate /cpu32_testbench/cpu32_test/registers/RegArr32(1)/reg_x/stored_data
add wave -noupdate /cpu32_testbench/cpu32_test/registers/RegArr32(1)/reg_x/D
add wave -noupdate /cpu32_testbench/cpu32_test/registers/RegArr32(1)/reg_x/Q
add wave -noupdate /cpu32_testbench/cpu32_test/mux_MemToReg/s
add wave -noupdate /cpu32_testbench/cpu32_test/mux_MemToReg/i0
add wave -noupdate /cpu32_testbench/cpu32_test/mux_MemToReg/i1
add wave -noupdate /cpu32_testbench/cpu32_test/mux_MemToReg/o
add wave -noupdate /cpu32_testbench/cpu32_test/unitcontrol/RegWrite
add wave -noupdate /cpu32_testbench/cpu32_test/registers/rdnum1
add wave -noupdate /cpu32_testbench/cpu32_test/registers/rdnum2
add wave -noupdate /cpu32_testbench/cpu32_test/registers/wrnum
add wave -noupdate /cpu32_testbench/cpu32_test/registers/wrdat
add wave -noupdate /cpu32_testbench/cpu32_test/flipclk_memw/clk
add wave -noupdate /cpu32_testbench/cpu32_test/flipclk_memw/D
add wave -noupdate /cpu32_testbench/cpu32_test/andclk_memw/y
add wave -noupdate /cpu32_testbench/cpu32_test/andclk_memw/o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1585 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 420
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1302 ns} {1959 ns}
