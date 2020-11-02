------------------------------------------------------------------------
-- calc.vhd
--		-
--		INPUT:	SIZE - generic size of data
--		
--
--
--
--
--
--
---------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;


entity calc is 
	generic(SIZE: integer := 16);
	port(
		n1_in:		IN		std_logic_vector(SIZE-1 downto 0);
		n2_in:		IN		std_logic_vector(SIZE-1 downto 0);
		mode_in:		IN		std_logic;
		
		data_out:	OUT	std_logic_vector(SIZE-1 downto 0));
	
end calc;

-- adds if 0 subs if 1
architecture behav of calc is
begin

	with mode_in select data_out <=
		std_logic_vector(signed(n1_in) + signed(n2_in)) 		when '0',
		std_logic_vector(signed(n1_in) - signed(n2_in)) 		when others;


end behav;