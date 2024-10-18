-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity AUDIO_DATA_CONTROLLER is
	generic
	(
		Simulation	: boolean  :=	false
	);


	port
	(
		-- Input ports
		CLK	: 	in  std_logic	:=	'0'


		-- Output ports
		--<name>	: out <type>;

	);
end AUDIO_DATA_CONTROLLER;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture beh_AUDIO_DATA_CONTROLLER of AUDIO_DATA_CONTROLLER is
	-- Type Declarations
	
	type state_type	is (sSetAdr, sReading);
	
	-- Finite-State-Maschine Declarations
		signal	State : state_type := sSetAdr;
		
		attribute syn_encoding	: string;
		attribute	syn_encoding	of state_type	:	type is "safe";
		
	-- Signal Declarations (optional)
	

begin

	-- Process Statement (optional)
	AUDIO_CONTROLLER	:	process(all)
		begin
				if rising_edge(CLK)	then
				
					
				
				end if;
	end process AUDIO_CONTROLLER;
end beh_AUDIO_DATA_CONTROLLER;
