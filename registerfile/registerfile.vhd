-------------------------------
--- Created By Armin Kazemi ---
-------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RFile is
  port( 
	clk : in std_logic;
	rselect : in std_logic_vector(3 downto 0); -- Select two Registers
	iwp : in std_logic_vector(5 downto 0); --WP Input
	lwrite : in std_logic;
	hwrite : in std_logic;
	idata : in std_logic_vector(15 downto 0);
	ordata : out std_logic_vector(15 downto 0);
	oldata : out std_logic_vector(15 downto 0));
end entity RFile;

architecture RTL of RFile is
  
    type regfile is array (0 to 63) of std_logic_vector(15 downto 0); -- Declare Matrix (2D array)
    signal rf : regfile := (others => (others => '0')); --instantiate
	
	signal lAdr : std_logic_vector(5 downto 0);
	signal rAdr : std_logic_vector(5 downto 0);
  
begin
  
	lAdr <= std_logic_vector(unsigned(iwp) + unsigned(rselect(3 downto 2)));
	rAdr <= std_logic_vector(unsigned(iwp) + unsigned(rselect(1 downto 0)));
	
	--Right Output
	ordata <= rf(to_integer(unsigned(rAdr)));
	--Left Output
	oldata <= rf(to_integer(unsigned(lAdr)));
  
    process (clk)
		--variable wp_int : integer;
		--variable d_int : integer;
		--variable s_int : integer;
    begin
      if rising_edge(clk) then  --Clock Event
		
		--wp_int := to_integer(unsigned(iwp));
		
		--Left Reg Address (RD)
		--d_int := wp_int + to_integer(unsigned(rselect(3 downto 2)));
		
		--Right Reg Address (RS)
		--s_int := wp_int + to_integer(unsigned(rselect(1 downto 0)));
		
		--Write to RD (left) Register
		if(lwrite = '1') then
			--for i in 0 to 7 loop
			--	rf(d_int)(i) <= idata(i);
			--end loop;
			rf(to_integer(unsigned(lAdr)))(7 downto 0) <= idata(7 downto 0);
		end if;
		
		if(hwrite = '1') then
			--for i in 8 to 15 loop
			--	rf(d_int)(i) <= idata(i);
			--end loop;
			rf(to_integer(unsigned(lAdr)))(15 downto 8) <= idata(15 downto 8);
		end if;
		
      end if;
    end process;
    
end architecture RTL;