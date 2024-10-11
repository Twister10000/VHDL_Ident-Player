onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK /ident_player_top_vhd_tst/i1/MADI_CLK
add wave -noupdate -expand -group CLK /ident_player_top_vhd_tst/CLK
add wave -noupdate /ident_player_top_vhd_tst/i1/Divider
add wave -noupdate /ident_player_top_vhd_tst/i1/Word_CLK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36000 ps} 0} {{Cursor 2} {50536 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {344866 ps} {455534 ps}
