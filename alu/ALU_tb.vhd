library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_tb is
end;

architecture bench of ALU_tb is

  component ALU
	port(
	E : in std_logic; --Enable
	A : in std_logic_vector(15 downto 0);
	B : in std_logic_vector(15 downto 0);
	OP : in std_logic_vector(3 downto 0); --ALU OpCode
	C : out std_logic_vector(15 downto 0);
	CFout : out std_logic; --Carry Flag
	CFin : in std_logic; --Carry Flag
	ZF : out std_logic  --Zero Flag 
	);
  end component;

  signal E: std_logic;
  signal A: std_logic_vector(15 downto 0);
  signal B: std_logic_vector(15 downto 0);
  signal OP: std_logic_vector(3 downto 0);
  signal C: std_logic_vector(15 downto 0);
  signal CFout : std_logic;
  signal CFin : std_logic;
  signal ZF: std_logic;
  
  for all:ALU use entity work.ALU(RTL);

begin

  uut: ALU port map ( E  => E,
                      A  => A,
                      B  => B,
                      OP => OP,
                      C  => C,
					  CFout => CFout,
					  CFin => CFin,
                      ZF => ZF );

  stimulus: process
  begin
  
    -- Put initialisation code here
    E <= '1';
    A <= "0000000000000100";
    B <= "0000000000000010";
    OP <= "1000";
    
    -- Put test bench stimulus code here

    wait;
  end process;


end;
