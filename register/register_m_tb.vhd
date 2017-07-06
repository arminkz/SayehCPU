library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity register_m_tb is
end;

architecture bench of register_m_tb is

  component register_m
  	generic (
  		size : integer
  	);
  	port (
  		clk : in std_logic;
  		load : in std_logic;
  		reset : in std_logic;
  		idata : in std_logic_vector(size - 1 downto 0);
  		odata : out std_logic_vector(size - 1 downto 0)
  	);
  end component;

  signal clk: std_logic;
  signal load: std_logic;
  signal reset: std_logic;
  signal idata: std_logic_vector(3 downto 0);
  signal odata: std_logic_vector(3 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: register_m generic map ( size  =>  4)
                     port map ( clk   => clk,
                                load  => load,
                                reset => reset,
                                idata => idata,
                                odata => odata );

  stimulus: process
  begin
  
    -- Put initialisation code here
	reset <= '1';
	
	wait for 2*clock_period;
	
	reset <= '0';
	idata <= "0110";
	load <= '1';
	
	wait for 2*clock_period;
	
	load <= '0';
	
	wait for 2*clock_period;

    -- Put test bench stimulus code here

    --stop_the_clock <= true;
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