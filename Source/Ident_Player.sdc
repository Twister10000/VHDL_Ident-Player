#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "10.0 MHz" [get_ports ADC_CLK_10]
create_clock -period "50.0 MHz" [get_ports CLK]
#create_clock -period "125.0 MHz" [get_ports MADI_CLK]
create_clock -period "50.0 MHz" [get_ports MAX10_CLK2_50]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks -create_base_clocks
set MADI_CLK	{MADI_PLL|altpll_component|auto_generated|pll1|clk[0]}
create_generated_clock -name flash_se_neg_reg  -source [get_pins {ON_AUDIO_STORAGE|onchip_audio_data|avmm_data_controller|flash_se_neg_reg|clk}] -divide_by 2 [get_pins {ON_AUDIO_STORAGE|onchip_audio_data|avmm_data_controller|flash_se_neg_reg|q}]


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock CLK -max 0ns [get_ports {BTN* GPIO* Slider* WORD_CLK_EXT SD_DAT* SD_CMD  SD_CD}] 
set_input_delay -clock CLK -min 0.000ns [get_ports {BTN* GPIO* Slider* WORD_CLK_EXT SD_DAT* SD_CMD  SD_CD}] 
set_input_delay -add_delay -clock [get_clocks {MADI_PLL|altpll_component|auto_generated|pll1|clk[0]}] 0.000 [get_ports {MADI_OUT}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay	-clock	CLK	-max 0ns [get_ports {LED* GPIO* HEX0* HEX1* HEX2* HEX3* HEX4* HEX5* SD_DAT* SD_CLK SD_CMD}]
set_output_delay	-clock	CLK	-min -0ns [get_ports {LED* GPIO* HEX0* HEX1* HEX2* HEX3* HEX4* HEX5* SD_DAT* SD_CLK SD_CMD}]
set_output_delay -add_delay  -clock [get_clocks {\PLL:MADI_PLL|altpll_component|auto_generated|pll1|clk[0]}]  0.000 [get_ports {MADI_OUT}]



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



