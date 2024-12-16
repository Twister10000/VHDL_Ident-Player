-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AES10_DATA_MAPPER is

	generic(
	
		MADI_Mode						:	integer	range 0 to 	64 	:= 56;
		SIMULATION					: boolean	:= false;								
		MADI_ACTIVE_CH			: integer	range 0	to	64	:= 14
	
	);

	port
	(
		-- Input ports
		MADI_CLK						: in  std_logic;
		Word_CLK						:	in	std_logic;
		FIFO_DATA						: in  std_logic_vector (31 downto 0) 	:= (others => '1');

		-- Output ports
		MADI_OUT						: out std_logic	:=	'0';
		NEW_AUDIO_DATA_RQ		:	out	std_logic	:=	'1';
		MADI_FRAME_OUT			:	out std_logic_vector(31 downto	0)	:= (others => '0')
		
		
	);
end AES10_DATA_MAPPER;

architecture BEH_AES10_DATA_MAPPER of AES10_DATA_MAPPER is

	-- Declarations (optional)
																																							
	--constants Declarations
	constant BYTE0											:	std_logic_vector	(7 downto 0)	:=	"10000101"; -- Basic audio parameters
	constant BYTE1											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Channel modes, user bits management
	constant BYTE2											:	std_logic_vector	(7 downto 0)	:=	"00101100"; -- Auxiliary bits, word length and alignment level
	constant BYTE3											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Auxiliary bits, word length and alignment level
	constant BYTE4											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Auxiliary bits, word length and alignment level
	constant BYTECRC										:	std_logic_vector	(7 downto	0)	:=	"10110000"; -- Fixed CRC Value beacuse The Channelstatus will not Change
	constant BYTEZ											:	std_logic_vector	(7 downto 0)	:=	"00000000"; -- Constant for zero filling
	
	
	--std_logic Declarations
	signal	MADI_SUBFRAME_Start					:	std_logic	:=	'1';		-- Signal für den Anzeigen wann ein neuer SubFrame Kommt
	signal	MADI_BLock_Start						:	std_logic	:=	'1';		-- Signal für das Anzeigen wann die Audio Files wieder neu gestartet werden
	signal	MADI_PARITY									:	std_logic	:=	'0';		-- Signal für das Parity Bit BIT31
	signal  FIFO_wrrq										:	std_logic	:=	'0';
	signal	FIFO_FULL										:	std_logic	:=	'0';
	signal	FIFO_EMPTY									:	std_logic	:= 	'0';
	signal	FIFO_READ_ENA								:	std_logic	:=	'0';
	signal	FIFO_READ_ENA_SIMU					:	std_logic	:=	'0';
	signal	ENCODER_ENABLE							:	std_logic	:=	'0';
	
	
	signal	MADI_FRAME_READY						:	std_logic	:=	'0';
	signal	MADI_FRAME_PARITY						:	std_logic	:=	'0';
	signal	MADI_OUT_BUFFER							:	std_logic	:=	'0';
	signal	Word_CLK_Buffer							:	std_logic	:=	'0';
			
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
				Word_CLK			=>	Word_CLK,
				MADI_DATA			=>	MADI_DATA,
				Encoder_ENA		=>	EncODER_ENABLE,
				FIFO_READ_ENA	=>	FIFO_READ_ENA,
				FIFO_EMPTY		=>	FIFO_EMPTY,
				MADI_OUT			=>	MADI_OUT);
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
					/*Für die Simulation möchte ich das FIFO_READ_ENA immer aktiv haben*/
					if SimULATION	= false then
						FIFO_READ_ENA_SIMU	<= FIFO_READ_ENA;	
					end if;
					
						ENCODER_ENABLE	<= '0';
						NEW_AUDIO_DATA_RQ	<=	'0';
					if FIFO_wrusedw	> x"15" and FIFO_EMPTY	= '0' then
						ENCODER_ENABLE	<= '1';
					end if;
						
						FIFO_wrrq	<= '0';
							
						MADI_FRAME_READY		<= 	'0';
						MADI_FRAME_PARITY		<= 	'0';
						NEW_AUDIO_DATA_RQ		<=	'0';
						
						if	FIFO_wrusedw	< x"3D"  then	

								if MADI_FRAME_READY = '0' and MADI_FRAME_PARITY = '0' then
								case	MADI_SUBFRAME_Start is 		-- Das Subframe 0 Bit wird hinzugefügt falls nötig
										
										when '1'			=>	MADI_FRAME(31) <= '1';
																			MADI_SUBFRAME_Start	<= '0';
										when '0'			=>	MADI_FRAME(31) <= '0';
										when others 	=>	null;
									
									end case;
									
									MADI_FRAME(30)								<=	'1';
									MADI_FRAME(29)								<=	'0';
									case MADI_BLock_Start	is				-- Beim Start von einem AES3-BLock (192) wird der Block gestartet.
										when '1'					=>	MADI_FRAME(28)	<=	'1';
										when '0'					=>	MADI_FRAME(28)	<=	'0';
										when others				=>	null;
									end case;
									
									
									if MADI_ACTIVE_CH <= MADI_CHANEL_CTN	then
										MADI_FRAME(23	downto	0)	<=	(others=>	'0');
									else
										MADI_FRAME(0)							<=	FIFO_DATA(3);
										MADI_FRAME(1)							<=	FIFO_DATA(2);
										MADI_FRAME(2)							<=	FIFO_DATA(1);
										MADI_FRAME(3)							<=	FIFO_DATA(0);
										MADI_FRAME(4)							<=	FIFO_DATA(7);
										MADI_FRAME(5)							<=	FIFO_DATA(6);
										MADI_FRAME(6)							<=	FIFO_DATA(5);
										MADI_FRAME(7)							<=	FIFO_DATA(4);
										MADI_FRAME(8)							<=	FIFO_DATA(11);
										MADI_FRAME(9)							<=	FIFO_DATA(10);
										MADI_FRAME(10)						<=	FIFO_DATA(9);
										MADI_FRAME(11)						<=	FIFO_DATA(8);
										MADI_FRAME(12)						<=	FIFO_DATA(15);
										MADI_FRAME(13)						<=	FIFO_DATA(14);
										MADI_FRAME(14)						<=	FIFO_DATA(13);
										MADI_FRAME(15)						<=	FIFO_DATA(12);
										MADI_FRAME(16)						<=	FIFO_DATA(19);
										MADI_FRAME(17)						<=	FIFO_DATA(18);
										MADI_FRAME(18)						<=	FIFO_DATA(17);
										MADI_FRAME(19)						<=	FIFO_DATA(16);
										MADI_FRAME(20)						<=	FIFO_DATA(23);
										MADI_FRAME(21)						<=	FIFO_DATA(22);
										MADI_FRAME(22)						<=	FIFO_DATA(21);
										MADI_FRAME(23)						<=	FIFO_DATA(20);
									end if;
									
									MADI_FRAME(26)								<=	'0';
									MADI_FRAME(27)								<=	'0'; 
																		
									-- Die Channel Status Bits werden hinzugefügt. 
									case	MADI_BLOck_CTN	is
										when 0 			to 7			=>	MADI_FRAME(25)	<=	BytE0(MADI_BLOck_CTN);
										when 8 			to 15			=>	MADI_FRAME(25)	<=	BYTE1(MADI_BLOck_CTN - 8);
										when 16 		to 23			=>	MADI_FRAME(25)	<=	BYTE2(MADI_BLOck_CTN - 16);
										when 24 		to 31			=>	MADI_FRAME(25)	<=	BYTE3(MADI_BLOCK_CTN - 24);
										when 32 		to 39			=>	MADI_FRAME(25)	<=	BYTE4(MADI_BLOCK_CTN - 32); 
										when 184   	to 192		=>	MADI_FRAME(25)	<= 	BYTECRC(MADI_BLOCk_CTN - 184);
										when others				=>	MADI_FRAME(25)	<= '0'; -- Channel Active 
 									end case;

									MADI_FRAME_PARITY	<= '1';
									
								end if;
								-- Das Parit Bit wird erzeugt
								if MADI_FRAME_PARITY = '1' then

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
									temp	:= MADI_FRAME(25) xor temp;
									temp	:= MADI_FRAME(26) xor temp;
									temp	:= MADI_FRAME(27) xor temp;
									temp	:= MADI_FRAME(0) xor temp;
									temp	:= MADI_FRAME(1) xor temp;
									temp	:= MADI_FRAME(2) xor temp;
									temp	:= MADI_FRAME(3) xor temp;
									MADI_FRAME(24)	<=   temp;
									
									MADI_FRAME_READY	<= '1';

								end if;
								-- Das MADI_Frame wird in das FIFO geschrieben
								if MADI_FRAME_READY	= '1' then
									FIFO_wrrq					<= '1';
									Madi_Chanel_CTN		<=	Madi_Chanel_CTN + 1;
									MADI_FRAME_READY	<=	'0';
									MADI_FRAME_PARITY	<=	'0';
									
									if MADI_ACTIVE_CH	<=	MADI_CHANEL_CTN	then
										NEW_AUDIO_DATA_RQ	<=	'0';
									else
										NEW_AUDIO_DATA_RQ	<=	'1';
									end if;
									
									MADI_FRAME_FIFO(31 downto 0) <= MADI_FRAME(31 downto	0); -- Test Zweck
									-- Wenn der letzte Kanal geschickt wird muss ein neuer SubFrame gestartet werden

--									if MADI_CHANEL_CTN	= MADI_MODE - 1 then
--										NEW_AUDIO_DATA_RQ	<= 	'1';
--									else
--										NEW_AUDIO_DATA_RQ	<=	'0';
--									end if;

									-- Test Szenario für das Testen wo welches BIt beim ANNA-LISA ankommt. 
									--MADI_FRAME_FIFO(0)					<=	'0'; 		--MADI_FRAME(0);
									--MADI_FRAME_FIFO(1)					<=	'0'; 		--MADI_FRAME(1);	
									--MADI_FRAME_FIFO(2)					<=	'1'; 		--MADI_FRAME(2);	
									--MADI_FRAME_FIFO(3)					<=	'1'; 		--MADI_FRAME(3);	
									--MADI_FRAME_FIFO(4)					<=	'0'; 		--MADI_FRAME(4);	
									--MADI_FRAME_FIFO(5)					<=	'0'; 		--MADI_FRAME(5);	
									--MADI_FRAME_FIFO(6)					<=	'0'; 		--MADI_FRAME(6);	
									--MADI_FRAME_FIFO(7)					<=	'0'; 		--MADI_FRAME(7);	
									--MADI_FRAME_FIFO(8)					<=	'0'; 		--MADI_FRAME(8);	
									--MADI_FRAME_FIFO(9)					<=	'0'; 		--MADI_FRAME(9);	
									--MADI_FRAME_FIFO(10)					<=	'0'; 		--MADI_FRAME(10);
									--MADI_FRAME_FIFO(11)					<=	'0'; 		--MADI_FRAME(11);
									--MADI_FRAME_FIFO(12)					<=	'0'; 		--MADI_FRAME(12);
									--MADI_FRAME_FIFO(13)					<=	'0'; 		--MADI_FRAME(13);
									--MADI_FRAME_FIFO(14)					<=	'0'; 		--MADI_FRAME(14);
									--MADI_FRAME_FIFO(15)					<=	'0'; 		--MADI_FRAME(15);
									--MADI_FRAME_FIFO(16)					<=	'0'; 		--MADI_FRAME(16);
									--MADI_FRAME_FIFO(17)					<=	'0'; 		--MADI_FRAME(17);
									--MADI_FRAME_FIFO(18)					<=	'0'; 		--MADI_FRAME(18);
									--MADI_FRAME_FIFO(19)					<=	'0'; 		--MADI_FRAME(19);
									--MADI_FRAME_FIFO(20)					<=	'0'; 		--MADI_FRAME(20);
									--MADI_FRAME_FIFO(21)					<=	'0'; 		--MADI_FRAME(21);
									--MADI_FRAME_FIFO(22)					<=	'0'; 		--MADI_FRAME(22);
									--MADI_FRAME_FIFO(23)					<=	'0'; 		--MADI_FRAME(23);
									--MADI_FRAME_FIFO(24)					<=	'0'; 		--MADI_FRAME(24);
									--MADI_FRAME_FIFO(25)					<=	'0'; 		--MADI_FRAME(25);
									--MADI_FRAME_FIFO(26)					<=	'0'; 		--MADI_FRAME(26);
									--MADI_FRAME_FIFO(27)					<=	'0'; 		--MADI_FRAME(27);
									--MADI_FRAME_FIFO(28)					<=	'0'; 		--MADI_FRAME(28);
									--MADI_FRAME_FIFO(29)					<=	'0'; 		--MADI_FRAME(29);
									--MADI_FRAME_FIFO(30)					<=	'0'; 		--MADI_FRAME(30);
									--MADI_FRAME_FIFO(31)					<=	'0'; 		--MADI_FRAME(31);
									
								end if;	
						else -- Falls FIFO Voll ist
							MADI_FRAME(31 downto	0) <= MADI_FRAME(31 downto	0);
							FIFO_wrrq	<= '0';
						end if;
						
						-- Wenn der letzte Kanal geschickt wird muss ein neuer SubFrame gestartet werden
						if MADI_CHANEL_CTN	= MADI_MODE - 1 then
							MADI_SUBFRAME_Start	<= 	'1';
						else
							MADI_SUBFRAME_Start	<=	'0';
						end if;
						
						-- Wenn der letzte Kanal geschickt wird muss ein neuer SubFrame gestartet werden
						if MadI_Chanel_CTN >= MADI_MODE then 
						
							Madi_Chanel_CTN		<= 	0;
							MADI_BLOCk_Start	<=	'0';
							FIFO_wrrq					<= 	'0';
							MADI_Block_CTN		<=	MADI_BLock_CTN	+	1;

							-- Wenn 192 Subframe geschickt worden sind muss ein neuer AES3-Block gestartet werden
							if MADI_BLock_CTN	>= 191 then
								MADI_BLOCK_Start	<=	'1';
								MADI_BLock_CTN <= 0;
							end if;
						end if;		
				end if;
	end process AES10_DATA_Formatter;
end BEH_AES10_DATA_MAPPER;
