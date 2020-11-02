-------------------------------------------------------------------------------------
-- processor.vhd
-- Seth Kantz
-- 
-- 
--
--
--
--
-------------------------------------------------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;


entity processor is
	generic(SIZE: integer:=16);
	port(
		clk:			IN 	std_logic;
		data_in:		IN		std_logic_vector(SIZE-1 downto 0);
		run_in:		IN		std_logic;
		reset_in:	IN		std_logic;
		
		done_out:	OUT	std_logic;
		bus_out:		OUT 	std_logic_vector(SIZE-1 downto 0));


end processor;


architecture struct of processor is

-------------------------------------------------------------------------
-- WIRES 

	signal bus_s: std_logic_vector(SIZE-1 downto 0);
	-- wires from registers to mux
	signal r0_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r1_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r2_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r3_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r4_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r5_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r6_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal r7_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal g_mux_s: std_logic_vector(SIZE-1 downto 0);
	signal a_calc_s: std_logic_vector(SIZE-1 downto 0);
	signal calc_g_s: std_logic_vector(SIZE-1 downto 0);
	

	signal fsm_mux_s: 	std_logic_vector(9 downto 0);
	signal fsm_reg_s:		std_logic_vector(10 downto 0);
	signal addsub_sel_s:	std_logic;
	
	signal ir_fsm_s:	std_logic_vector(7 downto 0);
	

	component reg is 
		generic (SIZE : integer := 16);
		port(
			d_in:			IN		std_logic_vector(SIZE-1 downto 0);
			sel_in:		IN		std_logic;
			clk:			IN		std_logic;

			q_out:		OUT	std_logic_vector(SIZE-1 downto 0));

	end component;

	component mux is
		generic(SIZE: integer := 16);
		port(	
			r0_in:			IN		std_logic_vector(SIZE-1 downto 0);
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
	end component;

	
	component calc is 
		generic(SIZE: integer := 16);
		port(
			n1_in:		IN		std_logic_vector(SIZE-1 downto 0);
			n2_in:		IN		std_logic_vector(SIZE-1 downto 0);
			mode_in:		IN		std_logic;
		
			data_out:	OUT	std_logic_vector(SIZE-1 downto 0));
	
	end component;

	
	
	component control_fsm is 
		generic(IRSIZE: integer := 8);

		port(
			clk:			IN		std_logic;
			run_in:		IN		std_logic;
			reset_in:	IN		std_logic;
			ir_in:		IN		std_logic_vector(IRSIZE-1 downto 0);
	
			mux_sel_out:	OUT	std_logic_vector(9 downto 0);
		
			-- register control

			reg_sel_out: OUT	std_logic_vector(10 downto 0);

			calc_mode_out:	OUT	std_logic;
		
			done_out:		OUT	std_logic);
		
	end component;

	
begin


-- main registers
	reg_0:	reg 		
			generic map (SIZE => SIZE)

			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(0),
			clk		=> clk,			

			q_out		=> r0_mux_s);
	reg_1:	reg		
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(1),
			clk		=> clk,			

			q_out		=> r1_mux_s);
	reg_2:	reg
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(2),
			clk		=> clk,			

			q_out		=> r2_mux_s);
	reg_3:	reg 
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(3),
			clk		=> clk,			

			q_out		=> r3_mux_s);
	reg_4:	reg
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(4),
			clk		=> clk,			

			q_out		=> r4_mux_s);
	reg_5:	reg
			generic map (SIZE => SIZE)	
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(5),
			clk		=> clk,			

			q_out		=> r5_mux_s);
	reg_6:	reg
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(6),
			clk		=> clk,			

			q_out		=> r6_mux_s);
	reg_7:	reg 
			generic map (SIZE => SIZE)
			port map(
			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(7),
			clk		=> clk,			

			q_out		=> r7_mux_s);
	
-- calc registers	
	reg_a:	reg 
			generic map (SIZE => SIZE)
			port map(

			d_in		=> bus_s,			
			sel_in	=> fsm_reg_s(8),
			clk		=> clk,			

			q_out		=> a_calc_s);
	
	reg_g:	reg
			generic map (SIZE => SIZE)
			port map(
			d_in		=> calc_g_s,			
			sel_in	=> fsm_reg_s(9),
			clk		=> clk,			

			q_out		=> g_mux_s);
	
	
	
	-- input register
	reg_ir:	reg 
		generic map (SIZE => 8)
		
		port map(
			d_in		=> data_in(7 downto 0),			
			sel_in	=> fsm_reg_s(10),
			clk		=> clk,			

			q_out		=> ir_fsm_s);
	
	
	-- addsub module
	addSub:	calc 
		generic map (SIZE => SIZE)	
		port map(
		n1_in			=>		a_calc_s,
		n2_in			=>		bus_s,
		mode_in		=>		addsub_sel_s,
		
		data_out		=>		calc_g_s);
	
	
	
-- wires up the multiplexer
	multiplexer:	mux 
			generic map (SIZE => SIZE)			
			port map(
			r0_in		=>			r0_mux_s,
			r1_in		=>			r1_mux_s,
			r2_in		=>			r2_mux_s,
			r3_in		=>			r3_mux_s,
			r4_in		=>			r4_mux_s,
			r5_in		=>			r5_mux_s,
			r6_in		=>			r6_mux_s,
			r7_in		=>			r7_mux_s,
			g_in 		=> 		g_mux_s,
			d_in		=>			data_in,


			switch_in	=>		fsm_mux_s,
			mux_out 		=>		bus_s);

-- Control Unit FSM		
	control_unit:	control_fsm port map(
		clk					=> clk,
		run_in				=> run_in,
		reset_in				=> reset_in,
		ir_in					=> ir_fsm_s,
	
		mux_sel_out			=> fsm_mux_s,
		
		-- register control

		reg_sel_out			=> fsm_reg_s,

		
		calc_mode_out 		=>	addsub_sel_s,
		
		done_out 			=> done_out);
		
		bus_out <= bus_s;
	
end struct;