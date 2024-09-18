-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AES10_DATA_MAPPER is

	generic(
	
		MADI_Mode				:	integer	range 0 to 	64 	:= 56;
		MADI_ACTIVE_CH	: integer	range 0	to	64	:= 4
	
	);

	port
	(
		-- Input ports
		MADI_CLK	: in  std_logic;
		FIFO_DATA	: in  std_logic_vector (23 downto 0) := (others => '0');

		-- Output ports
		MADI_OUT	: out std_logic	:= '0'
		
		
	);
end AES10_DATA_MAPPER;

architecture BEH_AES10_DATA_MAPPER of AES10_DATA_MAPPER is

	-- Declarations (optional)
	
	--std_logic Declarations
	signal	MADI_SUBFRAME_Start					:	std_logic	:=	'0';		-- Signal für den Anzeigen wann ein neuer SubFrame Kommt
	signal	MADI_BLock_Start						:	std_logic	:=	'0';		-- Signal für das Anzeigen wann die Audio Files wieder neu gestartet werden
	signal	MADI_PARITY									:	std_logic	:=	'0';		-- Signal für das Parity Bit BIT31
			
	-- Vektor Declarations		
	signal	MADI_DATA										:	std_logic_vector	(3 downto		0)	:=	(others =>	'0');
	signal	MADI_FRAME									:	std_logic_vector	(31 downto	0)	:=	(others	=>	'0');


	-- integer Declaratio
	signal	MADI_Chanel_CTN							:	integer	range	0 to 64 := 0;



begin


		MADI_DATA_ENCODER	:	entity work.AES10_DATA_ENCODER
		port map(
		
			MADI_CLK		=>	MADI_CLK,
			MADI_DATA		=>	MADI_DATA,
--			Send_SYNC		=>	Send_SYNC,
			MADI_OUT		=>	MADI_OUT);

	-- Process Statement (optional)
	
	AES10_DATA_Formatter	: process(all)
	
	begin
	
				if rising_edge(MADI_CLK)	then
				
						Madi_Chanel_CTN		<=	Madi_Chanel_CTN + 1;
						MADI_SUBFRAME_Start	<= '0';
						
						if MADI_Chanel_CTN > MADI_AcTIVE_CH	then
							
							MADI_FRAME(31 downto	0) <= (others => '0');
							
						else
							
							case	MADI_SUBFRAME_Start is 		-- Das Subframe 0 Bit wird hinzugefügt falls nötig
									
									when '1'			=>	MADI_FRAME(0) <= '1';
									when '0'			=>	MADI_FRAME(0) <= '0';
									when others 	=>	null;
								
								end case;
		
								MADI_FRAME(1)		<= '1';
								MADI_FRAME(28)	<= '0';
								
								case MADI_BLock_Start	is				-- Beim Start von den AudioFiles wird der Block gestartet.
									when '1'					=>	MADI_FRAME(3)	<=	'1';
									when others				=>	MADI_FRAME(3)	<=	'0';
								end case;
								
								MADI_FRAME(27 downto	4) <= FIFO_DATA(23 downto	0); -- Audio Daten werden in das Frame geschrieben. Bit 27 ist MSB!!!!
								
								MADI_FRAME(31) <= '1' xor '1' xor '0' xor '0';
						
						end if;	
						
						if MadI_Chanel_CTN >= MADI_Mode then -- Wenn der letzte Kanal geschickt wird muss ein neuer SubFrame gestartet werden
						
							Madi_Chanel_CTN		<= 0;
							MADI_SUBFRAME_Start	<= '1';
						
						end if;
				
				end if;
				
				
	end process AES10_DATA_Formatter;

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end BEH_AES10_DATA_MAPPER;
