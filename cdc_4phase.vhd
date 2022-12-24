--4-phase closed loop solution with req/ack handshake for crossing
--multi-but signal(bus) through asynchronous clock boundaries.

library ieee;
use ieee.std_logic_1164.all;


entity cdc_4phase is 
	generic (
			g_width  : natural := 8);
	port (
			i_clk_A : in std_ulogic;
			i_rst_A : in std_ulogic;
			i_ready_A : in std_ulogic;
			i_data_A : in std_ulogic_vector(g_width -1 downto 0);
			o_busy_A : out std_ulogic;

			i_clk_B : in std_ulogic;
			i_rst_B : in std_ulogic;
			o_busy_B : out std_ulogic;
			o_data_B : out std_ulogic_vector(g_width -1 downto 0));
end cdc_4phase;

architecture arch of cdc_4phase is
	type cdc_4phase_states_TX is (REQ_ASSERT,PH1,REQ_DEASSERT,END_TRANSACTION); 
	type cdc_4phase_states_RX is (ACK_ASSERT,ACK_DEASSERT); 
	signal state_TX : cdc_4phase_states_TX;
	signal state_RX : cdc_4phase_states_RX;

	signal r_req : std_ulogic;
	signal r_ack : std_ulogic;

	signal r_ack_metaA,r_ack_syncA : std_ulogic;
	signal r_req_metaB,r_req_syncB : std_ulogic;
begin

	--clock domain A
	sync_ack_in_A : process(i_clk_A)
	begin
		if(rising_edge(i_clk_A)) then
			r_ack_metaA <= r_ack;
			r_ack_syncA <= r_ack;
		end if;
	end process; -- sync_ack_in_A

	handshake_FSM_tx : process(i_clk_A)
	begin
		if(rising_edge(i_clk_A)) then 
			if(i_rst_A = '1') then 
				state_TX <= REQ_ASSERT;
				o_busy_A <= '1';
				r_req <= '0';
			else
				case state_TX is 
					when REQ_ASSERT => 
						o_busy_A <= '0';
						if(i_ready_A = '1') then
							o_busy_A <= '1';
							r_req <= '1';
							state_TX <= REQ_DEASSERT;
						end if;
					when REQ_DEASSERT =>
						if(r_ack_syncA = '1') then
							r_req <= '0'; 
							state_TX  <= END_TRANSACTION;
						end if;
					when END_TRANSACTION =>
						if(r_ack_syncA = '0') then
							state_TX <= REQ_ASSERT;
							o_busy_A <= '0';
						end if;
					when others =>
						state_TX <= REQ_ASSERT; 
				end case;
			end if;
		end if;
	end process; -- handshake_FSM_tx

	--clock domain B
	sync_req_in_B : process(i_clk_B)
	begin
		if(rising_edge(i_clk_B)) then
			r_req_metaB <= r_req;
			r_req_syncB <= r_req_metaB;
		end if;
	end process; -- sync_req_in_B

	handshake_FSM_rx : process(i_clk_B)
	begin
		if(rising_edge(i_clk_B)) then
			if(i_rst_B = '1') then 
				state_RX <= ACK_ASSERT;
				r_ack <= '0';
				o_busy_B <= '0';
				o_data_B <= (others => '0');
			else
				o_busy_B <= '0';
				case state_RX is 
					when ACK_ASSERT => 
						if(r_req_syncB = '1') then
							o_busy_B <= '1';
							state_RX <= ACK_DEASSERT;
							r_ack <= '1';
							o_data_B <= i_data_A;
						end if;
					when ACK_DEASSERT =>
						o_busy_B <= '1';
						if(r_req_syncB <= '0') then
							o_busy_B <= '0';
							state_RX <= ACK_ASSERT;
							r_ack <= '0';
						end if;
					when others =>
						state_RX <= ACK_ASSERT;
				end case;
			end if;
		end if;
	end process; -- handshake_FSM_rx
end arch;