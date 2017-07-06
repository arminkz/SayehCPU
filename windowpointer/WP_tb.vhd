library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity WP_tb is
end;

architecture bench of WP_tb is

  component WP
  	port (
  		clk : in std_logic;
  		add : in std_logic;
  		reset : in std_logic;
  		idata : in std_logic_vector(5 downto 0);
  		odata : out std_logic_vector(5 downto 0)
  	);
  end component;

  signal clk: std_logic;
  signal add: std_logic;
  signal reset: std_logic;
  signal idata: std_logic_vector(5 downto 0);
  signal odata: std_logic_vector(5 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: WP port map ( clk   => clk,
                     add   => add,
                     reset => reset,
                     idata => idata,
                     odata => odata );

  stimulus: process
  begin
  
    -- Put initialisation code here
	reset <= '1';
	idata <= "000001";
	
	wait for clock_period;
	
	reset <= '0';
	add <= '1';
	

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;