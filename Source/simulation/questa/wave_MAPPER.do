onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK -color {Slate Blue} -label MADI_CLK /aes10_data_mapper_vhd_tst/i1/MADI_CLK
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand -group CONSTANTS -color {Lime Green} -label AUDIO_DATA /aes10_data_mapper_vhd_tst/i1/FIFO_DATA
add wave -noupdate -expand -group CONSTANTS -color {Lime Green} -label {ACTIVE CHANNELS} /aes10_data_mapper_vhd_tst/i1/MADI_ACTIVE_CH
add wave -noupdate -expand -group CONSTANTS -divider {New Divider}
add wave -noupdate -color Orange -label MADI_FRAME_READY /aes10_data_mapper_vhd_tst/i1/MADI_FRAME_READY
add wave -noupdate -color Orange -label MADI_FRAME_PARITY /aes10_data_mapper_vhd_tst/i1/MADI_FRAME_PARITY
add wave -noupdate -expand -group MADI -color Orange -label MADI_SUBFRAME_START /aes10_data_mapper_vhd_tst/i1/MADI_SUBFRAME_Start
add wave -noupdate -expand -group MADI -color Orange -label MADI_BLOCK_START /aes10_data_mapper_vhd_tst/i1/MADI_BLock_Start
add wave -noupdate -expand -group MADI -color Orange -label MADI_FRAME /aes10_data_mapper_vhd_tst/i1/MADI_FRAME
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand -group Counter -color Orchid -label MADI_CHANNEL_CTN -radix decimal /aes10_data_mapper_vhd_tst/i1/MADI_Chanel_CTN
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand -group FIFO -label FIFO_FULL /aes10_data_mapper_vhd_tst/i1/FIFO_FULL
add wave -noupdate -expand -group FIFO -label FIFO_Empty /aes10_data_mapper_vhd_tst/i1/FIFO_EMPTY
add wave -noupdate -expand -group FIFO -label FIFO_RD_ENA_SIMU /aes10_data_mapper_vhd_tst/i1/FIFO_READ_ENA_SIMU
add wave -noupdate -expand -group FIFO -label FIFO_WRrq /aes10_data_mapper_vhd_tst/i1/FIFO_wrrq
add wave -noupdate -expand -group FIFO -label FIFO_OUT -radix hexadecimal /aes10_data_mapper_vhd_tst/i1/MADI_DATA
add wave -noupdate -expand -group FIFO -label FIFO_IN /aes10_data_mapper_vhd_tst/i1/MADI_FRAME_FIFO
add wave -noupdate -label FIFO_WORD_USED -radix unsigned -childformat {{/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(5) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(4) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(3) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(2) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(1) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(0) -radix unsigned}} -subitemconfig {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(5) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(4) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(3) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(2) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(1) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(0) {-radix unsigned}} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw
add wave -noupdate -format Analog-Step -height 74 -label FIFO_WORD_USED -max 63.0 -radix unsigned -childformat {{/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(5) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(4) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(3) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(2) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(1) -radix unsigned} {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(0) -radix unsigned}} -subitemconfig {/aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(5) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(4) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(3) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(2) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(1) {-radix unsigned} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw(0) {-radix unsigned}} /aes10_data_mapper_vhd_tst/i1/FIFO_wrusedw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {556000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 304
configure wave -valuecolwidth 132
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
WaveRestoreZoom {389290 ps} {1064971 ps}
