library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
  port(
	clk : in std_logic;		
	rst : in std_logic;
	ReadMem , WriteMem : out std_logic;
	CSet , CReset , ZSet , ZReset , SRLoad : out std_logic; -- Flags Control Signals
	AluOpCode : out std_logic_vector(3 downto 0); -- ALU Control Signal
	WPAdd , WPReset : out std_logic; -- WP Control Signals
	IRLoad , IRReset : out std_logic; -- IR Control Signals
	RFLwrite , RFHwrite : out std_logic; -- RegFile Control Signals
	EnablePC , ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : out std_logic; -- AddressingUnit Control Signals
	RDonAFR , RSonAFR : out std_logic; -- AFR Bus TriStates
	AdrOnDataBus , AluOnDataBus : out std_logic; -- DataBus TriStates
	IRonLOperandBus , IRonHOperandBus , RSonOperandBus : out std_logic; -- OperandBus TriStates
	ShadowIn : out std_logic;
	CIn , ZIn : in std_logic;
	InstructionCode : in std_logic_vector(7 downto 0)
  );
end entity CU;

architecture RTL of CU is
	type state_type is (reset , fetch1 , fetch2 , decode , exec_lda , halt , crash);
  
	signal cur_state : state_type := reset;
	signal next_state : state_type;
  
begin

	process(cur_state,InstructionCode) is
	begin
		-- Zero Out All C Signals
		ReadMem <= '0';
		WriteMem <= '0';
		CSet <= '0';
		CReset <= '0';
		ZSet <= '0';
		ZReset <= '0';
		SRLoad <= '0';
		AluOpCode <= "0000";
		WPAdd <= '0';
		WPReset <= '0';
		IRLoad <= '0';
		IRReset <= '0';
		RFLwrite <= '0';
		RFHwrite <= '0';
		EnablePC <= '0';
		ResetPC <= '0';
		PCplusI <= '0';
		PCplus1 <= '0';
		RplusI <= '0';
		Rplus0 <= '0';
		RDonAFR <= '0';
		RSonAFR <= '0';
		AdrOnDataBus <= '0';
		AluOnDataBus <= '0';
		IRonLOperandBus <= '0';
		IRonHOperandBus <= '0';
		RSonOperandBus <= '0';
		ShadowIn <= '0';
		
		-- Do based on cur_state
		case cur_state is
			when reset =>
				CReset <= '1';
				ZReset <= '1';
				WPReset <= '1';
				IRReset <= '1';
				EnablePC <= '1';
				ResetPC <= '1';
				next_state <= fetch1;
			when fetch1 =>
				ReadMem <= '1';
				next_state <= fetch2;
			when fetch2 =>
				IRLoad <= '1';
				EnablePC <= '1';
				PCplus1 <= '1';
				next_state <= decode;
			when decode =>	
				case InstructionCode(7 downto 4) is
					when "0000" =>
						case InstructionCode(3 downto 0) is
							when "0000" =>
								-- No Operation (nop)
								next_state <= fetch1;
							when "0001" =>
								-- Halt (hlt)
								next_state <= halt;
							when "0010" =>
								-- Set Zero Flag (szf)
								ZSet <= '1';
								next_state <= fetch1;
							when "0011" =>
								-- Clear Zero Flag (czf)
								ZReset <= '1';
								next_state <= fetch1;
							when "0100" =>
								-- Set Carry Flag (scf)
								CSet <= '1';
								next_state <= fetch1;
							when "0101" =>
								-- Clear Carry Flag (ccf)
								CReset <= '1';
								next_state <= fetch1;
							when "0110" =>
								-- Clear Window Pointer (cwp)
								WPReset <= '1';
								next_state <= fetch1;
							when "0111" =>
								-- Jump Relative
								EnablePC <= '1';
								PCplusI <= '1';
								next_state <= fetch1;
							when "1000" =>
								-- Branch if Zero
								if(ZIn = '1') then
									EnablePC <= '1';
									PCplusI <= '1';
								end if;
								next_state <= fetch1;
							when "1001" =>
								-- Branch if Carry
								if(CIn = '1') then
									EnablePC <= '1';
									PCplusI <= '1';
								end if;
								next_state <= fetch1;
							when "1010" =>
								-- Add Window Pointer
								WPAdd <= '1';
								next_state <= fetch1;
							when others =>
								next_state <= crash;
						end case;
					when "0001" =>
						-- Move Register (mvr)
						RSonOperandBus <= '1';
						AluOpCode <= "0000";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "0010" =>
						-- Load Addressed (lda)
						RSonAFR <= '1';
						Rplus0 <= '1';
						ReadMem <= '1';
						next_state <= exec_lda;
					when "0011" =>
						-- Store Addressed (sta)
						RDonAFR <= '1';
						Rplus0 <= '1';
						RSonOperandBus <= '1';
						AluOpCode <= "0000";
						AluOnDataBus <= '1';
						WriteMem <= '1';
						next_state <= fetch1;
					when "0110" =>
						-- AND Registers
						RSonOperandBus <= '1';
						AluOpCode <= "0001";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "0111" =>
						-- OR Registers
						RSonOperandBus <= '1';
						AluOpCode <= "0010";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1000" =>
						-- NOT Registers
						RSonOperandBus <= '1';
						AluOpCode <= "0011";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1001" =>
						-- Shift Left
						RSonOperandBus <= '1';
						AluOpCode <= "0101";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1010" =>
						-- Shift Right
						RSonOperandBus <= '1';
						AluOpCode <= "0100";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1011" =>
						-- Addition
						RSonOperandBus <= '1';
						AluOpCode <= "0111";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1100" =>
						-- Subtraction
						RSonOperandBus <= '1';
						AluOpCode <= "1000";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1110" =>
						-- Comparison
						RSonOperandBus <= '1';
						AluOpCode <= "0110";
						AluOnDataBus <= '1';
						RFHwrite <= '1';
						RFLwrite <= '1';
						next_state <= fetch1;
					when "1111" =>
						-- Move IMD (mil / mih)
						case InstructionCode(1 downto 0) is
							when "01" => 
								IRonHOperandBus <= '1';
								RFHwrite <= '1';
								AluOpCode <= "0000";
								AluOnDataBus <= '1';
								next_state <= fetch1;
							when "00" =>
								IRonLOperandBus <= '1';
								RFLwrite <= '1';
								AluOpCode <= "0000";
								AluOnDataBus <= '1';
								next_state <= fetch1;
							when "10" =>
								--Save PC
								AdrOnDataBus <= '1';
								RFHwrite <= '1';
								RFLwrite <= '1';
							when "11" =>
								--Jump Addressed
								RDonAFR <= '1';
								RplusI <= '1';
								EnablePC <= '1';
							when others =>
								next_state <= crash;
						end case;
					when others =>
						next_state <= crash;
				end case;
			when exec_lda =>
				RFLwrite <= '1';
				RFHwrite <= '1';
				next_state <= fetch1;
				
			when halt =>
				next_state <= halt;
			when crash =>
				next_state <= crash;
		end case;
	end process;
	
	process(clk)
	begin
		if(clk = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
end architecture RTL;