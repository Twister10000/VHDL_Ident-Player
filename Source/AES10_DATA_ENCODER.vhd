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
		MADI_CLK	: in  std_logic;
		MADI_DATA	: in  std_logic_vector (3 downto 0) := (others => '0'); -- MADI_DATA(3) last send Bit

		-- Output ports
		MADI_OUT	: out std_logic	:= '0'
		
	);
end AES10_DATA_ENCODER;


architecture BEH_AES10_DATA_ENCODER of AES10_DATA_ENCODER is

	-- Declarations (optional)
	signal MADI_DATA_5bit 	: std_logic_vector	(4 downto 0) := (others	=> '0'); -- MADI_DATA_5bit(4) last send Bit
	signal	CTN							: integer range 0 to 4 := 0;

begin

	-- Process Statement (optional)
	
	bit_encoding : process(all) -- Prozess für 4B5B Encoding
	
	begin
	
				if rising_edge(MADI_CLK) then
					/*4B5B Encoding*/
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
						when others		=> MADI_DATA_5bit <= (others => '0');
					end case;
				
				end if;
	
	end process bit_encoding;
	
	
		NRZI_encoding : process(all) -- Prozess für die Implementierung vom NRZI Schema
	
	begin
	
				if rising_edge(MADI_CLK) then
					
					if CTN = 4 then
						CTN <= 0;
					end if;
					
					case MADI_DATA_5bit(CTN)	is
						when '1'		=>	MADI_OUT <= not MADI_OUT;
						when '0'		=>	MADI_OUT <= MADI_OUT;
						when others	=> null;
					end case;
					CTN <= CTN + 1;
				end if;
	
	end process NRZI_encoding;

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end BEH_AES10_DATA_ENCODER;
