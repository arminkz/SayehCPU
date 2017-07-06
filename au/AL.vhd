library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AL is
	port(
		PCIn : in std_logic_vector(15 downto 0);
		RegIn : in std_logic_vector(15 downto 0);
		ImdIn : in std_logic_vector(7 downto 0);
		ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
		ALOut : out std_logic_vector(15 downto 0)
	);
end entity AL;

architecture RTL of AL is
begin
	process(PCIn,RegIn,ImdIn,ResetPC,PCplusI,PCplus1,RplusI,Rplus0)
	begin
		if(ResetPC = '1') then
			ALOut <= "0000000000000000";
		elsif(PCplusI = '1') then
			ALOut <= std_logic_vector(unsigned(PCIn) + unsigned(ImdIn));
		elsif(PCplus1 = '1') then
			ALOut <= std_logic_vector(unsigned(PCIn) + 1);
		elsif(RplusI = '1') then
			ALOut <= std_logic_vector(unsigned(RegIn) + unsigned(ImdIn));
		elsif(Rplus0 = '1') then
			ALOut <= RegIn;
		else
			ALOut <= PCIn;
		end if;
	end process;
end architecture RTL;