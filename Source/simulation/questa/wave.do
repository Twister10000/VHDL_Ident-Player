onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MADI -color {Violet Red} /aes10_data_encoder_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group MADI -color {Violet Red} -radix binary /aes10_data_encoder_vhd_tst/i1/MADI_DATA
add wave -noupdate -expand -group MADI -color {Violet Red} -radix binary /aes10_data_encoder_vhd_tst/i1/MADI_DATA_5bit
add wave -noupdate -expand -group Counter -color {Sky Blue} /aes10_data_encoder_vhd_tst/i1/CTN
add wave -noupdate -expand -group Counter -color {Sky Blue} /aes10_data_encoder_vhd_tst/i1/Word_CTN
add wave -noupdate -expand -group Counter /aes10_data_encoder_vhd_tst/i1/CTN_SYNC
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/TEST_rd_Ena
add wave -noupdate -color {Medium Slate Blue} /aes10_data_encoder_vhd_tst/i1/MADI_OUT
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/Send_SYNC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 81
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
WaveRestoreZoom {44884 ps} {123117 ps}
