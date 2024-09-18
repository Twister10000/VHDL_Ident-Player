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
-- Generated on "09/18/2024 10:37:12"
                                                            
-- Vhdl Test Bench template for design  :  Ident_Player_TOP
-- 
-- Simulation tool : Questa Intel FPGA (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Ident_Player_TOP_vhd_tst IS
END Ident_Player_TOP_vhd_tst;
ARCHITECTURE Ident_Player_TOP_arch OF Ident_Player_TOP_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ADC_CLK_10 : STD_LOGIC;
SIGNAL ARDUINO_IO : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ARDUINO_RESET_N : STD_LOGIC;
SIGNAL BTN : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL CLK : STD_LOGIC;
SIGNAL DRAM_ADDR : STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL DRAM_BA : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL DRAM_CAS_N : STD_LOGIC;
SIGNAL DRAM_CKE : STD_LOGIC;
SIGNAL DRAM_CLK : STD_LOGIC;
SIGNAL DRAM_CS_N : STD_LOGIC;
SIGNAL DRAM_DQ : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DRAM_LDQM : STD_LOGIC;
SIGNAL DRAM_RAS_N : STD_LOGIC;
SIGNAL DRAM_UDQM : STD_LOGIC;
SIGNAL DRAM_WE_N : STD_LOGIC;
SIGNAL GPIO : STD_LOGIC_VECTOR(32 DOWNTO 0);
SIGNAL HEX0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HEX1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HEX2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HEX3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HEX4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HEX5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL LED : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL MADI_CLK : STD_LOGIC;
SIGNAL MADI_IN : STD_LOGIC;
SIGNAL MADI_OUT : STD_LOGIC;
SIGNAL MAX10_CLK2_50 : STD_LOGIC;
SIGNAL Slider : STD_LOGIC_VECTOR(9 DOWNTO 0);
COMPONENT Ident_Player_TOP
	PORT (
	ADC_CLK_10 : IN STD_LOGIC;
	ARDUINO_IO : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	ARDUINO_RESET_N : INOUT STD_LOGIC;
	BTN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	CLK : IN STD_LOGIC;
	DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
	DRAM_BA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	DRAM_CAS_N : OUT STD_LOGIC;
	DRAM_CKE : OUT STD_LOGIC;
	DRAM_CLK : OUT STD_LOGIC;
	DRAM_CS_N : OUT STD_LOGIC;
	DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	DRAM_LDQM : OUT STD_LOGIC;
	DRAM_RAS_N : OUT STD_LOGIC;
	DRAM_UDQM : OUT STD_LOGIC;
	DRAM_WE_N : OUT STD_LOGIC;
	GPIO : INOUT STD_LOGIC_VECTOR(32 DOWNTO 0);
	HEX0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HEX1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HEX2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HEX3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HEX4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HEX5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	LED : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	MADI_CLK : IN STD_LOGIC;
	MADI_IN : IN STD_LOGIC;
	MADI_OUT : OUT STD_LOGIC;
	MAX10_CLK2_50 : IN STD_LOGIC;
	Slider : IN STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : Ident_Player_TOP
	PORT MAP (
-- list connections between master ports and signals
	ADC_CLK_10 => ADC_CLK_10,
	ARDUINO_IO => ARDUINO_IO,
	ARDUINO_RESET_N => ARDUINO_RESET_N,
	BTN => BTN,
	CLK => CLK,
	DRAM_ADDR => DRAM_ADDR,
	DRAM_BA => DRAM_BA,
	DRAM_CAS_N => DRAM_CAS_N,
	DRAM_CKE => DRAM_CKE,
	DRAM_CLK => DRAM_CLK,
	DRAM_CS_N => DRAM_CS_N,
	DRAM_DQ => DRAM_DQ,
	DRAM_LDQM => DRAM_LDQM,
	DRAM_RAS_N => DRAM_RAS_N,
	DRAM_UDQM => DRAM_UDQM,
	DRAM_WE_N => DRAM_WE_N,
	GPIO => GPIO,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5,
	LED => LED,
	MADI_CLK => MADI_CLK,
	MADI_IN => MADI_IN,
	MADI_OUT => MADI_OUT,
	MAX10_CLK2_50 => MAX10_CLK2_50,
	Slider => Slider
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END Ident_Player_TOP_arch;
