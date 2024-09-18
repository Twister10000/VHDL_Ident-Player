onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MADI -label MADI_CLK /aes10_data_mapper_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group MADI -label MADI_DATA_OUT -radix binary /aes10_data_mapper_vhd_tst/i1/MADI_FRAME_OUT
add wave -noupdate -expand -group MADI -label MADI_SUBFRAME_START /aes10_data_mapper_vhd_tst/i1/MADI_SUBFRAME_Start
add wave -noupdate -expand -group MADI -label MADI_BLOCK_START /aes10_data_mapper_vhd_tst/i1/MADI_BLock_Start
add wave -noupdate -expand -group Counter -label MADI_CHANNEL_CTN -radix decimal /aes10_data_mapper_vhd_tst/i1/MADI_Chanel_CTN
add wave -noupdate -label AUDIO_DATA /aes10_data_mapper_vhd_tst/i1/FIFO_DATA
add wave -noupdate -label {ACTIVE CHANNELS} /aes10_data_mapper_vhd_tst/i1/MADI_ACTIVE_CH
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {466064 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
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
WaveRestoreZoom {457478 ps} {491856 ps}
