onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK -color {Dark Orchid} -label {MADI CLK} /aes10_data_encoder_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group CLK -color {Dark Orchid} -label WORD_CLK /aes10_data_encoder_vhd_tst/Word_CLK
add wave -noupdate -divider <NULL>
add wave -noupdate -expand -group FSM -label FSM /aes10_data_encoder_vhd_tst/i1/State
add wave -noupdate -divider <NULL>
add wave -noupdate -expand -group CONSTANTS -label {SYNC Symbol} -radix binary /aes10_data_encoder_vhd_tst/i1/Sync_Symbol
add wave -noupdate -divider <NULL>
add wave -noupdate -expand -group MADI -color Orange -label {MADI Data} -radix binary /aes10_data_encoder_vhd_tst/i1/MADI_DATA
add wave -noupdate -expand -group MADI -color Orange -label MADI_DATA_5BIT -radix binary /aes10_data_encoder_vhd_tst/i1/MADI_DATA_5bit
add wave -noupdate -expand -group MADI -color Orange -label {MADI OUT} /aes10_data_encoder_vhd_tst/i1/MADI_OUT
add wave -noupdate -expand -group Counter -color Khaki -label CTN /aes10_data_encoder_vhd_tst/i1/CTN
add wave -noupdate -expand -group Counter -color Khaki -label WORD_CTN -radix decimal /aes10_data_encoder_vhd_tst/i1/Word_CTN
add wave -noupdate -expand -group Counter -color Khaki -label CTN_SYNC /aes10_data_encoder_vhd_tst/i1/CTN_SYNC
add wave -noupdate -expand -group FIFO -color {Pale Green} -label FIFO_READ_ENA /aes10_data_encoder_vhd_tst/i1/FIFO_READ_ENA
add wave -noupdate -label NEW_5BIT_DATA /aes10_data_encoder_vhd_tst/i1/NEW_5bit_DATA
add wave -noupdate -label DELAYFF0 /aes10_data_encoder_vhd_tst/i1/DelayFF0
add wave -noupdate -label DELAYFF1 /aes10_data_encoder_vhd_tst/i1/DelayFF1
add wave -noupdate -label DELAYFF2 /aes10_data_encoder_vhd_tst/i1/DelayFF2
add wave -noupdate -label WORD_CLK_EDGE /aes10_data_encoder_vhd_tst/i1/Word_CLK_EDGE
add wave -noupdate -label Start_NewFrame /aes10_data_encoder_vhd_tst/i1/Start_Newframe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10400000 ps} 0} {{Cursor 2} {39957168 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 491
configure wave -valuecolwidth 63
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
WaveRestoreZoom {50457446 ps} {55712766 ps}
