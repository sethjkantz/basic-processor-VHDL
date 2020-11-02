--------------------------------------------------------------------------------------------
-- mux.vhd
-- Seth Kantz
-- 	- 1 hot multiplexer with 10 inputs
--		- defaults to g if input is weird
--
--		INPUTS: SIZE 							 - generic data size
--				  d_in, r0_in - r7_in, g_in - inputs of std logic vector size
--				  switch_in						 - 10 bit selector switch
--
--		OUTPUTS:	mux_out						 - selected input
--
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity mux is
	generic(SIZE: integer := 16);
	port(	r0_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r1_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r2_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r3_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r4_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r5_in:			IN		std_logic_vector(SIZE-1 downto 0);
			r6_in:			IN		std_logic_vector(SIZE-1 downto 0);			
			r7_in:			IN		std_logic_vector(SIZE-1 downto 0);
			g_in:				IN		std_logic_vector(SIZE-1 downto 0);
			d_in:				IN		std_logic_vector(SIZE-1 downto 0);

			switch_in: 		IN 	std_logic_vector(9 downto 0);
			mux_out:			OUT 	std_logic_vector(SIZE-1 downto 0));
end mux;			
	
	
architecture behav of mux is
begin
	with switch_in select mux_out <=
		r0_in		when "0000000001",
		r1_in		when "0000000010",
		r2_in		when "0000000100",
		r3_in		when "0000001000",
		r4_in		when "0000010000",
		r5_in		when "0000100000",
		r6_in		when "0001000000",
		r7_in		when "0010000000",
		g_in		when "0100000000",
		d_in		when others;

end behav;	