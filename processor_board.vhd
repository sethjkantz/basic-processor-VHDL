----------------------------------------------------------------------
-- processor_board.vhd
--
--
--
----------------------------------------------------------------------


Library ieee;
USE ieee.std_logic_1164.all;

entity processor_board is
 port(	SW:		IN 	std_logic_vector(9 downto 0);
			KEY:		IN		std_logic_vector(3 downto 0);
			LEDR:		OUT	std_logic_vector(9 downto 0));


end processor_board;




-- structural architecture
architecture struct of processor_board is

	component processor is
		generic(SIZE: integer:=16);
		port(
			clk:			IN 	std_logic;
			data_in:		IN		std_logic_vector(SIZE-1 downto 0);
			run_in:		IN		std_logic;
			reset_in:	IN		std_logic;
		
			done_out:	OUT	std_logic;
			bus_out:		OUT	std_logic_vector(SIZE-1 downto 0));
	end component;


begin
	-- maps processor to physical board
	P1: processor generic map(SIZE =>8)
			port map(
				clk => KEY(0),
				data_in => SW(7 downto 0),
				run_in => SW(8),
				reset_in => SW(9),
				done_out => LEDR(9),
				bus_out => LEDR(7 downto 0));

end struct;
