library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity registerfile_tb is
end;

architecture bench of registerfile_tb is

  component registerfile
    port( clk : in std_logic;
		rselect : in std_logic_vector(3 downto 0);
  		iwp : in std_logic_vector(5 downto 0);
  		lwrite : in std_logic;
  		hwrite : in std_logic;
		idata : in std_logic_vector(15 downto 0);
		ordata : out std_logic_vector(15 downto 0);
  		oldata : out std_logic_vector(15 downto 0));
  end component;

  signal clk: std_logic;
  signal rselect: std_logic_vector(3 downto 0);
  signal iwp: std_logic_vector(5 downto 0);
  signal lwrite: std_logic;
  signal hwrite: std_logic;
  signal idata: std_logic_vector(15 downto 0);
  signal ordata: std_logic_vector(15 downto 0);
  signal oldata: std_logic_vector(15 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: registerfile port map ( clk     => clk,
                               rselect => rselect,
                               iwp     => iwp,
                               lwrite  => lwrite,
                               hwrite  => hwrite,
                               idata   => idata,
                               ordata  => ordata,
                               oldata  => oldata );

  stimulus: process
  begin
  
    -- Put initialisation code here
	iwp <= "000000";
	rselect <= "0000";
	lwrite <= '1';
	hwrite <= '1';
	idata <= "1010111110101010";
	
	wait for 2*clock_period;
	
	rselect <= "0100";
	idata <= "1111111111111111";

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