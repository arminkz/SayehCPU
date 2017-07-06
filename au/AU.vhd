library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AU is
	port(
		clk : in std_logic;
		RegIn : in std_logic_vector(15 downto 0);
		ImdIn : in std_logic_vector(7 downto 0);
		EnablePC , ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
		AddressOut : out std_logic_vector(15 downto 0)
	);
end entity;

architecture RTL of AU is

	component AL is
	port(
	PCIn : in std_logic_vector(15 downto 0);
	RegIn : in std_logic_vector(15 downto 0);
	ImdIn : in std_logic_vector(7 downto 0);
	ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
	ALOut : out std_logic_vector(15 downto 0)
	);
	end component;
	
	component register_m is
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

	signal Address : std_logic_vector(15 downto 0);
	signal PCOut : std_logic_vector(15 downto 0);
begin
	
	ProgramCounter : register_m
	generic map(16)
	port map(clk,EnablePC,'0',Address,PCOut);
	
	AddressLogic : AL
	port map(PCOut,RegIn,ImdIn,ResetPC,PCplusI,PCplus1,RplusI,Rplus0,Address);
	
	AddressOut <= Address;
	
end architecture RTL;