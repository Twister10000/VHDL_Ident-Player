transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib ONCHIP_AUDIO_STORAGE
vmap ONCHIP_AUDIO_STORAGE ONCHIP_AUDIO_STORAGE
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/onchip_audio_storage.v}
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules/altera_onchip_flash.v}
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules/altera_onchip_flash_avmm_data_controller.v}
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules/altera_onchip_flash_util.v}
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules/altera_reset_controller.v}
vlog -vlog01compat -work ONCHIP_AUDIO_STORAGE +incdir+c:/users/mikaj/onedrive\ -\ juventus\ schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules {c:/users/mikaj/onedrive - juventus schulen/dokumente/juventus/diplom/diplomarbeit/vhdl/vhdl_ident-player/source/db/ip/onchip_audio_storage/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work work +incdir+C:/Users/mikaj/OneDrive\ -\ Juventus\ Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/db {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/db/madi_pll_altpll1.v}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/AES10_DATA_ENCODER.vhd}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/FIFO_MAP_ENC.vhd}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/MADI_PLL.vhd}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/FIFO_FLASH_AES10.vhd}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/AES10_DATA_MAPPER.vhd}
vcom -2008 -work work {C:/Users/mikaj/OneDrive - Juventus Schulen/Dokumente/Juventus/Diplom/Diplomarbeit/VHDL/VHDL_Ident-Player/Source/Ident_Player_TOP.vhd}

