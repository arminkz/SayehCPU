library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
	port(
		clk : in std_logic;		
		DataBus : inout std_logic_vector(15 downto 0);
		AddressBus : out std_logic_vector(15 downto 0);
		CSet , CReset , ZSet , ZReset , SRLoad : in std_logic; -- Flags Control Signals
		AluOpCode : in std_logic_vector(3 downto 0); -- ALU Control Signal
		WPAdd , WPReset : in std_logic; -- WP Control Signals
		IRLoad , IRReset : in std_logic; -- IR Control Signals
		RFLwrite , RFHwrite : in std_logic; -- RegFile Control Signals
		EnablePC , ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic; -- AddressingUnit Control Signals
		RDonAFR , RSonAFR : in std_logic; -- AFR Bus TriStates
		AdrOnDataBus , AluOnDataBus : in std_logic; -- DataBus TriStates
		IRonLOperandBus , IRonHOperandBus , RSonOperandBus : in std_logic; -- OperandBus TriStates
		ShadowIn : in std_logic;
		COut , ZOut : out std_logic;
		InstructionCode : out std_logic_vector(7 downto 0)
	);
end entity datapath;

architecture RTL of datapath is
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
	
	component WP is
	port (
	clk : in std_logic;
	add : in std_logic;
	reset : in std_logic;
	idata : in std_logic_vector(5 downto 0);
	odata : out std_logic_vector(5 downto 0)
	);
	end component;
	
	component RFile is
	port( clk : in std_logic;
	rselect : in std_logic_vector(3 downto 0); --Select two Registers
	iwp : in std_logic_vector(5 downto 0); --WP Input
	lwrite : in std_logic;
	hwrite : in std_logic;
	idata : in std_logic_vector(15 downto 0);
	ordata : out std_logic_vector(15 downto 0);
	oldata : out std_logic_vector(15 downto 0));
	end component;
	
	component AU is
	port(
	clk : in std_logic;
	RegIn : in std_logic_vector(15 downto 0);
	ImdIn : in std_logic_vector(7 downto 0);
	EnablePC , ResetPC , PCplusI , PCplus1 , RplusI , Rplus0 : in std_logic;
	AddressOut : out std_logic_vector(15 downto 0)
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
	
	signal AluOut : std_logic_vector(15 downto 0);
	signal C , Z , CFromAlu , ZFromAlu : std_logic;
	signal IROut : std_logic_vector(15 downto 0);
	signal WPOut : std_logic_vector(5 downto 0);
	signal RD , RS : std_logic_vector(15 downto 0);
	signal RegFileSelect : std_logic_vector(3 downto 0) := (others => '0');
	signal AddressFromRegBus : std_logic_vector(15 downto 0); --AFR
	signal Address : std_logic_vector(15 downto 0);
	signal OperandBus : std_logic_vector(15 downto 0);

begin

	---------------
	--Inner Modules
	
	FlagsRegister : FR
	port map(clk,CSet,CReset,ZSet,ZReset,SRLoad,CFromAlu,ZFromAlu,C,Z);
	
	ArithmeticUnit : ALU
	port map('1',RD,OperandBus,AluOpCode,AluOut,C,CFromAlu,ZFromAlu);
	
	InstructionRegister : register_m
	generic map(16)
	port map(clk,IRLoad,IRReset,DataBus,IROut);
	
	WindowPointer : WP
	port map(clk,WPAdd,WPReset,IROut(5 downto 0),WPOut);
	
	RegisterFile : RFile
	port map(clk,RegFileSelect,WPOut,RFLwrite,RFHwrite,DataBus,RS,RD);
	
	AddressingUnit : AU
	port map(clk,AddressFromRegBus,IROut(7 downto 0),EnablePC , ResetPC , PCplusI , PCplus1 , RplusI , Rplus0, Address);
	
	-------------------
	--Tri-State Buffers
	
	AddressFromRegBus <= RD when RDonAFR='1' else
						 RS when RSonAFR='1' else
						 "ZZZZZZZZZZZZZZZZ";
						 
	DataBus <= Address when AdrOnDataBus='1' else
			   AluOut when AluOnDataBus='1' else
			   (others => 'Z');
			   
	AddressBus <= Address;
	
	OperandBus(7 downto 0) <= IROut(7 downto 0) when IRonLOperandBus='1' else
							  "ZZZZZZZZ";
							  
	OperandBus(15 downto 8) <= IROut(7 downto 0) when IRonHOperandBus='1' else
							  "ZZZZZZZZ";
							  
	OperandBus <= RS when RSonOperandBus='1' else
				  "ZZZZZZZZZZZZZZZZ";
				  
	COut <= C;
	
	ZOut <= Z;
	
	InstructionCode <= IROut(15 downto 8) when ShadowIn='0' else
					   IROut(7 downto 0);
	
	RegFileSelect <= IROut(11 downto 8) when ShadowIn='0' else
					 IROut(3 downto 0);

end architecture RTL;