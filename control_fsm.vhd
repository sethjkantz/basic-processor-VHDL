----------------------------------------------------------------------------------------
-- control_fsm.vhd
-- Seth Kantz
--			- 
--			INPUT:
--
--
--			OUTPUT:
--
----------------------------------------------------------------------------------------
Library ieee;
use ieee.std_logic_1164.all;

entity control_fsm is 
	generic(IRSIZE: integer := 8);

	port(
		clk:			IN		std_logic;
		run_in:		IN		std_logic;
		reset_in:	IN		std_logic;
		ir_in:		IN		std_logic_vector(IRSIZE-1 downto 0);
		
		mux_sel_out:	OUT	std_logic_vector(9 downto 0);
		

		--r0-r7-a-g-ir
		reg_sel_out: OUT	std_logic_vector(10 downto 0);
		
		calc_mode_out:	OUT	std_logic;
		
		done_out:		OUT	std_logic);
		
end control_fsm;



architecture behav of control_fsm is
	type fsm_state is (T0,T1,T2,T3);
	signal state_s: fsm_state;



begin

	-- Process to determine next state
	process(clk,reset_in) begin
		if(reset_in = '0') 
			then state_s <= T0;
		elsif(rising_edge(clk)) 
			then case state_s is
					when T0 =>
						-- transition if defined
						if (ir_in(7) = '0' or ir_in(7) = '1') and run_in = '1'
							then state_s <= T1; 
						end if;
					when T1 =>
						if ir_in(7) = '1'
							then state_s <= T2;
						else
							state_s <= T0;
						end if;
					when T2 =>
						if ir_in(7) = '1'
							then state_s <= T3;
						else
							state_s <= T0;
						end if;
					when T3 =>
						state_s <= T0;
					when others =>
						state_s <= state_s;
			end case;
		end if;
	end process;
	 
	-- process to determine output (Mealy FSM)
	process(state_s,ir_in)
	
	begin
	
	
		case state_s is
				
					when T0 =>
						mux_sel_out <= "0000000000";
						reg_sel_out <= "00000000000";
						calc_mode_out <= '0';
						done_out <= '0';
						-- only assert ir select
						reg_sel_out(10) <= '1';

					when T1 =>
						mux_sel_out <= "0000000000";
						reg_sel_out <= "00000000000";
						
						case ir_in(7 downto 6) is
								when "00" =>
										-- mux select y line
										case ir_in(2 downto 0) is
												when "000" => mux_sel_out(0) <= '1';
												when "001" => mux_sel_out(1) <= '1';
												when "010" => mux_sel_out(2) <= '1';
												when "011" => mux_sel_out(3) <= '1';
												when "100" => mux_sel_out(4) <= '1';
												when "101" => mux_sel_out(5) <= '1';
												when "110" => mux_sel_out(6) <= '1';
												when others => mux_sel_out(7) <= '1';
										end case;
										-- reg enable x reg
										case ir_in(5 downto 3) is
												when "000" => reg_sel_out(0) <= '1';
												when "001" => reg_sel_out(1) <= '1';
												when "010" => reg_sel_out(2) <= '1';
												when "011" => reg_sel_out(3) <= '1';
												when "100" => reg_sel_out(4) <= '1';
												when "101" => reg_sel_out(5) <= '1';
												when "110" => reg_sel_out(6) <= '1';
												when others => reg_sel_out(7) <= '1';
										end case;
										done_out <= '1';
								when "01" =>
										-- select d out
										mux_sel_out(9) <= '1';
										-- reg enable x reg
										case ir_in(5 downto 3) is
												when "000" => reg_sel_out(0) <= '1';
												when "001" => reg_sel_out(1) <= '1';
												when "010" => reg_sel_out(2) <= '1';
												when "011" => reg_sel_out(3) <= '1';
												when "100" => reg_sel_out(4) <= '1';
												when "101" => reg_sel_out(5) <= '1';
												when "110" => reg_sel_out(6) <= '1';
												when others => reg_sel_out(7) <= '1';
									end case;
									done_out <= '1';

								when others =>
										-- mux select x line
										case ir_in(5 downto 3) is
												when "000" => mux_sel_out(0) <= '1';
												when "001" => mux_sel_out(1) <= '1';
												when "010" => mux_sel_out(2) <= '1';
												when "011" => mux_sel_out(3) <= '1';
												when "100" => mux_sel_out(4) <= '1';
												when "101" => mux_sel_out(5) <= '1';
												when "110" => mux_sel_out(6) <= '1';
												when others => mux_sel_out(7) <= '1';
										end case;
										-- reg enable a
										reg_sel_out(8) <= '1';
										done_out <= '0';

						end case;
					when T2 =>
						mux_sel_out <= "0000000000";
						reg_sel_out <= "00000000000";
						done_out <= '0';

						
						-- mux select y line
						case ir_in(2 downto 0) is
								when "000" => mux_sel_out(0) <= '1';
								when "001" => mux_sel_out(1) <= '1';
								when "010" => mux_sel_out(2) <= '1';
								when "011" => mux_sel_out(3) <= '1';
								when "100" => mux_sel_out(4) <= '1';
								when "101" => mux_sel_out(5) <= '1';
								when "110" => mux_sel_out(6) <= '1';
								when others => mux_sel_out(7) <= '1';
						end case;
						
						-- reg enable g
						reg_sel_out(9) <= '1';
						
						-- select appropriate arithmetic
						case ir_in(7 downto 6) is
								when "10" =>
										calc_mode_out <= '0';
								when "11" =>
										calc_mode_out <= '1';
								when others =>
						end case;
					when T3 =>
						-- mux enable g
						mux_sel_out <= "0000000000";
						reg_sel_out <= "00000000000";


						mux_sel_out(8) <= '1';
						done_out <= '1';

						
						-- reg select x
						case ir_in(5 downto 3) is
								when "000" => reg_sel_out(0) <= '1';
								when "001" => reg_sel_out(1) <= '1';
								when "010" => reg_sel_out(2) <= '1';
								when "011" => reg_sel_out(3) <= '1';
								when "100" => reg_sel_out(4) <= '1';
								when "101" => reg_sel_out(5) <= '1';
								when "110" => reg_sel_out(6) <= '1';
								when others => reg_sel_out(7) <= '1';
						end case;					
					when others =>
						done_out <= '0';
				end case;
	end process;


end behav;