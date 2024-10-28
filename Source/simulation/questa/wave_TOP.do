onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CLK /ident_player_top_vhd_tst/i1/CLK
add wave -noupdate -expand -group FLASH -color Yellow -label FSM_STORAGE /ident_player_top_vhd_tst/i1/FSM_Storage
add wave -noupdate -expand -group FLASH -color Magenta -label FL_RESET /ident_player_top_vhd_tst/i1/FL_reset
add wave -noupdate -expand -group FLASH -color Magenta -label FL_DATA_READ /ident_player_top_vhd_tst/i1/FL_data_read
add wave -noupdate -expand -group FLASH -color Magenta -label FL_WAIT_REQUEST /ident_player_top_vhd_tst/i1/FL_wait_request
add wave -noupdate -expand -group FLASH -color Magenta -label FL_READDATA_VALID /ident_player_top_vhd_tst/i1/FL_readdata_valid
add wave -noupdate -expand -group FLASH -color Magenta -label FL_DATA_ADDRESS /ident_player_top_vhd_tst/i1/FL_data_address
add wave -noupdate -expand -group FLASH -color Magenta -label FL_DATA_BURSTCOUNT /ident_player_top_vhd_tst/i1/FL_data_burstcount
add wave -noupdate -expand -group FLASH /ident_player_top_vhd_tst/i1/FL_read_data
add wave -noupdate -expand -group FLASH /ident_player_top_vhd_tst/i1/burstcount
add wave -noupdate -expand -group FIFO -expand -group WRITE -label FIFO_DATA_IN /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/data
add wave -noupdate -expand -group FIFO -expand -group WRITE -label FIFO_WR_CLK /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/wrclk
add wave -noupdate -expand -group FIFO -expand -group WRITE -label FIFO_WR_REQ /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/wrreq
add wave -noupdate -expand -group FIFO -expand -group WRITE -label FIFO_WR_FULL /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/wrfull
add wave -noupdate -expand -group FIFO -label FIFO_WORDS_USED /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/wrusedw
add wave -noupdate -expand -group FIFO -group READ -label FIFO_READ_CLK /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/rdclk
add wave -noupdate -expand -group FIFO -group READ -label FIFO_READ_REQ /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/rdreq
add wave -noupdate -expand -group FIFO -group READ -label FIFO_READ_EMPTY /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/rdempty
add wave -noupdate -expand -group FIFO -group READ -label FIFO_DATA_OUT /ident_player_top_vhd_tst/i1/FIFO_FLASH_AES10/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {340573 ps} 0} {{Cursor 2} {444000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 350
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
WaveRestoreZoom {331983 ps} {352372 ps}
