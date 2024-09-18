onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK -color {Slate Blue} -label MADI_CLK /aes10_data_mapper_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group CONSTANTS -color {Lime Green} -label AUDIO_DATA /aes10_data_mapper_vhd_tst/i1/FIFO_DATA
add wave -noupdate -expand -group CONSTANTS -color {Lime Green} -label {ACTIVE CHANNELS} /aes10_data_mapper_vhd_tst/i1/MADI_ACTIVE_CH
add wave -noupdate -expand -group MADI -color Orange -label MADI_DATA_OUT -radix binary /aes10_data_mapper_vhd_tst/i1/MADI_FRAME_OUT
add wave -noupdate -expand -group MADI -color Orange -label MADI_SUBFRAME_START /aes10_data_mapper_vhd_tst/i1/MADI_SUBFRAME_Start
add wave -noupdate -expand -group MADI -color Orange -label MADI_BLOCK_START /aes10_data_mapper_vhd_tst/i1/MADI_BLock_Start
add wave -noupdate -expand -group Counter -color Orchid -label MADI_CHANNEL_CTN -radix decimal /aes10_data_mapper_vhd_tst/i1/MADI_Chanel_CTN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {451904 ps} 0}
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
WaveRestoreZoom {439424 ps} {473802 ps}
