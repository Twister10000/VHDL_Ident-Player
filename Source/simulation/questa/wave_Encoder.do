onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK -label {MADI CLK} /aes10_data_encoder_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group CONSTANTS -label {SYNC Symbol} /aes10_data_encoder_vhd_tst/i1/Sync_Symbol
add wave -noupdate -expand -group MADI -label {MADI Data} /aes10_data_encoder_vhd_tst/i1/MADI_DATA
add wave -noupdate -expand -group MADI -label {MADI OUT} /aes10_data_encoder_vhd_tst/i1/MADI_OUT
add wave -noupdate -expand -group MADI -label MADI_DATA_5BIT /aes10_data_encoder_vhd_tst/i1/MADI_DATA_5bit
add wave -noupdate -expand -group Counter -label CTN /aes10_data_encoder_vhd_tst/i1/CTN
add wave -noupdate -expand -group Counter -label WORD_CTN /aes10_data_encoder_vhd_tst/i1/Word_CTN
add wave -noupdate -expand -group Counter -label CTN_SYNC /aes10_data_encoder_vhd_tst/i1/CTN_SYNC
add wave -noupdate -expand -group FIFO -label FIFO_READ_ENA /aes10_data_encoder_vhd_tst/i1/FIFO_READ_ENA
add wave -noupdate -label SEND_SYNC /aes10_data_encoder_vhd_tst/i1/Send_SYNC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {563395 ps} 0}
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
WaveRestoreZoom {535728 ps} {591062 ps}
