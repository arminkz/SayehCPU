library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FR is
	port(
		clk : in std_logic;
		CSet , CReset , ZSet , ZReset , SRLoad : in std_logic;
		CIn , ZIn : in std_logic;
		COut , ZOut : out std_logic
	);
end entity FR;

architecture RTL of FR is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if(SRLoad = '1') then
				COut <= CIn;
				ZOut <= ZIn;
			elsif(CSet = '1') then
				COut <= '1';
			elsif(CReset = '1') then
				COut <= '0';
			elsif(ZSet = '1') then
				ZOut <= '1';
			elsif(ZReset = '1') then
				ZOut <= '0';
			end if;
		end if;
	end process;
	
end architecture RTL;