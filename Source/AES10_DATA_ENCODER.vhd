-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AES10_DATA_ENCODER is

	port
	(
		-- Input ports
		MADI_CLK		: in  std_logic;
		Word_CLK		:	in	std_logic;
		FIFO_empty	:	in	std_logic;
		Encoder_ENA	:	in	std_logic;
		MADI_DATA		: in  std_logic_vector (3 downto 0) := (others => '0'); 

		-- Output ports
		MADI_OUT					: out std_logic	:=	'0';
		FIFO_READ_ENA			:	out	std_logic	:=	'0'
		
	);
end AES10_DATA_ENCODER;

architecture BEH_AES10_DATA_ENCODER of AES10_DATA_ENCODER is
	-- FSM Declarations
		-- Zustandsmaschine: Steuert den Gesamtbetrieb des Kodierers.
		type state_type	is (Send_Frame, Word_CLK_Check, Send_Sync_Symbols, IDLE);
		
		signal	State : state_type := IDLE;
		
		attribute syn_encoding	: string;
		attribute	syn_encoding	of state_type	:	type is "safe";

	--Constant Declarations
	constant	Sync_Symbol			:	std_logic_vector	(9 downto	0)	:= "1100010001"; -- Symbol J(11000) and Symbol K(10001)
	
	--Signal Declarations 
	signal	Start_Newframe	:	std_logic												:= 	'0';
	signal	DelayFF0				:	std_logic												:=	'0';
	signal	DelayFF1				:	std_logic												:=	'0';
	signal	DelayFF2				:	std_logic												:=	'0';
	Signal	Word_CLK_EDGE		:	std_logic												:=	'0';
	Signal	NEW_5bit_DATA		:	std_logic												:=	'0';
	signal	MADI_DATA_5bit 	: std_logic_vector	(4 downto 0) 	:= (others	=> '0');
	signal	CTN							: integer range 0 to 16 					:=	4;
	signal	Word_CTN				:	integer	range 0 to 1024					:=	0;
	signal	CTN_SYNC				: integer range 0 to 16 					:=	9;
	signal	CTN_S_SYMBOL		: integer range 0 to 64 					:=	0;
	signal	Sync_Long				:	integer range 0 to 16						:=	0;


begin

	-- Process Statement (optional)
	
	bit_encoding : process(all) -- Prozess für 4B5B Encoding
	
	begin
	
				if rising_edge(MADI_CLK) then
					/*4B5B Encoding*/
					-- Führt die 4B5B-Codierung basierend auf den Eingangsdaten durch.
					FIFO_READ_ENA	<= '0';
					if NEW_5bit_DATA	= '1' and Encoder_ENA	= '1' then
						case MADI_DATA(3 downto	0) is
							when "0000"		=>	MADI_DATA_5bit	<= "11110";
							when "0001"		=>	MADI_DATA_5bit	<= "01001";
							when "0010"		=>	MADI_DATA_5bit	<= "10100";
							when "0011"		=>	MADI_DATA_5bit	<= "10101";
							when "0100"		=>	MADI_DATA_5bit	<= "01010";
							when "0101"		=>	MADI_DATA_5bit	<= "01011";
							when "0110"		=>	MADI_DATA_5bit	<= "01110";
							when "0111"		=>	MADI_DATA_5bit	<= "01111";
							when "1000"		=>	MADI_DATA_5bit	<= "10010";
							when "1001"		=>	MADI_DATA_5bit	<= "10011";
							when "1010"		=>	MADI_DATA_5bit	<= "10110";
							when "1011"		=>	MADI_DATA_5bit	<= "10111";
							when "1100"		=>	MADI_DATA_5bit	<= "11010";
							when "1101"		=>	MADI_DATA_5bit	<= "11011";
							when "1110"		=>	MADI_DATA_5bit	<= "11100";
							when "1111"		=>	MADI_DATA_5bit	<= "11101";
							when others		=> MADI_DATA_5bit 	<= (others => '0');
						end case;
						FIFO_READ_ENA	<= '1';
					end if;
				end if;
	
	end process bit_encoding;
	
	NRZI_encoding : process(all) -- Implementiert die NRZI-Modulation für die codierten Daten.
	
	begin
	
				if rising_edge(MADI_CLK) then
					
					NEW_5bit_DATA	<= '0';
					Word_CLK_EDGE	<= '0';
					if Encoder_ENA	= '1' then
						
							DelayFF0	<= Word_CLK;
							DelayFF1	<=	DelayFF0;
							DelayFF2	<=	DelayFF1;								
							Word_CLK_EDGE	<= DelayFF1	and not DelayFF2; -- Word_CLK_EDGE: Detektiert die steigende Flanke des Word_CLK
							
							if Word_CLK	= '1' then
								Start_Newframe	<= '1';
								NEW_5bit_DATA		<= '1';
							end if;
							
						-- Zustandsmaschine: Steuert den Gesamtbetrieb des Kodierers
						case State is
							
							when IDLE								=>
										-- Wenn ein neues Frame gestartet wird, wechselt in den Send_Frame-Zustand
										if Start_Newframe	= '1' then
											Start_Newframe	<= '0';
											State						<= Send_Frame;
										end if;
							
							when Send_Frame					=>
										-- Zähler CTN für die Datenübertragung
										if CTN > 0 then
											CTN <= CTN - 1;
										end if;
										 -- Wenn CTN auf 0 fällt, wird ein neues Wort übertragen
										if CTN <= 0 then
											CTN <= 4;
											Word_CTN	<=	Word_CTN + 1;
											-- Wenn alle Wörter übertragen wurden, wechselt in den Send_Sync_Symbols-Zustand
											if Word_CTN	>= 447 then  -- 447@56CH 511@64CH
												State	<= Send_Sync_Symbols;
											else
												State	<= Send_Frame;
											end if;
										-- Wenn CTN = 1, wird das nächste Datenbit aus dem FIFO gelesen
										elsif CTN =	1 and Word_CTN	<= 446	then	-- 446@56CH 510@64CH							
											NEW_5bit_DATA <= '1'; --FIFO Read_Enbaled active
										end if;
										-- Übertragung des aktuellen Datenbits
										case MADI_DATA_5bit(CTN)	is							-- Das erste Bit von Links muss als erstes Übermittelt werden AES-10 S11 Table 5
											when '1'		=>	MADI_OUT <= not MADI_OUT;
											when '0'		=>	MADI_OUT <= MADI_OUT;
											when others	=> null;
										end case;
										
							when Send_Sync_Symbols	=>
											-- Zähler CTN_SYNC für die Übertragung der Synchronisationszeichen
											if CTN_SYNC	> 0 then
												CTN_SYNC	<= CTN_SYNC	-	1;
											end if;
											-- Wenn alle Synchronisationszeichen übertragen wurden, wird überprüft, ob der nächste Frame startet
											if CTN_SYNC <= 0 then
													if Start_Newframe	= '1' then
														Start_Newframe	<= '0';
														State					<= Send_Frame;
														CTN						<= 	4;
														Word_CTN			<=	0;
														CTN_SYNC			<= 	9;
													else
														CTN_SYNC			<= 9;
														state					<= Send_Sync_Symbols;
													end if;
													
											end if;
											-- Übertragung des aktuellen Synchronisationszeichens
											case Sync_Symbol(CTN_SYNC)	is						-- Das erste Bit von Links muss als erstes Übermittelt werden AES-10 S11 Table 5
												when '1'		=>	MADI_OUT <= not MADI_OUT;
												when '0'		=>	MADI_OUT <= MADI_OUT;
												when others	=> null;
											end case;		
							when others	=> null;
						end case;
					end if;
				end if;
	end process NRZI_encoding;
end BEH_AES10_DATA_ENCODER;