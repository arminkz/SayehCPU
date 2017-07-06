library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity register_m is
	generic (
		size : integer := 16
	);
	port (
		clk : in std_logic;
		load : in std_logic;
		reset : in std_logic;
		idata : in std_logic_vector(size - 1 downto 0);
		odata : out std_logic_vector(size - 1 downto 0)
	);
end entity register_m;


architecture RTL of register_m is
begin
	
	process(clk)
	begin
		if (clk = '1') then
			if(reset = '1') then
				odata <= (others => '0');
			elsif(load = '1') then
				odata <= idata;
			end if;
		end if;
	end process;
	
end architecture RTL;