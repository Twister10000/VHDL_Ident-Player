#do file for Encoder Testing

if {[file exists rtl_work]} {
vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work
vcom -reportprogress 300 -work work ../../AES10_DATA_ENCODER.vhd
vcom -reportprogress 300 -work work ../../FIFO_MAP_ENC.vhd
vcom -reportprogress 300 -work work ../../AES10_DATA_MAPPER.vhd
vcom -reportprogress 300 -work work TB_AES10_DATA_MAPPER.vht
quit -sim
vsim -t 1ps -voptargs="+acc" -gui -msgmode both -displaymsgmode both work.AES10_DATA_MAPPER_vhd_tst
do wave_MAPPER.do
run 600ns

