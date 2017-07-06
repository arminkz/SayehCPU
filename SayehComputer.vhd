library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SayehComputer is
end entity SayehComputer;

architecture RTL of SayehComputer is
	
	component Sayeh is
	port(
	clk : in std_logic;
	reset : in std_logic;
	readmem : out std_logic;
	writemem : out std_logic;
	databus : inout std_logic_vector(15 downto 0);
	addressbus : out std_logic_vector(15 downto 0)
	);
	end component;
	
	component memory is
	generic (blocksize : integer := 1024);
	port (
	clk, readmem, writemem : in std_logic;
	addressbus: in std_logic_vector (15 downto 0);
	databus : inout std_logic_vector (15 downto 0);
	memdataready : out std_logic
	);
	end component;
	
	signal clk: std_logic;
	signal clk2: std_logic;
	signal readMem , writeMem : std_logic;
	signal AddressBus : std_logic_vector(15 downto 0);
	signal DataBus : std_logic_vector(15 downto 0);
	signal ExternalReset : std_logic;
	
	signal memReady : std_logic; --dummy memReady signal
	
	constant clock_period: time := 10 ns;
	signal stop_the_clock: boolean;
	
begin
	
	RAM : memory
	generic map(1024)
	port map(clk,readMem,writeMem,AddressBus,DataBus,memReady);
	
	CPU : sayeh
	port map(clk,ExternalReset,readMem,writeMem,DataBus,AddressBus);
	
	clocking: process
	begin
		while not stop_the_clock loop
		  clk <= '0', '1' after clock_period / 2;
		  wait for clock_period;
		end loop;
		wait;
	end process;

end architecture RTL;