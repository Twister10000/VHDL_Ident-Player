-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AES10_DATA_MAPPER is

	generic(
	
		MADI_Mode	:	integer	range 0 to 64 := 56
	
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
	signal	MADI_SUBFRAME			:	std_logic	:=	'0';
	signal	MADI_BLock_Start	:	std_logic	:=	'0';
	signal	MADI_PARITY				:	std_logic	:=	'0';
	
	-- Vektor Declarations
	signal	MADI_DATA					:	std_logic_vector	(3 downto		0)	:=	(others =>	'0');
	signal	MADI_FRAME				:	std_logic_vector	(31 downto	0)	:=	(others	=>	'0');
	
	
	-- integer Declarations
	signal	MADI_FRAME_CTN		:	integer	range	0 to 64 := 0;
	signal	GENERIC_CTN				:	integer	range	0	to 64	:= 0;


begin


		MADI_DATA_ENCODER	:	entity work.AES10_DATA_ENCODER
		port map(
		
			MADI_CLK		=>	MADI_CLK,
			MADI_DATA		=>	MADI_DATA,
--			Send_SYNC		=>	Send_SYNC,
			MADI_OUT		=>	MADI_OUT);

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end BEH_AES10_DATA_MAPPER;
