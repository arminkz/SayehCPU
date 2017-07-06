library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WP is
	port (
		clk : in std_logic;
		add : in std_logic;
		reset : in std_logic;
		idata : in std_logic_vector(5 downto 0);
		odata : out std_logic_vector(5 downto 0)
	);
end entity WP;

architecture RTL of WP is
	signal osignal : std_logic_vector (5 downto 0);
begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			if(add = '1') then
				osignal <= std_logic_vector(unsigned(osignal) + unsigned(idata));
			end if;
			if(reset = '1') then
				osignal <= "000000";
			end if;
		end if;
	end process;
			
	odata <= osignal;
	
end architecture RTL;