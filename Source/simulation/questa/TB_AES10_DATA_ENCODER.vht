-- Copyright (C) 2024  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "09/13/2024 10:49:53"
                                                            
-- Vhdl Test Bench template for design  :  AES10_DATA_ENCODER
-- 
-- Simulation tool : Questa Intel FPGA (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY AES10_DATA_ENCODER_vhd_tst IS
END AES10_DATA_ENCODER_vhd_tst;
ARCHITECTURE BEH_AES10_DATA_ENCODER_vhd_tst OF AES10_DATA_ENCODER_vhd_tst IS
-- constants 
constant clk_period : time := 8 ns;                                                
-- signals                                                   

SIGNAL MADI_CLK 			: STD_LOGIC;
SIGNAL MADI_OUT 			: STD_LOGIC;

SIGNAL FIFO_READ_ENA	:	STD_LOGIC;
SIGNAL FIFO_empty			:	STD_LOGIC;

SIGNAL MADI_DATA			:	std_logic_vector(3 downto	0);


BEGIN
	i1 : entity work.AES10_DATA_ENCODER
	PORT MAP (
-- list connections between master ports and signals
	MADI_CLK			=>	MADI_CLK,
	MADI_OUT			=>	MADI_OUT,
	FIFO_READ_ENA	=>	FIFO_READ_ENA,
	FIFO_empty		=>	FIFO_empty,
	MADI_DATA			=>	MADI_DATA
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;

Clock : process
begin
	MADI_CLK	<= '0';
	wait for clk_period/2;
	MADI_CLK	<= '1';
	wait for clk_period/2;
end proCESS Clock;
                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
			assert (false) report "0000 ist Rengeschrieben" severity note;
			MADI_DATA	<= "0000";
			wait for 36ns; -- Die Erste Halbwelle wird nicht richtig Simuliert deswegen muss hier 36ns
			assert (false) report "0011 ist Rengeschrieben" severity note;
			MadI_DATA	<= "0011";
			wait for 40ns;
			assert (false) report "0100 ist Rengeschrieben" severity note;
			MadI_DATA	<= "0100";
			wait for 40ns;
			assert (false) report "1101 ist Rengeschrieben" severity note;
			MadI_DATA	<= "1101";
			wait for 40ns;
			assert (false) report "0000 ist Rengeschrieben" severity note;
			MADI_DATA	<= "0000";
			wait for 40ns;
			assert (false) report "0011 ist Rengeschrieben" severity note;
			MadI_DATA	<= "0011";
			wait for 40ns;
			assert (false) report "0100 ist Rengeschrieben" severity note;
			MadI_DATA	<= "0100";
			wait for 40ns;
			assert (false) report "1101 ist Rengeschrieben" severity note;
			MadI_DATA	<= "1101";
			wait for 40ns;
			assert (false) report "Sync Symbol soll ausgegeben werden 10001" severity note;
			wait for 40ns;
			assert (false) report "Sync Symbol soll ausgegeben werden 11000" severity note;
			assert (false) report "0000 ist Rengeschrieben" severity note;
			MadI_DATA	<= "0000";
			wait for 40ns;
		
WAIT;                                                        
END PROCESS always;                                          
END BEH_AES10_DATA_ENCODER_vhd_tst;
