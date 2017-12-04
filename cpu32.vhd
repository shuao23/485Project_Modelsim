------------------------------------------------
--Main CPU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu32 is
   port(
      clk : in std_logic;
      mem_rddat : in std_logic_vector (31 downto 0);
      mem_wr, mem_rd : out std_logic;
      addr, mem_wrdat : out std_logic_vector (31 downto 0)
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

   component not_gate is
      port(
         i : in std_logic;
         o : out std_logic
      );
   end component not_gate;

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
   component mux2_1 is
      port(
         s, i0, i1 : in std_logic;
         o : out std_logic
      );
   end component mux2_1;

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
      port (
         ffield	: in 	std_logic_vector(5 downto 0);
         AluOP		: in 	std_logic_vector(2 downto 0);
         ALUCon	: out std_logic_vector(3 downto 0)
      );
   end component;

   component control_logic is
   	port
   	(
   		opcode 		: in std_logic_vector(5 downto 0);
   		state_in		: in std_logic_vector(3 downto 0);
   		state_out	: out std_logic_vector(3 downto 0);
   		AluSrcB		: out std_logic_vector(1 downto 0);
   		AluOP			: out std_logic_vector(2 downto 0);
   		PCSource		: out std_logic_vector(1 downto 0);
   		PCWrite 		: out std_logic;
   		PCWriteCond : out std_logic;
   		BranchCond	: out std_logic;
   		AluSrcA 		: out std_logic;
   		lorD 			: out std_logic;
   		IRWrite 		: out std_logic;
   		memRead 		: out std_logic;
   		memWrite 	: out std_logic;
   		MemtoReg		: out std_logic;
   		RegWrite		: out std_logic;
   		RegDst 		: out std_logic
   	);
   end component;


-----------------------------------------------------------------
--Singals
-----------------------------------------------------------------
   --For Clocks
   signal clk_pc, clk_ir, clk_reg : std_logic;
   signal logic_clock : std_logic;

   --From simple logic
   signal or_pcwr, and_pcwr, not_zero : std_logic;
   signal sl_inst28, sl_inst32, sl_imm, se_imm : std_logic_vector (31 downto 0);

   --From registers
   signal inst_o, mdr_o, pc_o, a_o, b_o, state_o,
      aluout_o, rddat1, rddat2 : std_logic_vector (31 downto 0);

   --From ALU
   signal zero :std_logic;
   signal result : std_logic_vector (31 downto 0);

   --From muxes
   signal BCond_o : std_logic;
   signal MemToReg_o, RegDst_o32, SrcA_o,
      SrcB_o, PCSrc_o : std_logic_vector (31 downto 0);
   signal RegDst_i0, RegDst_i1 : std_logic_vector (31 downto 0);

   --From ALU Control Unit
   signal ALUCon : std_logic_vector (3 downto 0);

   --From Control Unit
   signal nxtState_out4 : std_logic_vector (3 downto 0) := (others => '0');
   signal nxtState_out32 : std_logic_vector (31 downto 0) := (others => '0');
   signal AluSrcB, PCSource : std_logic_vector (1 downto 0) := (others => '0');
   signal AluOP : std_logic_vector (2 downto 0) := (others => '0');
   signal PCWrite, PCWriteCond, BranchCond, AluSrcA, IorD, IRWrite, memRead,
   memWrite, MemtoReg, RegWrite, RegDst : std_logic := '0';

begin
   andclk_pc : and_gate port map (clk, or_pcwr, clk_pc);
   andclk_memr : and_gate port map (clk, memRead, mem_rd);
   andclk_memw : and_gate port map (clk, memWrite, mem_wr);
   andclk_ir : and_gate port map (clk, IRWrite, clk_ir);
   andclk_reg : and_gate port map (clk, RegWrite, clk_reg);

   and_pcwritecond : and_gate port map (PCWriteCond, BCond_o, and_pcwr);
   or_pcwritecond : or_gate port map (and_pcwr, PCWrite, or_pcwr);
   not_zero_gate : not_gate port map (zero, not_zero);

   shiftLeft_inst : sll2_32 port map (inst_o, sl_inst28);
   shiftLeft_imm : sll2_32 port map (se_imm, sl_imm);
   extend : bitextend16_32 port map (inst_o(15 downto 0), se_imm);

   registers : registers_32 port map (
      clk_reg, inst_o(25 downto 21), inst_o(20 downto 16),
      RegDst_o32(4 downto 0), MemToReg_o, rddat1, rddat2);

   reg32_inst : reg32 port map (clk_ir, mem_rddat, inst_o);
   reg32_mdr : reg32 port map (clk, mem_rddat, mdr_o);
   reg32_pc : reg32 port map (clk_pc, PCSrc_o, pc_o);
   reg32_a : reg32 port map (clk, rddat1, a_o);
   reg32_b : reg32 port map (clk, rddat2, b_o);
   reg32_state : reg32 port map (logic_clock, nxtState_out32, state_o);
   reg32_aluout : reg32 port map (clk, result, aluout_o);

   mux_IorD : mux2_32 port map (IorD, pc_o, aluout_o, addr);
   mux_RegDst : mux2_32 port map (RegDst, RegDst_i0, RegDst_i1, RegDst_o32);
   mux_MemToReg : mux2_32 port map (MemtoReg, result, mdr_o);
   mux_SrcA : mux2_32 port map (AluSrcA, pc_o, a_o, SrcA_o);
   mux_SrcB : mux4_32 port map (AluSrcB, b_o, x"00000004", se_imm, sl_imm, SrcB_o);
   mux_PCSrc : mux4_32 port map (PCSource, result, aluout_o, sl_inst32, x"00000000", PCSrc_o);
   mux_BCond : mux2_1 port map (BranchCond, zero, not_zero, BCond_o);

   alu : alu32 port map (SrcA_o, SrcB_o, ALUCon, zero, open, open, result);
   alucontrol : alu_control port map (inst_o(5 downto 0), AluOP, ALUCon);

   unitcontrol : control_logic port map (
      inst_o(31 downto 26), state_o(3 downto 0), nxtState_out4,
      AluSrcB, AluOP, PCSource, PCWrite, PCWriteCond, BranchCond,
      AluSrcA, IorD, IRWrite, memRead, memWrite, MemtoReg, RegWrite, RegDst
   );

   --Wire remapping
   sl_inst32 <= pc_o(31 downto 28) & sl_inst28(27 downto 0);
   nxtState_out32 <= x"0000000" & nxtState_out4;
   mem_wrdat <= b_o;
   RegDst_i0 <= x"000000" & "000" & inst_o(20 downto 16);
   RegDst_i1 <= x"000000" & "000" & inst_o(15 downto 11);
   logic_clock <= clk after 10 ns;



end architecture behav;
