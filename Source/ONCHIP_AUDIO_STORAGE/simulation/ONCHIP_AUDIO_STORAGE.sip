set_global_assignment -entity "ONCHIP_AUDIO_STORAGE" -library "lib_ONCHIP_AUDIO_STORAGE" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ONCHIP_AUDIO_STORAGE" -library "lib_ONCHIP_AUDIO_STORAGE" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "ONCHIP_AUDIO_STORAGE" -library "lib_ONCHIP_AUDIO_STORAGE" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name SPD_FILE [file join $::quartus(sip_path) "../ONCHIP_AUDIO_STORAGE.spd"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "../../ONCHIP_AUDIO_STORAGE.qsys"]

set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "ONCHIP_AUDIO_STORAGE.vhd"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_ONCHIP_AUDIO_STORAGE" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
