-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;


library work;
use work.de0_nano_const_pkg.all;

-- vhdl_lib
use work.vhdl_lib_pkg.count_bin;
use work.vhdl_lib_pkg.count_int;
use work.vhdl_lib_pkg.debounce;
use work.vhdl_lib_pkg.ff_rs;
use work.vhdl_lib_pkg.one_shot;
use work.vhdl_lib_pkg.prescaler;
use work.vhdl_lib_pkg.pwm_unit;
use work.vhdl_lib_pkg.reset_unit;
use work.vhdl_lib_pkg.rotary;
use work.vhdl_lib_pkg.sweep_unit;
use work.vhdl_lib_pkg.tick_extend;
use work.vhdl_lib_pkg.toggle_unit;

-- sd
use work.sd_const_pkg.all;
use work.sd_pkg.simple_sd;


entity Ident_Player_TOP is
	generic
	(
	
		SIMULATION					: boolean	:= false);


	port
	(
		-- Input ports
			-- CLOCK --
			ADC_CLK_10 			: in 	std_logic;
			CLK 						: in	std_logic;
			MADI_CLK				:	in	std_logic;
			MAX10_CLK2_50 	: in 	std_logic;
			
			
			-- MADI--
			MADI_IN					:	in	std_logic;
			
			-- Buttons --
			BTN 						: in std_logic_vector(1 downto 0);
			
			-- Sliders--
			Slider 					: in std_logic_vector(9 downto 0);
			
			--SD Card--
			SD_CD						:	in	std_logic;
		
		-- Inout ports
			-- ARDUINO Shield Pins
			ARDUINO_IO 			: inout std_logic_vector(8 downto 	0);
			ARDUINO_RESET_N : inout std_logic;
			
			-- SD-Card Pins
			SD_CMD					:	inout	std_logic;
			SD_DAT					:	inout	std_logic_vector(3	downto	0);
			-- 2x20 GPIO Connector--
			GPIO 						: inout std_logic_vector(32 downto 0);
			
			-- SDRAM PINS --
			DRAM_DQ 				: inout std_logic_vector(15 downto 0);

			
		-- Output ports
			-- SDRAM Pins --
			DRAM_CAS_N 			: out std_logic;
			DRAM_CKE 				: out std_logic;
			DRAM_CLK 				: out std_logic;
			DRAM_CS_N 			: out std_logic;
			DRAM_LDQM 			: out std_logic;
			DRAM_RAS_N 			: out std_logic;
			DRAM_UDQM 			: out std_logic;
			DRAM_WE_N 			: out std_logic;
	
			DRAM_ADDR 			: out std_logic_vector(12 downto 0);
			DRAM_BA 				: out std_logic_vector(1 downto 0);
			

			-- 7Segment Pins --
			
			HEX0 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');
			HEX1 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');
			HEX2 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');
			HEX3 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');
			HEX4 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');
			HEX5 						: out std_logic_vector(7 downto 0)	:=	(others	=>	'1');

			-- LEDS Pins --
			LED 						: out std_logic_vector(9 downto 0)	:=	(others	=>	'0');
			
			-- SD-Card Pins --
			SD_CLK					:	out	std_logic;
			
			-- MADI Pins --
			
			MADI_OUT				:	out	std_logic	:=	'0'

	);
end Ident_Player_TOP;

architecture BEH_Ident_Player_TOP of Ident_Player_TOP is
	
	-- Component Declarations
		component ONCHIP_AUDIO_STORAGE is
		port (
			clk_clk                         : in  std_logic                     := 'X';             -- clk
			reset_reset_n                   : in  std_logic                     := '1';             -- reset_n
			onchip_audio_data_address       : in  std_logic_vector(18 downto 0) := (others => 'X'); -- address
			onchip_audio_data_read          : in  std_logic                     := 'X';             -- read
			onchip_audio_data_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			onchip_audio_data_waitrequest   : out std_logic;                                        -- waitrequest
			onchip_audio_data_readdatavalid : out std_logic;                                        -- readdatavalid
			onchip_audio_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => 'X')  -- burstcount
		);
	end component ONCHIP_AUDIO_STORAGE;
	-- FSM Declarations
	
		-- Type Declarations
	
		type Storage_FSM	is (sSetAdr, sReading);
	
		-- Finite-State-Maschine Declarations
		signal	FSM_Storage : Storage_FSM := sSetAdr;
		
		attribute syn_encoding	: string;
		attribute	syn_encoding	of Storage_FSM	:	type is "safe";
	
	-- Signal Declarations FOR AES10_TX 
	signal			FIFO_DATA_SEND_24_Bit	:	std_logic_vector	(23 downto	0) := (others	=> '0');--x"DC5E19"; --x"F0F0F0"; --(others	=> '0'); 
	signal			MADI_DATA							:	std_logic_vector	(31 downto	0);
	signal			MADI_CLK_PLL					: std_logic;
	signal			MADI_Locked						: std_logic;
	signal			Word_CLK							:	std_logic;
	signal			Divider								: integer	range	0	to 4096 := 0;
	signal			FAKE_AUDIO						: integer	range	0	to 17e6 := 0;
	signal			BTN_SYNC							: std_logic_vector	(2 downto	0) := (others	=>	'0');
	signal			RST_SYNC							: std_logic_vector	(2 downto	0) := (others	=>	'0');
	
	
	-- Signal Declarations FOR FIFO_FLASH_AES10
	signal			FIFO_Empty_TOP				:	std_logic :=	'0';
	signal			FIFO_FULL_TOP					:	std_logic	:=	'0';
	signal			FIFO_wrreq_TOP				:	std_logic	:=	'0';
	signal			FIFO_rdreq_TOP				:	std_logic	:=	'0';
	
	signal			FIFO_wrusedw_TOP			:	std_logic_vector	(5 downto	0)		:=	(others	=>	'0');
	signal			FIFO_DATA_INPUT				:	std_logic_vector	(31	downto	0)	:=	(others	=>	'0');
	signal			FIFO_DATA_SEND_32_Bit	:	std_logic_vector	(31 downto	0) 	:= (others	=> '1');
	
	-- Signal Declarations for Flash Memory
	signal			FL_reset									:	std_logic												:=	'1';
	signal			FL_data_read							:	std_logic												:=	'0';
	signal			FL_wait_request						:	std_logic												:=	'0';
	signal			FL_readdata_valid					:	std_logic												:=	'0';
	signal			FL_data_address						:	std_logic_vector(18 downto 	0) 	:= 	(others => 	'0');					
	signal			FL_data_burstcount				:	std_logic_vector(3	downto	0)	:=	(others	=>	'0');
	signal			FL_read_data							:	std_logic_vector(31 downto 	0)	:=	(others	=>	'0');									
	signal			burstcount								:	integer	range	0	to 8 := 0;
	
	
	-- Signal Declarations for SD_CARD Controller
	signal rst 									: std_ulogic;
	-- =================================
	signal sleep								: std_ulogic := '0';
	signal mode, mode_fb				: sd_mode_record;
	signal dat_address					: sd_dat_address_type := (others=>'0');
	signal ctrl_tick, fb_tick		: sd_tick_record;
	signal dat_block						: dat_block_type;
	signal dat_valid, dat_tick	: std_ulogic;
	signal unit_stat						: sd_controller_stat_type;
	-- =================================
	signal byte									: std_ulogic_vector(7 downto 0);
	signal valid								: std_ulogic;

begin
	-- ONCHIP_AUDIO_STORAGE Instantiation
	
	ON_AUDIO_STORAGE : component ONCHIP_AUDIO_STORAGE
		port map (
			clk_clk                         => clk,                   -- clk.clk
			reset_reset_n                   => FL_reset,              -- reset.reset_n
			onchip_audio_data_address       => FL_data_address,       -- onchip_audio_data.address
			onchip_audio_data_read          => FL_Data_read,          -- .read
			onchip_audio_data_readdata      => FL_read_data,      		-- .readdata
			onchip_audio_data_waitrequest   => FL_wait_request,   		-- .waitrequest
			onchip_audio_data_readdatavalid => FL_readdata_valid, 		-- .readdatavalid
			onchip_audio_data_burstcount    => FL_data_burstcount);   -- .burstcount
	
	-- MADI_PLL Instantiation
	PLL								: if SimULATION = false generate
		MADI_PLL					:	entity	work.MADI_PLL
			port map(
					inclk0				=>	CLK,
					c0						=>	MADI_CLK_PLL,
					locked				=>	MADI_Locked
			
			
			);
	end generate PLL;
	
	Simu_PLL: if SimULATION = true generate -- wird bei der Questasim Simulation ausgeführt
			MADI_CLK_PLL <= CLK; 								-- Der Clock input wird direkt mit dem globalen
 end generate Simu_PLL;
 
 
	-- FIFO_FLASH_AES10 Instantiation
	
	FIFO_FLASH_AES10	:	entity work.FIFO_FLASH_AES10
	
		port map(
					
			data				=>	FIFO_DATA_INPUT,						-- FIFO DATA Input
			rdclk				=>	MADI_CLK_PLL,								-- READ_CLK
			rdreq				=>	FIFO_rdreq_TOP,							-- FIFO READ REQUEST
			wrclk				=>	CLK,												-- Write CLK
			wrreq				=>	FIFO_wrreq_TOP,							-- FIFO WRite Request
			q						=>	FIFO_DATA_SEND_32_Bit,			-- 24 BIt ich muss aber auf 32 Bit gehen :/
			rdempty			=>	FIFO_EMPTY_TOP,							-- FIFO EMPTY SIgnal
			wrfull			=>	FIFO_FULL_TOP,							-- FIFO FULL SIgnal
			wrusedw			=>	FIFO_wrusedw_TOP);					-- FIFO wordused SIgnal
	
	
	-- MADI_DATA_MAPPER Instantiation
	--MADI_MAPPER	: if SimULATION	= false generate
	
		MADI_DATA_MAPPER	:	entity work.AES10_DATA_MAPPER
			port map(
			
				MADI_CLK					=>	MADI_CLK_PLL,
				Word_CLK					=>	Word_CLK,
				FIFO_DATA					=>	FIFO_DATA_SEND_32_Bit,
				MADI_FRAME_OUT		=>	MADI_DATA,
				NEW_AUDIO_DATA_RQ	=>	FIFO_rdreq_TOP,
				MADI_OUT					=>	MADI_OUT);
	--end generate MADI_MAPPER;
	
	
	-- SD_CARD-Controller instantiation
	
	u_simple_sd:	simple_sd port map (rst=>rst, clk=>clk, sd_clk=>sd_clk, sd_cmd=>sd_cmd, sd_dat=>sd_dat, sd_cd=>sd_cd,
									sleep=>sleep, mode=>mode, mode_fb=>mode_fb, dat_address=>dat_address, ctrl_tick=>ctrl_tick, fb_tick=>fb_tick,
									dat_block=>dat_block, dat_valid=>dat_valid, dat_tick=>dat_tick, unit_stat=>unit_stat);
	
	-- Process Statement (optional)

	main	:	process	(all)
	
	begin
	
						if rising_edge(MADI_CLK_PLL)	then
							
							Divider 		<= Divider + 1;

							FIFO_DATA_SEND_24_Bit(23	downto	0)	<= FIFO_DATA_SEND_32_Bit(23	downto	0);
							
							if Divider	= 2603 then --2624 @ 126MHZ 2603@125MHZ
								Divider 	<= 0;
							end if;
						
							if Divider 	= 0 then
								Word_CLK 		<= '1';
							else
								Word_CLK		<= '0';
							end if;			
							BTN_SYNC(0) <= BTN(0);
							BTN_SYNC(1) <= BTN_SYNC(0);
							BTN_SYNC(2) <= BTN_SYNC(1);
							
							RST_SYNC(0) <= BTN(1);
							RST_SYNC(1) <= RST_SYNC(0);
							RST_SYNC(2) <= RST_SYNC(1);
							
							-- Reset Signal 
							if RST_SYNC(2)	=	'0'	then
								rst	<=	'1';
							else
								rst	<=	'0';
							end if;
							-- Basic Fnction Test with LED
							if BTN_SYNC(2) = '1' then
								LED(1) <= '1';
							else
								LED(1) <= '0';
							end if;
						
						end if;
	
	end process	main;
	
	ONCHIP_FLASH_CONTROLLER	: process(all)
	
	begin
	
			if rising_edge(CLK)	then
				FIFO_wrreq_TOP			<=	'0';
				case FSM_Storage is
					when sSetAdr	=>	
					
														FL_data_read				<=	'0';
														FL_data_address			<=	FL_data_address; -- Vlt mit einer zwischen Variabel lösen
														FL_data_burstcount	<=	x"8";
														if FIFO_wrusedw_TOP <= x"10" then
															
															FL_data_read			<=	'1';
															FSM_Storage				<=	sReading;
															
														end if;
														
														if FL_data_address	>= x"2F"	then
															FL_data_address	<= (others =>	'0');
														end if;
					when sReading	=>	
														if FL_readdata_valid	=	'1' then
															FL_data_read				<=	'0';
															FIFO_DATA_INPUT			<= FL_read_data;
															FIFO_wrreq_TOP			<=	'1';
															burstcount					<= burstcount +	1;
														end if;
														if	burstcount	>= 7	then
															FL_data_address			<= FL_data_address	+ 8;
															burstcount					<= 0;
															FSM_Storage					<= sSetAdr;
														end if;
					when	others	=> 	FSM_Storage	<=	sSetAdr;
					
				end case;
				
			end if;
	
	end process ONCHIP_FLASH_CONTROLLER;
end BEH_Ident_Player_TOP;
