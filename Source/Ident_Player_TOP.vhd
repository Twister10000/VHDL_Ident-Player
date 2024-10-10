-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity Ident_Player_TOP is
--	generic
--	(
--		<name>	: <type>  :=	<default_value>;
--		...
--		<name>	: <type>  :=	<default_value>
--	);


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

begin
	
	-- MADI_PLL Instantiation
	
	MADI_PLL					:	entity	work.MADI_PLL
		port map(
				inclk0				=>	CLK,
				c0						=>	MADI_CLK_PLL,
				locked				=>	MADI_Locked
		
		
		);
	
	
	-- MADI_DATA_MAPPER Instantiation
	MADI_DATA_MAPPER	:	entity work.AES10_DATA_MAPPER
		port map(
		
			MADI_CLK				=>	MADI_CLK_PLL,
			Word_CLK				=>	Word_CLK,
			FIFO_DATA				=>	FIFO_DATA_SEND,
			MADI_FRAME_OUT	=>	MADI_DATA,
			MADI_OUT				=>	MADI_OUT);
	
	
	-- Process Statement (optional)

	main	:	process	(all)
	
	begin
	
						if rising_edge(MADI_CLK_PLL)	then
							--if RST = '0' then
							--	Divider <= 0;
							--end if;
							
							Divider 		<= Divider + 1;
						
							if Divider	= 2603 then
								Divider 	<= 0;
							end if;
						
							if Divider 	= 0 then
								Word_CLK 		<= '1';
							else
								Word_CLK		<= '0';
							end if;			
						
						
							ARDUINO_IO(12) <= Word_CLK;		
							if BTN(0) = '1' then
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
