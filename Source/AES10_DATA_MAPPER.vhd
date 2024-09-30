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
		MADI_ACTIVE_CH	: integer	range 0	to	64	:= 64
	
	);

	port
	(
		-- Input ports
		MADI_CLK	: in  std_logic;
		FIFO_DATA	: in  std_logic_vector (23 downto 0) 					:= (others => '1');

		-- Output ports
		MADI_OUT	: out std_logic	:= '0';
		MADI_FRAME_OUT	:		out std_logic_vector(31 downto	0)	:= (others => '0')
		
		
	);
end AES10_DATA_MAPPER;

architecture BEH_AES10_DATA_MAPPER of AES10_DATA_MAPPER is

	-- Declarations (optional)
	
	--constants Declarations
	constant BYTE0											:	std_logic_vector	(7 downto 0)	:=	"10000100"; -- Basic audio parameters
	constant BYTE1											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Channel modes, user bits management
	constant BYTE2											:	std_logic_vector	(7 downto 0)	:=	"00101100"; -- Auxiliary bits, word length and alignment level
	constant BYTE3											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Auxiliary bits, word length and alignment level
	constant BYTE4											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Auxiliary bits, word length and alignment level
	constant BYTEZ											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Constant for zero filling
	
	
	--std_logic Declarations
	signal	MADI_SUBFRAME_Start					:	std_logic	:=	'1';		-- Signal für den Anzeigen wann ein neuer SubFrame Kommt
	signal	MADI_BLock_Start						:	std_logic	:=	'0';		-- Signal für das Anzeigen wann die Audio Files wieder neu gestartet werden
	signal	MADI_PARITY									:	std_logic	:=	'0';		-- Signal für das Parity Bit BIT31
	signal  FIFO_wrrq										:	std_logic	:=	'1';
	signal	FIFO_FULL										:	std_logic	:=	'0';
	signal	FIFO_EMPTY									:	std_logic	:= 	'0';
	signal	FIFO_READ_ENA								:	std_logic	:=	'0';
	signal	FIFO_READ_ENA_SIMU					:	std_logic	:=	'1';
	
	
	signal	MADI_FRAME_READY						:	std_logic	:=	'0';
	signal	MADI_FRAME_PARITY						:	std_logic	:=	'0';
	signal	MADI_OUT_BUFFER							:	std_logic	:=	'0';
			
	-- Vektor Declarations		
	signal	MADI_DATA										:	std_logic_vector	(3 downto		0)	:=	(others =>	'0');
	signal	MADI_FRAME									:	std_logic_vector	(31 downto	0)	:=	(others	=>	'0');
	signal	MADI_FRAME_FIFO							:	std_logic_vector	(31 downto	0) 	:=	(others	=>	'0');
	
	
	signal FIFO_rdusedw									:	std_logic_vector	(8	downto	0)	:=	(others	=>	'0');
	signal FIFO_wrusedw									:	std_logic_vector	(5 downto	0)	:=	(others	=>	'0');


	-- integer Declaratio
	signal	MADI_Chanel_CTN							:	integer	range	0 to 64 := 0;
	signal	MADI_Block_CTN							:	integer	range	0 to 256 := 0; -- Counter für die AES3 Status Bits. 



begin

		MADI_ENCDOER : if SIMULATION = false generate
			MADI_DATA_ENCODER	:	entity work.AES10_DATA_ENCODER
			port map(
			
				MADI_CLK			=>	MADI_CLK,
				MADI_DATA			=>	MADI_DATA,
				FIFO_READ_ENA	=>	FIFO_READ_ENA,
				FIFO_EMPTY		=>	FIFO_EMPTY,
				MADI_OUT			=>	MADI_OUT_BUFFER);
		end generate MADI_ENCDOER;
		
		--FIFO_MAP_ENCO	:	if SIMULATION	= false	generate
			FIFO_MAP_ENC	: entity	work.FIFO_MAP_ENC
			port map(
			
					data				=>	MADI_FRAME_FIFO,
					rdclk				=>	MADI_CLK,
					rdreq				=>	FIFO_READ_ENA_SIMU,
					wrclk				=>	MADI_CLK,
					wrreq				=>	FIFO_wrrq,
					q						=>	MADI_DATA,
					rdempty			=>	FIFO_EMPTY,
					--rdusedw			=>	FIFO_rdusedw,
					wrfull			=>	FIFO_FULL,
					wrusedw			=>	FIFO_wrusedw);
		--end generate FIFO_MAP_ENCO;
		
		
		
		
	-- Process Statement (optional)
	
	AES10_DATA_Formatter	: process(all)
	variable	temp		: std_logic;
	begin
	
				if rising_edge(MADI_CLK)	then
				
						Madi_Chanel_CTN		<=	Madi_Chanel_CTN + 1;
						MADI_SUBFRAME_Start	<= '0';
						FIFO_wrrq	<= '0';
						FIFO_READ_ENA_SIMU	<= FIFO_READ_ENA;
						MADI_OUT		<= MADI_OUT_BUFFER;
						
						MADI_FRAME_READY	<= '0';
						MADI_FRAME_PARITY	<= '0';
						
						if	FIFO_wrusedw	< x"3D"  then	
							if MADI_Chanel_CTN >= MADI_AcTIVE_CH	then		-- Bei Inaktiven Kanälen muss der Frame mit 0en gefüllt werden
								
								MADI_FRAME(31 downto	0) <= (others	=>	'0');
								MADI_FRAME_OUT(31 downto 0) <= MADI_FRAME(31 downto	0); -- Test Zweck
								FIFO_wrrq	<= '1';
								
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
									
									--MADI_FRAME(30 downto 28)	<= "000";					-- Validty, User und Channel Status Bit wird auf 0 gesetzt. 0 = Valid
									
									MADI_FRAME(29 downto 28)	<= "00";					-- Validty, User und Channel Status Bit wird auf 0 gesetzt. 0 = Valid
									
									case	MADI_BLOck_CTN	is
										--when 0 to 7			=>	MADI_FRAME(30)	<=	BytE0(MADI_BLOck_CTN);
										--when 8 to 15		=>	MADI_FRAME(30)	<=	BYTE1(MADI_BLOck_CTN-8);
										--when 16 to 23		=>	MADI_FRAME(30)	<=	BYTE2(MADI_BLOck_CTN-16);
										--when 24 to 31		=>	MADI_FRAME(30)	<=	BYTE3(MADI_BLOCK_CTN-24);
										--when 32 to 40		=>	MADI_FRAME(30)	<=	BYTE4(MADI_BLOCK_CTN-32); 
										
										when others				=>	MADI_FRAME(30)	<= '0';
									end case;
				
									MADI_FRAME_PARITY	<= '1';
								end if;
								if MADI_FRAME_PARITY = '1' and FIFO_wrusedw	< x"3D" then
									
									temp	:= MADI_FRAME(4) xor MADI_FRAME(5);
									temp	:= MADI_FRAME(6) xor temp;
									temp	:= MADI_FRAME(7) xor temp;
									temp	:= MADI_FRAME(8) xor temp;
									temp	:= MADI_FRAME(9) xor temp;
									temp	:= MADI_FRAME(10) xor temp;
									temp	:= MADI_FRAME(11) xor temp;
									temp	:= MADI_FRAME(12) xor temp;
									temp	:= MADI_FRAME(13) xor temp;
									temp	:= MADI_FRAME(14) xor temp;
									temp	:= MADI_FRAME(15) xor temp;
									temp	:= MADI_FRAME(16) xor temp;
									temp	:= MADI_FRAME(17) xor temp;
									temp	:= MADI_FRAME(18) xor temp;
									temp	:= MADI_FRAME(19) xor temp;
									temp	:= MADI_FRAME(20) xor temp;
									temp	:= MADI_FRAME(21) xor temp;
									temp	:= MADI_FRAME(22) xor temp;
									temp	:= MADI_FRAME(23) xor temp;
									temp	:= MADI_FRAME(24) xor temp;
									temp	:= MADI_FRAME(25) xor temp;
									temp	:= MADI_FRAME(26) xor temp;
									temp	:= MADI_FRAME(27) xor temp;
									temp	:= MADI_FRAME(28) xor temp;
									temp	:= MADI_FRAME(29) xor temp;
									temp	:= MADI_FRAME(30) xor temp;
									MADI_FRAME(31)	<= not temp;
									
									
									MADI_FRAME_READY	<= '1';
									FIFO_wrrq					<= '1';
									
								end if;
								if MADI_FRAME_READY	= '1' and FIFO_wrusedw	< x"3D" and FIFO_wrrq	= '1' then
									
									--for i in 0 to 31 loop
									--
									--MADI_FRAME_FIFO(31-i) <= MADI_FRAME(i);
									--
									--end loop;
									
									MADI_FRAME_FIFO(31 downto 0) <= MADI_FRAME(31 downto	0); -- Test Zweck
							
							end if;	
						else -- Falls FIFO Voll ist
							MADI_FRAME(31 downto	0) <= MADI_FRAME(31 downto	0);
							FIFO_wrrq	<= '0';
						end if;
						
						if MadI_Chanel_CTN >= MADI_Mode-1 then -- Wenn der letzte Kanal geschickt wird muss ein neuer SubFrame gestartet werden
						
							Madi_Chanel_CTN		<= 	0;
							MADI_BLOCk_Start	<=	'0';
							MADI_Block_CTN		<=	MADI_BLock_CTN	+	1;
							MADI_SUBFRAME_Start	<= '1';
							

						
						end if;
							if MADI_BLock_CTN	>= 191 then
								MADI_BLOCK_Start	<=	'1';
								MADI_BLock_CTN <= 0;
							end if;
						
				end if;
				
				
	end process AES10_DATA_Formatter;

end BEH_AES10_DATA_MAPPER;
