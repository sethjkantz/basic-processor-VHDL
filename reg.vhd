-----------------------------------------------------------------------------------------------
-- reg.vhd
-- Seth Kantz
-- 	  - register that stores input when sel_in and clk rising edge
--
--		  INPUT:		SIZE		- generic size of data in and out (default 16)
--						d_in		- input data
--						sel_in	- select bit for the register ('1' for change '0' for stay the same)
--						clk		- clock
--
--
--		  OUTPUT:	q_out		- output data
--
------------------------------------------------------------------------------------------------

Library ieee;
USE ieee.std_logic_1164.all;

-- default reg size is 16
entity reg is 
	generic (SIZE : integer := 16);
	port(
		d_in:			IN		std_logic_vector(SIZE-1 downto 0);
		sel_in:		IN		std_logic;
		clk:			IN		std_logic;

		q_out:		OUT	std_logic_vector(SIZE-1 downto 0));

end reg;


-- mixed register (just a D flip flop)
architecture mixed of reg is
	signal internal_q: std_logic_vector(SIZE-1 downto 0);

	begin
		process(clk)
		begin
			-- flips signal on rising edge
			if(rising_edge(clk) and sel_in = '1') then
				internal_q <= d_in;
			else
				internal_q <= internal_q;
			end if;
		end process;
		q_out <= internal_q;

end mixed;