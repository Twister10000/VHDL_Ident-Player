onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/MADI_CLK
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/MADI_DATA
add wave -noupdate -color {Medium Slate Blue} /aes10_data_encoder_vhd_tst/i1/MADI_OUT
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/MADI_DATA_5bit
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/CTN
add wave -noupdate /aes10_data_encoder_vhd_tst/i1/CTN_SYNC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11853 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 423
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
WaveRestoreZoom {113697 ps} {141385 ps}
