-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
-- CYBERCHEF HEX OUTPUT (SINE FROM BINARY)
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
		SD_CARD_MAX_ADR			:	integer	range	0	to	1e6		:= 114751;-- Die Daten werden vom SKript ausgegeben
		SD_LAST_BLOCK_SIZE	:	integer	range	0	to	1e6		:= 0;		-- Die Daten werden vom SKript ausgegeben
		SD_BLOCK_READ				:	integer	range	0	to	1e3		:=	56;		
		FIFO_READ_THRESHOLD	:	integer	range	0	to	64e3	:=	23000;--Das FIFO ist 32000 Wörter breit
		USE_INTERNAL_FLASH	:	boolean	:=	false;		-- True = Internal memory false = SD_Card
		SIMULATION					: boolean	:= false);


	port
	(
		-- Input ports
			-- CLOCK --
			ADC_CLK_10 			: in 	std_logic;
			CLK 						: in	std_logic;
			MADI_CLK				:	in	std_logic;
			MAX10_CLK2_50 	: in 	std_logic;
			WORD_CLK_EXT		:	in	std_logic;
			
			
			-- MADI--
			MADI_IN					:	in	std_logic;
			
			-- Buttons --
			BTN 						: in std_logic_vector(1 downto 0);
			
			-- Sliders--
			Slider 					: in std_logic_vector(9 downto 0);
			
			--SD Card--
			SD_CD						:	in	std_logic;
		
		-- Inout ports
			
			-- SD-Card Pins
			SD_CMD					:	inout	std_logic;
			SD_DAT					:	inout	std_logic_vector(3	downto	0) 	:= 	(others => '1');
			-- 2x20 GPIO Connector--
			GPIO 						: inout std_logic_vector(32 downto 0)		:=	(others=>'0');
			
			-- SDRAM PINS --
			DRAM_DQ 				: inout std_logic_vector(15 downto 0)		:=	(others=>'0');

			
		-- Output ports
			-- SDRAM Pins --
			DRAM_CAS_N 			: out std_logic	:=	'0';
			DRAM_CKE 				: out std_logic	:=	'0';
			DRAM_CLK 				: out std_logic	:=	'0';
			DRAM_CS_N 			: out std_logic	:=	'0';
			DRAM_LDQM 			: out std_logic	:=	'0';
			DRAM_RAS_N 			: out std_logic	:=	'0';
			DRAM_UDQM 			: out std_logic	:=	'0';
			DRAM_WE_N 			: out std_logic	:=	'0';
	
			DRAM_ADDR 			: out std_logic_vector(12 downto 0)		:=	(others=>'0');
			DRAM_BA 				: out std_logic_vector(1 downto 0)		:=	(others=>'0');
			

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
			SD_CLK					:	out	std_logic	:=	'0';
			
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
		-- Type for internal Flash
		type Storage_FSM	is (sSetAdr, sReading);
		
		-- Type for SD Card
		type	SDCARD_FSM	is	(init, sFIFO_wr_0Bytes, sFIFO_wr_1Bytes, sFIFO_wr_2Bytes, SD_Start_Reading, SD_Reading, idle); 
	
		-- Finite-State-Maschine Declarations
		-- FSM Declarations Internal Flash
		signal	FSM_Storage : Storage_FSM := sSetAdr;
		
		attribute syn_encoding	: string;
		attribute	syn_encoding	of Storage_FSM	:	type is "safe";
		
		-- FSM Declarations SD_CARD
		signal	FSM_SDCARD	:	SDCARD_FSM	:=	init;
		
		attribute syn_encoding_SD	: string;
		attribute	syn_encoding_SD	of SDCARD_FSM	:	type is "safe";
	
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
	signal			WORD_CLK_SYNC					:	std_logic_vector	(2	downto	0)	:=	(others=>'0');
	signal			SLIDER_SYNC						:	std_logic_vector	(2	downto	0)	:=	(others=>'0');
	
	
	-- Signal Declarations FOR FIFO_FLASH_AES10
	signal			FIFO_Empty_TOP				:	std_logic :=	'0';
	signal			FIFO_FULL_TOP					:	std_logic	:=	'0';
	signal			FIFO_wrreq_TOP				:	std_logic	:=	'0';
	signal			FIFO_rdreq_TOP				:	std_logic	:=	'0';
	
	signal			FIFO_wrusedw_TOP			:	std_logic_vector	(14 downto	0)		:=	(others	=>	'0');
	signal			FIFO_DATA_INPUT				:	std_logic_vector	(31	downto	0)	:=	(others	=>	'0');
	signal			FIFO_DATA_SEND_32_Bit	:	std_logic_vector	(31 downto	0) 	:=	(others	=>	'1');
	
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
	signal mode, mode_fb				: sd_mode_record 			/*:=	(others	=>	'1')*/;
	signal dat_address					: sd_dat_address_type := (others=>'0');
	signal ctrl_tick, fb_tick		: sd_tick_record;
	signal dat_block						: dat_block_type;
	signal dat_valid, dat_tick	: std_ulogic;
	signal unit_stat						: sd_controller_stat_type;
	signal SD_data_adress				:	integer range 0 to 	200e3 			:= 	0;
	signal current_read_adr			:	integer	range	0	to 	1e6					:=	0;				
	signal CTN_dat_block				:	integer	range	0	to	blocklen		:=	0;
	signal CTN_init_delay				:	integer	range	0	to	CLK_FREQ		:=	0;
	-- =================================
	signal byte									: std_ulogic_vector(7 downto 0);
	signal byte1_Buffer					: std_logic_vector(7 downto 0);
	signal byte2_Buffer					: std_logic_vector(7 downto 0);
	signal valid								: std_ulogic;
	
	
	-- ============== Testsignals ===================
	signal	Test_SD_DATA_1				:	std_logic_vector(7	downto	0) := (others=>	'0');
	signal	Test_SD_DATA_2				:	std_logic_vector(7	downto	0) := (others=>	'0');
	signal	Test_SD_DATA_3				:	std_logic_vector(7	downto	0) := (others=>	'0');
	signal	CTN_BYTE_PUFFER				:	integer	range	0	to	15	:=	0;
	signal	CTN_SD_BLOCKS					:	integer	range	0	to	100	:=	0;
	signal	MAPPER_ENA						:	std_logic := '0';

begin
	-- ONCHIP_AUDIO_STORAGE Instantiation
	INT_FLASH	:	if USE_INTERNAL_FLASH	=	true	generate
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
	end generate INT_FLASH;
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
				MAPPER_ENA				=>	MAPPER_ENA,
				FIFO_DATA					=>	FIFO_DATA_SEND_32_Bit,
				MADI_FRAME_OUT		=>	MADI_DATA,
				NEW_AUDIO_DATA_RQ	=>	FIFO_rdreq_TOP,
				MADI_OUT					=>	MADI_OUT);
	--end generate MADI_MAPPER;
	
	
	SD_CARD	:	if USE_INTERNAL_FLASH	=	false	generate	--=====================================================
		power_on_reset:				reset_unit generic map (n=>CLK_FREQ/10) port map (o_rst=>rst, i_rst=>RST_SYNC(2), clk=>clk);
		
		-- SD_CARD-Controller instantiation
		
		u_simple_sd:	simple_sd port map (rst=>rst, clk=>clk, sd_clk=>sd_clk, sd_cmd=>sd_cmd, sd_dat=>sd_dat, sd_cd=>sd_cd,
										sleep=>sleep, mode=>mode, mode_fb=>mode_fb, dat_address=>dat_address, ctrl_tick=>ctrl_tick, fb_tick=>fb_tick,
										dat_block=>dat_block, dat_valid=>dat_valid, dat_tick=>dat_tick, unit_stat=>unit_stat);
										
										
		-- SD_CARD ADDRESS COUNTER instantiation
			add_count:		count_int generic map (max=>SD_CARD_MAX_ADR) port map (rst=>rst, clk=>clk, up=>dat_tick, cnt=>sd_data_adress);
	end generate	SD_CARD;
	
	-- Process Statement (optional)

	main	:	process	(all)
	
	begin
	
						if rising_edge(MADI_CLK_PLL)	then
							
							Divider 		<= Divider + 1;
							HEX0										<=	(others	=>	'1');
							FIFO_DATA_SEND_24_Bit(23	downto	0)	<= FIFO_DATA_SEND_32_Bit(23	downto	0);
							
							if Divider	= 2603 then --2624 @ 126MHZ 2603@125MHZ
								Divider 	<= 0;
							end if;
							
							WORD_CLK_SYNC(0) 	<=	WORD_CLK_EXT;
							WORD_CLK_SYNC(1)	<=	WORD_CLK_SYNC(0);
							WORD_CLK_SYNC(2)	<=	WORD_CLK_SYNC(1);
							SLIDER_SYNC(0)		<=	SLIDER(0);
							SLIDER_SYNC(1)		<=	SLIDER_SYNC(0);
							SLIDER_SYNC(2)		<=	SLIDER_SYNC(1);
							
							if SLIDER_SYNC(2)	=	'1' and WORD_CLK_SYNC(2) = '0'	and WORD_CLK_SYNC(1)	=	'1' then
								MAPPER_ENA	<=	'1';
							end if;
							
							if SLIDER_SYNC(2)	=	'0'	then
								MAPPER_ENA	<=	'0';
							end if;
							
							if WORD_CLK_SYNC(2) =	'0' and WORD_CLK_SYNC(1)	=	'1' then
								Word_CLK		<=	'1';
								HEX0	<=	x"F9";			
							else
								WORD_CLK		<=	'0';
								HEX0	<=	x"F9";
							end if;
							
							BTN_SYNC(0) <= BTN(0);
							BTN_SYNC(1) <= BTN_SYNC(0);
							BTN_SYNC(2) <= BTN_SYNC(1);
														
						end if;
	
	end process	main;
	
	ONCHIP_FLASH_CONTROLLER : if USE_INTERNAL_FLASH	=	true generate
		FLASh_CONTROLLER		: process(all)
	
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
	
		end process FLASH_CONTROLLER;
	end generate	ONCHIP_FLASH_CONTROLLER;
	
	SD_CARD_PROCESS			:	if USE_INTERNAL_FLASH = false	generate
		SD_CARD_Controller	:	process(all) 
		
			begin
		
					if rising_edge(CLK)	then
						
						mode.fast			<=	'1'; -- 1 = 4-Bit, 0 = 1-Bit
						mode.wide_bus	<=	'1';	
											
						--Set default Values
						ctrl_tick.reinit				<=	'0';
						ctrl_tick.read_single		<=	'0';
						FIFO_wrreq_TOP					<=	'0';
						LED(9 downto 0) 				<= "0000000000";
						
						-- Generate reset Signal for SD-Card Library
						RST_SYNC(0) <= BTN(1);
						RST_SYNC(1) <= RST_SYNC(0);
						RST_SYNC(2) <= RST_SYNC(1);
						
						-- Integer to Vector converter
						dat_address	<= sd_dat_address_type(to_unsigned(sd_data_adress,32)); 
						
						-- Card Detect Debugging
						if sd_cd = '1' then
							LED(4)	<=	'1';
						else
							LED(4)	<=	'0';
						end if;

						if FIFO_FULL_TOP	=	'1' then
							LED(0)	<=	'1';
						elsif	FIFO_EMPTY_TOP	=	'1'	then
							--LED(8)	<=	'1';
						end if;
						
						-- LED Display for Status Info 
						case unit_stat is
						
							when s_ready		=>	LED(5)	<=	'1';
							
							when s_init			=>	LED(6)	<= 	'1';
							
							when s_read			=>	LED(7)	<=	'1';
							
							when s_error		=>	LED(8)	<=	'1';
							
							when s_no_card	=>	LED(9)	<=	'1';
							
							when others		=>	null;
						end case;
						
						-- Automatic reset if error
						if unit_stat	=	s_error	then
							FSM_SDCARD	<=	init;
						end if;
							
						case FSM_SDCARD is
							when idle 						=>	LED(1)	<=	'1';
																				if unit_stat	= s_ready then 
																					if FIFO_wrusedw_TOP <= std_logic_vector(to_Unsigned(FIFO_READ_THRESHOLD,15)) then
																						FSM_SDCARD	<= SD_Start_Reading;
																					else
																						FSM_SDCARD	<= idle;
																					end if;
																				else
																					CTN_init_delay	<=	CTN_init_delay	+	1;
																					if	CTN_init_delay	=	0 then
																						FSM_SDCARD	<= init;
																					elsif	CTN_init_delay	>= CLK_FREQ - 1 then
																						CTN_init_delay	<=	0;
																					end if;
																				end if;
							
							when init								=>	LED(2)	<=	'1';
																					if unit_stat	=	s_ready then
																						FSM_SDCARD	<= idle;	
																					else
																						if	fb_tick.reinit	=	'1' then
																							FSM_SDCARD	<=	idle;
																						else
																							ctrl_tick.reinit	<=	'1';
																						end if;
																					end if;
							
							when	SD_Start_Reading	=>	LED(3)	<=	'1';
																					if unit_stat = s_ready or unit_stat	= s_read	then
																						
																						ctrl_tick.read_multiple		<=	'1';
																							if fb_tick.read_multiple =	'1' then
																								FSM_SDCARD	<=	SD_Reading;
																								ctrl_tick.read_multiple	<=	'0';
																							end if;
																					else
																					
																					end if;
							
							when	SD_Reading				=>	LED(4)	<=	'1';

																						if unit_stat	= s_ready or unit_stat	=	s_read then
																							if CTN_SD_BLOCKS	>=	SD_BLOCK_READ	then
																								
																								if fb_tick.stop_transfer	=	'1'	then
																									CTN_SD_BLOCKS	<=	0;
																									ctrl_tick.stop_transfer	<=	'0';
																									FSM_SDCARD		<=	idle;
																								else
																									ctrl_tick.stop_transfer	<=	'1';
																								end if;
																								
																							elsif	FIFO_wrusedw_TOP >= std_logic_vector(to_Unsigned(FIFO_READ_THRESHOLD,15)) then
																								
																								sleep <=	'1';
																								LED(2)	<=	'1';
																							else
																								sleep	<=	'0';
																								if dat_tick = '1' and dat_valid	= '1' then
																									CTN_SD_BLOCKS	<=	CTN_SD_BLOCKS	+	1;
																									case	CTN_BYTE_PUFFER	is
																										
																										when 0	=>
																															FSM_SDCARD	<=	sFIFO_wr_0Bytes;
																										
																										when 1	=>
																															FSM_SDCARD	<=	sFIFO_wr_1Bytes;
																										
																										when 2	=>
																															FSM_SDCARD	<=	sFIFO_wr_2Bytes;
																										
																									when	others	=>	null;
																									end case;
																									
																									current_read_adr	<=	current_read_adr + 1;																						
																								end if;
																							end if;
																						else
																							FSM_SDCARD	<= init;
																						end if;
							
							when	sFIFO_wr_0Bytes		=>	
																					if current_read_adr >= SD_CARD_MAX_ADR	then
																						if CTN_dat_block	>= SD_LAST_BLOCK_SIZE - 1  then
																							CTN_dat_block			<=	0;
																							CTN_BYTE_PUFFER		<=	0;
																							current_read_adr	<=	0;
																							FSM_SDCARD				<=	SD_Reading;
																							FIFO_wrreq_TOP		<=	'0';
																						else
																						CTN_dat_block		<=	CTN_dat_block	+	3;
																						FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																						FIFO_wrreq_TOP	<=	'1';	
																						end if;
																						
																					else
																						if CTN_dat_block	>= blocklen - 2 then -- Bei nicht genauen Werte nkommt es zu Verzeerrungen 
																							CTN_dat_block		<=	0;
																							CTN_BYTE_PUFFER	<=	CTN_BYTE_PUFFER	+	1;
																							byte1_Buffer		<=	std_logic_vector(dat_block(CTN_dat_block));
																							byte2_Buffer		<=	std_logic_vector(dat_block(CTN_dat_block + 1));
																							FSM_SDCARD			<=	SD_Reading;
																							FIFO_wrreq_TOP	<=	'0';
																						else
																							CTN_dat_block		<=	CTN_dat_block	+	3;
																							FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																							FIFO_wrreq_TOP	<=	'1';
																						end if;	
																					end if;
																					
																					
							when	sFIFO_wr_1Bytes	=>		
																					if current_read_adr >= SD_CARD_MAX_ADR	then
																						if CTN_dat_block	>= SD_LAST_BLOCK_SIZE  then
																							CTN_dat_block			<=	0;
																							current_read_adr	<=	0;
																							CTN_BYTE_PUFFER		<=	0;
																							FIFO_wrreq_TOP		<=	'0';
																							FSM_SDCARD				<=	SD_Reading;
																						else
																						
																							if CTN_dat_block	=	0 then
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block)) & bYTe1_Buffer & bytE2_Buffer;
																								FIFO_wrreq_TOP	<=	'1';
																								CTN_dat_block		<=	CTN_dat_block	+	1;
																							else
																								CTN_dat_block		<=	CTN_dat_block	+	3;
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																								FIFO_wrreq_TOP	<=	'1';
																							end if;	
																						end if;
																						
																					else
																						if CTN_dat_block	=	0	then
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block)) & bYTe2_Buffer & bytE1_Buffer;
																								FIFO_wrreq_TOP	<=	'1';
																								CTN_dat_block		<=	CTN_dat_block	+	1;
																						else
																							if CTN_dat_block	>= blocklen - 1 then -- Bei nicht genauen Werte nkommt es zu Verzeerrungen 
																								CTN_dat_block		<=	0;
																								CTN_BYTE_PUFFER	<=	CTN_BYTE_PUFFER	+	1;
																								byte1_Buffer		<=	std_logic_vector(dat_block(CTN_dat_block));
																								FSM_SDCARD			<=	SD_Reading;
																								FIFO_wrreq_TOP	<=	'0';
																							else
																								CTN_dat_block		<=	CTN_dat_block	+	3;
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																								FIFO_wrreq_TOP	<=	'1';
																							end if;
																						end if;	
																					end if;
																																										
							when	sFIFO_wr_2Bytes	=>	
																				if current_read_adr >= SD_CARD_MAX_ADR	then
																						if CTN_dat_block	>= SD_LAST_BLOCK_SIZE  then
																							CTN_dat_block			<=	0;
																							current_read_adr	<=	0;
																							CTN_BYTE_PUFFER		<=	0;
																							FIFO_wrreq_TOP		<=	'0';
																							FSM_SDCARD				<=	SD_Reading;
																						else
																						
																							if CTN_dat_block	=	0 then
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block))  & bytE1_Buffer(7	downto	0);
																								FIFO_wrreq_TOP	<=	'1';
																								CTN_dat_block		<=	CTN_dat_block	+	2;
																							else
																								CTN_dat_block		<=	CTN_dat_block	+	3;
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																								FIFO_wrreq_TOP	<=	'1';
																							end if;	
																						end if;
																						
																					else
																						if CTN_dat_block	=	0	then
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block)) & bytE1_Buffer;
																								FIFO_wrreq_TOP	<=	'1';
																								CTN_dat_block		<=	CTN_dat_block	+	2;
																						else
																							if CTN_dat_block	>= blocklen then -- Bei nicht genauen Werte nkommt es zu Verzeerrungen 
																								CTN_dat_block		<=	0;
																								CTN_BYTE_PUFFER	<=	0;
																								FSM_SDCARD			<=	SD_Reading;
																								FIFO_wrreq_TOP	<=	'0';
																							else
																								CTN_dat_block		<=	CTN_dat_block	+	3;
																								FIFO_DATA_INPUT	<=	x"00" & std_logic_vector(dat_block(CTN_dat_block + 2)) & std_logic_vector(dat_block(CTN_dat_block + 1)) & std_logic_vector(dat_block(CTN_dat_block));
																								FIFO_wrreq_TOP	<=	'1';
																							end if;
																						end if;	
																					end if;

							when others							=> FSM_SDCARD	<=	idle;
						end case;
						if rst = '0' then
							FSM_SDCARD				<=	init;
							CTN_dat_block			<=	0;
							CTN_BYTE_PUFFER		<=	0;
							CTN_SD_BLOCKS			<=	0;
							LED(0)						<=	'0';
							current_read_adr	<=	0;
						end if;
					end if;
		end process	SD_CARD_Controller;
	end generate	SD_CARD_PROCESS;
end BEH_Ident_Player_TOP;
