--2-phase closed loop solution with req/ack handshake for crossing
--multi-but signal(bus) through asynchronous clock boundaries.

library ieee;
use ieee.std_logic_1164.all;

entity cdc_2phase is
	generic (
			g_width : natural :=4);
	port (
			i_clk_A : in std_ulogic;
			i_rst_A : in std_ulogic;
			i_valid_A : in std_ulogic;
			i_data_A : in std_ulogic_vector(g_width -1 downto 0);
			o_ready_A : out std_ulogic;
			o_data_A : out std_ulogic_vector(g_width -1 downto 0);

			i_clk_B : in std_ulogic;
			i_rst_B : in std_ulogic;
			o_valid_B : out std_ulogic;
			o_data_B : out std_ulogic_vector(g_width -1 downto 0));
end cdc_2phase;

architecture arch of cdc_2phase is 	
	signal w_ready : std_ulogic;
	signal r_req : std_ulogic;
	signal r_ack : std_ulogic;

	signal r_ack_sync,r_ack_syncA : std_ulogic;
	signal r_req_sync,r_req_syncB : std_ulogic;
begin

	w_ready <= '1' when r_req = r_ack_syncA else '0';
	o_data_A <= i_data_A;
	--clock domain A
	sync_ack_A: entity work.ff_synchronizer(rtl)
	generic map(
		g_stages => 2)
	port map(
		i_clk => i_clk_A, 	
		i_rst => i_rst_A,
		i_async_s => r_ack,
		o_sync_s =>r_ack_syncA);

	handshake_A : process(i_clk_A)
	begin
		if(rising_edge(i_clk_A)) then
			if(i_rst_A = '1') then
				r_req <= '0';
				o_ready_A <= '0';
			else
				o_ready_A <= w_ready;
				if(i_valid_A = '1' and o_ready_A = '1') then
					r_req <= not r_req;
				end if;
			end if;
		end if;
	end process; -- handshake_A

	--clock domain B

	sync_req_B : process(i_clk_B)
	begin
		if(rising_edge(i_clk_B)) then
			if(i_rst_B = '1') then
				r_ack <= '0';
				o_valid_B <= '0';
			elsif(r_req_syncB /= r_ack) then
				o_valid_B <= '1';
				r_ack <= not r_ack;
				o_data_B <= o_data_A;
			else
				o_valid_B <= '0';
			end if;
		end if;
	end process; -- sync_req_B

	sync_ack_B: entity work.ff_synchronizer(rtl)
	generic map(
		g_stages => 2)
	port map(
		i_clk => i_clk_B, 	
		i_rst => i_rst_B,
		i_async_s => r_req,
		o_sync_s =>r_req_syncB);

end arch;