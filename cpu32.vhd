------------------------------------------------
--Main CPU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu32 is
   port(
      clk : in std_logic;
      rddat : in std_logic_vector (31 downto 0);
      mem_wr, mem_rd : out std_logic;
      addr, wrdat : out std_logic_vector (31 downto 0)
   );
end entity cpu32;

architecture behav of cpu32 is
-----------------------------------------------------------------
--Components
-----------------------------------------------------------------
   --Basic Components
   component and_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component and_gate;

   component or_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component or_gate;

   component sll2_32 is
      port(
         i : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component sll2_32;

   component bitextend16_32 is
      port(
         i : in std_logic_vector (15 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component bitextend16_32;

   --Registers
   component registers_32 is
      port(
         clk : in std_logic;
         rdnum1, rdnum2, wrnum : in std_logic_vector (4 downto 0);
         wrdat : in std_logic_vector (31 downto 0);
         rddat1, rddat2 : out std_logic_vector (31 downto 0)
      );
   end component registers_32;

   component reg32 is
      port(
         clk : in std_logic;
         D : in std_logic_vector (31 downto 0);
         Q : out std_logic_vector (31 downto 0)
      );
   end component reg32;

   --MUXes
   component mux2_32 is
      port(
         s : in std_logic;
         i0, i1 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux2_32;

   component mux4_32 is
      port(
         s : in std_logic_vector (1 downto 0);
         i0, i1, i2, i3 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux4_32;

  --ALU
   component alu32 is
      port(
         a, b : in std_logic_vector (31 downto 0);
         op : in std_logic_vector (3 downto 0);
         zero, oflow, carry_out : out std_logic;
         o : out std_logic_vector (31 downto 0));
   end component alu32;

   --Control
   component alu_control is
   	port
   	(
   		ffield	: in 	std_logic_vector(5 downto 0);
   		AluOP		: in 	std_logic_vector(1 downto 0);
   		ALUCon	: out std_logic_vector(3 downto 0)
   	);
   end component;

   component control_logic is
   	port
   	(
   		opcode 		: in  std_logic_vector(5 downto 0);
   		clk	 		: in  std_logic;
   		state_in		: in std_logic_vector(3 downto 0);
   		state_out	: out std_logic_vector(3 downto 0);
   		AluSrcB		: out std_logic_vector(1 downto 0);
   		AluOP			: out std_logic_vector(1 downto 0);
   		PCWrite 		: out std_logic_vector(1 downto 0);
   		PCWriteCond : out std_logic_vector(1 downto 0);
   		AluSrcA 		: out std_logic;
   		lorD 			: out std_logic;
   		memRead 		: out std_logic;
   		memWrite 	: out std_logic;
   		MemtoReg		: out std_logic;
   		RegDst 		: out std_logic
   	);
   end component;


-----------------------------------------------------------------
--Singals
-----------------------------------------------------------------
   --From simple logic

   --From registers
   signal inst_o, mdr_o, pc_o, a_o, b_o, aluout_o : std_logic_vector (31 downto 0);

   --From main registers
   signal rddat1, rddat2 : std_logic_vector (31 downto 0);

   --From ALU
   signal zero :std_logic;
   signal result : std_logic_vector (31 downto 0);

   --From muxes
   signal iord_o, reg

   --From ALU Control Unit

   --From Control Unit

begin

   registers : registers_32 port map (???, );

end architecture behav;
