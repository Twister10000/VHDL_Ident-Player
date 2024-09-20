-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AES10_DATA_MAPPER is

	generic(
	
		MADI_Mode				:	integer	range 0 to 	64 	:= 64;
		SIMULATION			: boolean	:= false;								
		MADI_ACTIVE_CH	: integer	range 0	to	64	:= 4
	
	);

	port
	(
		-- Input ports
		MADI_CLK	: in  std_logic;
		FIFO_DATA	: in  std_logic_vector (23 downto 0) 					:= (others => '0');

		-- Output ports
		MADI_OUT	: out std_logic	:= '0';
		MADI_FRAME_OUT	:		out std_logic_vector(31 downto	0)	:= (others => '0')
		
		
	);
end AES10_DATA_MAPPER;

architecture BEH_AES10_DATA_MAPPER of AES10_DATA_MAPPER is

	-- Declarations (optional)
	
	--std_logic Declarations
	signal	MADI_SUBFRAME_Start					:	std_logic	:=	'1';		-- Signal für den Anzeigen wann ein neuer SubFrame Kommt
	signal	MADI_BLock_Start						:	std_logic	:=	'0';		-- Signal für das Anzeigen wann die Audio Files wieder neu gestartet werden
	signal	MADI_PARITY									:	std_logic	:=	'0';		-- Signal für das Parity Bit BIT31
	signal  FIFO_wrrq										:	std_logic	:=	'1';
	signal	FIFO_FULL										:	std_logic	:=	'0';
	signal	FIFO_EMPTY									:	std_logic	:= 	'0';
	signal	FIFO_READ_ENA								:	std_logic	:=	'0';
	signal	FIFO_READ_ENA_SIMU								:	std_logic	:=	'1';
			
	-- Vektor Declarations		
	signal	MADI_DATA										:	std_logic_vector	(3 downto		0)	:=	(others =>	'0');
	signal	MADI_FRAME									:	std_logic_vector	(31 downto	0)	:=	(others	=>	'0');
	
	
	signal FIFO_rdusedw									:	std_logic_vector	(13	downto	0)	:=	(others	=>	'0');
	signal FIFO_wrusedw									:	std_logic_vector	(10 downto	0)	:=	(others	=>	'0');


	-- integer Declaratio
	signal	MADI_Chanel_CTN							:	integer	range	0 to 64 := 0;



begin

		MADI_ENCDOER : if SIMULATION = false generate
			MADI_DATA_ENCODER	:	entity work.AES10_DATA_ENCODER
			port map(
			
				MADI_CLK			=>	MADI_CLK,
				MADI_DATA			=>	MADI_DATA,
				FIFO_READ_ENA	=>	FIFO_READ_ENA,
				FIFO_EMPTY		=>	FIFO_EMPTY,
				MADI_OUT			=>	MADI_OUT);
		end generate MADI_ENCDOER;
		
		--FIFO_MAP_ENCO	:	if SIMULATION	= false	generate
			FIFO_MAP_ENC	: entity	work.FIFO_MAP_ENC
			port map(
			
					data				=>	MADI_FRAME,
					rdclk				=>	MADI_CLK,
					rdreq				=>	FIFO_READ_ENA_SIMU,
					wrclk				=>	MADI_CLK,
					wrreq				=>	FIFO_wrrq,
					q						=>	MADI_DATA,
					rdempty			=>	FIFO_EMPTY,
					rdusedw			=>	FIFO_rdusedw,
					wrfull			=>	FIFO_FULL,
					wrusedw			=>	FIFO_wrusedw);
		--end generate FIFO_MAP_ENCO;
		
		
		
		
	-- Process Statement (optional)
	
	AES10_DATA_Formatter	: process(all)
	
	begin
	
				if rising_edge(MADI_CLK)	then
				
						Madi_Chanel_CTN		<=	Madi_Chanel_CTN + 1;
						MADI_SUBFRAME_Start	<= '0';
						if	FIFO_FULL	= '0' then	
							if MADI_Chanel_CTN >= MADI_AcTIVE_CH	then		-- Bei Inaktiven Kanälen muss der Frame mit 0en gefüllt werden
								
								MADI_FRAME(31 downto	0) <= x"FFFFFFFF";
								MADI_FRAME_OUT(31 downto 0) <= MADI_FRAME(31 downto	0); -- Test Zweck
								
							else
								
								case	MADI_SUBFRAME_Start is 		-- Das Subframe 0 Bit wird hinzugefügt falls nötig
										
										when '1'			=>	MADI_FRAME(0) <= '1';
										when '0'			=>	MADI_FRAME(0) <= '0';
										when others 	=>	null;
									
									end case;
			
									MADI_FRAME(2 downto 1)		<= "01";					-- Status Bit Active & Status Bit für Subframe Identifikation wird gesetzt
									
									case MADI_BLock_Start	is				-- Beim Start von den AudioFiles wird der Block gestartet.
										when '1'					=>	MADI_FRAME(3)	<=	'1';
										when others				=>	MADI_FRAME(3)	<=	'0';
									end case;
									
									MADI_FRAME(27 downto	4) <= FIFO_DATA(23 downto	0); -- Audio Daten werden in das Frame geschrieben. Bit 27 ist MSB!!!!
									
									MADI_FRAME(30 downto 28)	<= "000";					-- Validty, User und Channel Status Bit wird auf 0 gesetzt. 0 = Valid					
									
									if MADI_SUBFRAME_Start = '1' and MADI_BLock_Start = '1' then  -- Parity Bit möglichkeiten werden hier abgebildet
										
										MADI_FRAME(31) <=		'1' xor '1' xor '0' xor '1'; 
										
									elsif	MADI_SUBFRAME_Start = '1' and MADI_BLock_Start = '0' then
										
										MADI_FRAME(31) <=		'1' xor '1' xor '0' xor '0'; 
										
									elsif	MADI_SUBFRAME_Start = '0' and MADI_BLock_Start = '1' then
										
										MADI_FRAME(31) <=		'0' xor '1' xor '0' xor '1'; 
									
									elsif	MADI_SUBFRAME_Start = '0' and MADI_BLock_Start = '0' then
										
										MADI_FRAME(31) <=		'0' xor '1' xor '0' xor '0'; 
									end if;
									
									
									MADI_FRAME_OUT(31 downto 0) <= MADI_FRAME(31 downto	0); -- Test Zweck
							
							end if;	
						else
							MADI_FRAME(31 downto	0) <= MADI_FRAME(31 downto	0);
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
