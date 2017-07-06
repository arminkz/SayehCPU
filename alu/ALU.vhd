library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
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
end entity ALU;

architecture RTL of ALU is
begin
	process (E,A,B,OP)
	  variable TMP : std_logic_vector(16 downto 0);
	begin
		if(E = '1') then
			case OP is
				when "0000" =>
					C <= B;
				when "0001" =>
					--AND
					C <= A and B;
				when "0010" =>
					--OR
					C <= A or B;
				when "0011" =>
					--NOT
					C <= not B;
				when "0100" =>
					--Shift Right
					C <= A(15) & A(15 downto 1);
				when "0101" =>
					--Shift Left
					C <= A(14 downto 0) & '0';
				when "0110" =>
					--Comparison
					if(A = B) then
					    ZOut <= '1';
					else
					    ZOut <= '0';
					    if(signed(B)<signed(A)) then
					        COut <= '1';
					    else
					        COut <= '0';
					    end if;
					end if;
				when "0111" =>
					--Addition
					TMP := std_logic_vector(signed(A(15) & A) + signed(B(15) & B));
					C <= TMP(15 downto 0);
					COut <= TMP(16);
				when "1000" =>
				  --Subtraction
				  if(CIn = '1') then
				    TMP := std_logic_vector(signed(B(15) & B) - signed(A(15) & A) - 1);
				  else
				    TMP := std_logic_vector(signed(B(15) & B) - signed(A(15) & A));
				  end if;
				  C <= TMP(15 downto 0);
				when "1001" =>
				  --Multiplication
				  --C <= std_logic_vector(signed(A(7 downto 0)) * signed(B(7 downto 0)));
				when "1010" =>
				  --Division (Needs work)
				  --C <= std_logic_vector(signed(A(7 downto 0)) / signed(B(7 downto 0)));
				when "1011" => 
				  --Squre Root (Needs work)
				  
				when others =>
					--Do Nothing
			end case;
		end if;
	end process;
end architecture RTL;


