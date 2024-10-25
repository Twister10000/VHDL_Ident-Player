#do file for Encoder Testing

if {[file exists rtl_work]} {
vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work
# Hier muss der Pfad zur QuestaSim Installation eingegeben werden: 
set INSTALL_DIR {C:/intelFPGA_lite/23.1std/quartus/eda/sim_lib/mentor}

# Gewisse Libraries müssen hier nochmals compiliert werden (Sie Message Window Questa Sim) 
vlog $INSTALL_DIR/fiftyfivenm_atoms_for_vhdl.v  
vlog $INSTALL_DIR/fiftyfivenm_atoms_ncrypt.v  


# Hier müssen die Dateien des Platform-Designers compiliert werden
vlog ../../ONCHIP_AUDIO_STORAGE/simulation/submodules/altera_onchip_flash.v 
vlog ../../ONCHIP_AUDIO_STORAGE/simulation/submodules/altera_onchip_flash_avmm_data_controller.v  
vlog ../../ONCHIP_AUDIO_STORAGE/simulation/submodules/altera_onchip_flash_util.v 
vlog ../../ONCHIP_AUDIO_STORAGE/simulation/submodules/altera_reset_controller.v 
vlog ../../ONCHIP_AUDIO_STORAGE/simulation/submodules/altera_reset_synchronizer.v 


 #Hier folgen die eigenen Design-Dateien my design files 
vcom -reportprogress 300 -work work ../../ONCHIP_AUDIO_STORAGE/simulation/ONCHIP_AUDIO_STORAGE.vhd 
vcom -reportprogress 300 -work work ../../MADI_PLL.vhd
vcom -reportprogress 300 -work work ../../FIFO_MAP_ENC.vhd
vcom -reportprogress 300 -work work ../../FIFO_FLASH_AES10.vhd
vcom -reportprogress 300 -work work ../../AES10_DATA_ENCODER.vhd
vcom -reportprogress 300 -work work ../../AES10_DATA_MAPPER.vhd
vcom -reportprogress 300 -work work ../../Ident_player_TOP.vhd

vcom -reportprogress 300 -work work TB_Ident_player_TOP.vht

quit -sim

vsim -t 1ps -gui -msgmode both -displaymsgmode both -L work -L ONCHIP_AUDIO_STORAGE work.Ident_Player_TOP_vhd_tst -voptargs=+acc=lprn -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work  

do wave_TOP.do
#run -all
run 450ns

