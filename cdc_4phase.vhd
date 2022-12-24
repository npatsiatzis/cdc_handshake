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
	ff_synchronizerA: entity work.ff_synchronizer(rtl)
	generic map(
		g_stages => 2)
	port map(
		i_clk => i_clk_A, 	
		i_rst => i_rst_A,
		i_async_s => r_ack,
		o_sync_s =>r_ack_syncA);

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
	ff_synchronizer_B: entity work.ff_synchronizer(rtl)
	generic map(
		g_stages => 2)
	port map(
		i_clk => i_clk_B,
		i_rst => i_rst_B,
		i_async_s => r_req,
		o_sync_s =>r_req_syncB);

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