--When source clock domain is slower than destination clock domain
--Synchronize control signals only

library ieee;
use ieee.std_logic_1164.all;

entity ff_synchronizer is
generic(
	g_stages : natural :=2);
port(
	i_clk : in std_ulogic;
	i_rst : in std_ulogic;
	i_async_s : in std_ulogic;
	o_sync_s : out std_ulogic);
end ff_synchronizer;

architecture rtl of ff_synchronizer is
	signal r_sync : std_ulogic_vector(g_stages-1 downto 0);

	--If ASYC_REG is applied, the placer tries to place the flip-flops in a synchronization chain
	--closely to maximize MTBF. Registers with ASYNC_REG that are directly connected, will be grouped 
	--and placed together into a single slice, assuming they have a comparable control set, and the number 
	--of registers does not exceed the available resources of the slice.
	attribute ASYNC_REG : string;
	attribute ASYNC_REG of r_sync : signal is "true";

	--Prevent XST from translating FF chain into SRL plus FF.
	attribute SHREG_EXTRACT : string;
	attribute SHREG_EXTRACT of r_sync : signal is "NO";
begin
	sync : process(i_clk) is
	begin
		if(i_rst = '1') then
			r_sync <= (others => '0');
		elsif (rising_edge((i_clk))) then
			r_sync <= r_sync(r_sync'high-1 downto 0) & i_async_s;
		end if;
			
	end process; -- sync

	o_sync_s <= r_sync(r_sync'high);
end rtl;