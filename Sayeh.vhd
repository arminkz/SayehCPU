-------------------------------
--- Created By Armin Kazemi ---
-------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sayeh is
	port(
		clk : in std_logic;
		reset : in std_logic;
		readmem : out std_logic;
		writemem : out std_logic;
		databus : inout std_logic_vector(15 downto 0);
		addressbus : out std_logic_vector(15 downto 0)
	);
end entity Sayeh;

architecture RTL of Sayeh is
	
	component datapath is
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
	end component;
	
	component CU is
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
	end component;
	
	signal CSet , CReset , ZSet , ZReset , SRLoad , WPAdd , WPReset , IRLoad , IRReset , RFLwrite , RFHwrite , EnablePC , ResetPC , PCplusI , PCplus1 ,RplusI , Rplus0 , RDonAFR , RSonAFR , AdrOnDataBus , AluOnDataBus , IRonLOperandBus , IRonHOperandBus , RSonOperandBus , Shadow : std_logic;
	signal AluOpCode : std_logic_vector(3 downto 0);
	signal InstructionCode : std_logic_vector(7 downto 0);
	signal CFlag , ZFlag : std_logic;
	
begin

	DP1 : datapath
	port map(clk,databus,addressbus,CSet,CReset,ZSet,ZReset,SRLoad,AluOpCode,WPAdd,WPReset,IRLoad,IRReset,RFLwrite,RFHwrite,EnablePC,ResetPC,PCplusI,PCplus1,RplusI,Rplus0,RDonAFR,RSonAFR,AdrOnDataBus,AluOnDataBus,IRonLOperandBus,IRonHOperandBus,RSonOperandBus,Shadow,CFlag,ZFlag,InstructionCode);
	
	CU1 : CU
	port map(clk,reset,readmem,writemem,CSet,CReset,ZSet,ZReset,SRLoad,AluOpCode,WPAdd,WPReset,IRLoad,IRReset,RFLwrite,RFHwrite,EnablePC,ResetPC,PCplusI,PCplus1,RplusI,Rplus0,RDonAFR,RSonAFR,AdrOnDataBus,AluOnDataBus,IRonLOperandBus,IRonHOperandBus,RSonOperandBus,Shadow,CFlag,ZFlag,InstructionCode);
	
end architecture RTL;