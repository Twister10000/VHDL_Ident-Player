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

ENTITY AES10_DATA_MAPPER_vhd_tst IS
END AES10_DATA_MAPPER_vhd_tst;
ARCHITECTURE BEH_AES10_DATA_MAPPER_vhd_tst OF AES10_DATA_MAPPER_vhd_tst IS
-- constants 
constant MADI_clk_period : time := 8 ns; 
constant WORD_clk_period : time := 20.8 us;                                                
                                               
-- signals                                                   
SIGNAL SIMulation						: boolean := true;
SIGNAL MADI_CLK 						: STD_LOGIC;
Signal Word_CLK							:	STD_LOGIC;
SIGNAL MADI_OUT 						: STD_LOGIC;
SIGNAL NEW_AUDIO_DATA_REQ		:	STD_LOGIC := '1';
SIGNAL MADI_FRAME_OUT				:	std_logic_vector(31 downto	0);
SIGNAL FIFO_DATA						:	std_logic_vector(23 downto	0);



BEGIN
	i1 : entity work.AES10_DATA_MAPPER  -- Das zu testende Modul wird hier instanziiert
	GENERIC MAP (
	MADI_MODE				=>	6,
	MADI_ACTIVE_CH	=>	6,
	SIMUlation 			=> SIMUlation)
	PORT MAP (
-- list connections between master ports and signals
	MADI_CLK						=>	MADI_CLK,
	WORD_CLK						=>	WorD_CLK,
	MADI_OUT						=>	MADI_OUT,
	NEW_AUDIO_DATA_RQ		=> NEW_AUDIO_DATA_REQ,
	MADI_FRAME_OUT			=>	MADI_FRAME_OUT,
	FIFO_DATA						=>	FIFO_DATA
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
	wait for MADI_clk_period/2;
	MADI_CLK	<= '1';
	wait for MADI_clk_period/2;
end proCESS Clock;

WORD_CLOCK	: process
begin
	WORD_CLK	<=	'0';
	wait for	WORD_clk_period;
	WORD_CLK	<=	'1';
	wait for 	MADI_clk_period;
end process WORD_CLOCK;
                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list
			assert (false) report "000000 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000000";
			wait until	NEW_AUDIO_DATA_REQ = '1';
			
			assert (false) report "000001 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000001";
			wait until	NEW_AUDIO_DATA_REQ = '1';
			
			assert (false) report "000002 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000002";
			wait until	NEW_AUDIO_DATA_REQ = '1';
			
			assert (false) report "000003 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000003";
			wait until	NEW_AUDIO_DATA_REQ = '1';
			
			assert (false) report "000004 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000004";
			wait until	NEW_AUDIO_DATA_REQ = '1';

			assert (false) report "000005 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000005";
			wait until	NEW_AUDIO_DATA_REQ = '1';

			assert (false) report "000006 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000006";
			wait until	NEW_AUDIO_DATA_REQ = '1';

			assert (false) report "000007 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000007";
			wait until	NEW_AUDIO_DATA_REQ = '1';

			assert (false) report "000008 ist Rengeschrieben" severity note;
			FIFO_DATA	<= x"000008";
			wait until	NEW_AUDIO_DATA_REQ = '1';			
	
		
WAIT;                                                        
END PROCESS always;                                          
END BEH_AES10_DATA_MAPPER_vhd_tst;
