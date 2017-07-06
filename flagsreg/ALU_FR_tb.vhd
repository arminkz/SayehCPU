library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alufr is
end entity alufr;

architecture bench of alufr is
	--Inner Modules
	
	component ALU
	port(
	E : in std_logic; --Enable
	A : in std_logic_vector(15 downto 0);
	B : in std_logic_vector(15 downto 0);
	OP : in std_logic_vector(3 downto 0); --ALU OpCode
	C : out std_logic_vector(15 downto 0);
	CIn : in std_logic; --Carry Flag
	COut : out std_logic; --Carry Flag
	ZOut : out std_logic  --Zero Flag 
	);
	end component;
	
	component FR is
	port(
	clk : in std_logic;
	CSet , CReset , ZSet , ZReset , SRLoad : in std_logic;
	CIn , ZIn : in std_logic;
	COut , ZOut : out std_logic
	);
	end component;
	
	signal clk: std_logic;
	signal AluOpCode : std_logic_vector(3 downto 0);
	signal AluA , AluB , AluOut : std_logic_vector(15 downto 0);	
	signal CSet , CReset , ZSet , ZReset , SRLoad :  std_logic;
	signal CFromAlu , ZFromAlu : std_logic;
	signal C , Z : std_logic;
	
	constant clock_period: time := 10 ns;
	signal stop_the_clock: boolean;

begin
	
	FlagsRegister : FR
	port map(clk,CSet,CReset,ZSet,ZReset,SRLoad,CFromAlu,ZFromAlu,C,Z);
	
	ArithmeticUnit : ALU
	port map('1',AluA,AluB,AluOpCode,AluOut,C,CFromAlu,ZFromAlu);
	
	stimulus: process
	begin
			
		CSet <= '0';
		CReset <= '1';
		ZSet <= '0';
		ZReset <= '1';
		
		wait for clock_period;
		
		CReset <= '0';
		ZReset <= '0';
		SRLoad <= '1';
		
		-- Put initialisation code here
		AluA <= "1000000000000000";
		AluB <= "1000000000000010";
		AluOpCode <= "0100";

		wait for 2 * clock_period;
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


end architecture bench;