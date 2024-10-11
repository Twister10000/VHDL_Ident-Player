-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

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

		
		-- Inout ports
			-- ARDUINO Shield Pins
			ARDUINO_IO 			: inout std_logic_vector(15 downto 0);
			ARDUINO_RESET_N : inout std_logic;
			
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
			
			-- MADI Pins --
			
			MADI_OUT				:	out	std_logic	:=	'0'

	);
end Ident_Player_TOP;

architecture BEH_Ident_Player_TOP of Ident_Player_TOP is

	-- Declarations (optional)
	signal			FIFO_DATA_SEND	:	std_logic_vector	(23 downto	0) := (others	=> '0');--x"DC5E19"; --x"F0F0F0"; --(others	=> '0'); 
	signal			MADI_DATA				:	std_logic_vector	(31 downto	0);
	signal			MADI_CLK_PLL		: std_logic;
	signal			MADI_Locked			: std_logic;
	signal			Word_CLK				:	std_logic;
	signal			Divider					: integer	range	0	to 4096 := 0;
	signal			FAKE_AUDIO			: integer	range	0	to 17e6 := 0;
	signal			BTN_SYNC				: std_logic_vector	(2 downto	0) := (others	=>	'0');

begin
	
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
	
	-- MADI_DATA_MAPPER Instantiation
	MADI_MAPPER	: if SimULATION	= false generate
	
		MADI_DATA_MAPPER	:	entity work.AES10_DATA_MAPPER
			port map(
			
				MADI_CLK				=>	MADI_CLK_PLL,
				Word_CLK				=>	Word_CLK,
				FIFO_DATA				=>	FIFO_DATA_SEND,
				MADI_FRAME_OUT	=>	MADI_DATA,
				MADI_OUT				=>	MADI_OUT);
	end generate MADI_MAPPER;
	
	-- Process Statement (optional)

	main	:	process	(all)
	
	begin
	
						if rising_edge(MADI_CLK_PLL)	then
							--if RST = '0' then
							--	Divider <= 0;
							--end if;
							
							Divider 		<= Divider + 1;
							FAKE_AUDIO	<= FAKE_AUDIO	+	1;
							if FAKE_AUDIO	= 12e6 then
								Fake_AUDIO	<= 0;
							end if;
							FIFO_DATA_SEND	<= std_logic_vector(to_unsigned(FAKE_AUDIO,24));
							
							if Divider	= 2603 then
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
						
							ARDUINO_IO(12) <= Word_CLK;		
							if BTN_SYNC(2) = '1' then
								LED(1) <= '1';
							else
								LED(1) <= '0';
							end if;
						
						end if;
	
	end process	main;

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end BEH_Ident_Player_TOP;
