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
derive_pll_clocks
set MADI_CLK	{MADI_PLL|altpll_component|auto_generated|pll1|clk[0]}
set Word_CLK	{MADI_PLL|altpll_component|auto_generated|pll1|clk[1]}


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

set_input_delay -clock CLK -max 0ns [get_ports {BTN* GPIO* Slider* ARDUINO_IO*}] 
set_input_delay -clock CLK -min 0.000ns [get_ports {BTN* GPIO* Slider* ARDUINO_IO*}] 



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay	-clock	CLK	-max 0ns [get_ports {LED* GPIO* HEX0* HEX1* HEX2* HEX3* HEX4* HEX5* ARDUINO_IO*}]
set_output_delay	-clock	CLK	-min -0ns [get_ports {LED* GPIO* HEX0* HEX1* HEX2* HEX3* HEX4* HEX5* ARDUINO_IO*}]

set_output_delay	-clock	$MADI_CLK	-max 0ns [get_ports {MADI_OUT}]
set_output_delay	-clock	$MADI_CLK	-min -0ns [get_ports {MADI_OUT}]

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



