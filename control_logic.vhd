library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_logic is
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
end entity;

architecture behav of control_logic is
	constant S0 	: std_logic_vector(3 downto 0) := "0000";
	constant S1 	: std_logic_vector(3 downto 0) := "0001";
	constant S2 	: std_logic_vector(3 downto 0) := "0010";
	constant S3 	: std_logic_vector(3 downto 0) := "0011";
	constant S4 	: std_logic_vector(3 downto 0) := "0100";
	constant S5 	: std_logic_vector(3 downto 0) := "0101";
	constant S6 	: std_logic_vector(3 downto 0) := "0110";
	constant S7 	: std_logic_vector(3 downto 0) := "0111";
	constant S8 	: std_logic_vector(3 downto 0) := "1000";
	constant S9 	: std_logic_vector(3 downto 0) := "1001";
	constant S10 	: std_logic_vector(3 downto 0) := "1010";
	constant S11 	: std_logic_vector(3 downto 0) := "1011";
	constant S12 	: std_logic_vector(3 downto 0) := "1100";
	constant S13 	: std_logic_vector(3 downto 0) := "1101";
	constant S14 	: std_logic_vector(3 downto 0) := "1110";
	constant lw 	: std_logic_vector(5 downto 0) := "100011";
	constant sw 	: std_logic_vector(5 downto 0) := "101011";
	constant Rtype : std_logic_vector(5 downto 0) := "000000";
	constant BEQ 	: std_logic_vector(5 downto 0) := "000100";
	constant BNE	: std_logic_vector(5 downto 0) := "000101";
	constant jump 	: std_logic_vector(5 downto 0) := "000010";
	constant ADDI	: std_logic_vector(5 downto 0) := "001000";
	constant ANDI	: std_logic_vector(5 downto 0) := "001100";
	constant ORI	: std_logic_vector(5 downto 0) := "001101";

begin
	current_state : process(state_in)
	begin
		--Reset read/write lines
		PCWrite <= '0';
		PCWriteCond <= '0';
		IRWrite <= '0';
		memRead <= '0';
		memWrite <= '0';
		RegWrite <= '0';

		case state_in is
			when S0 =>
				memRead <= '1';
				AluSrcA	<= '0';
				lorD 	<= '0';
				IRWrite <= '1';
				AluSrcB	<= "01";
				AluOp	<= "000";
				PCWrite	<= '1';
				PCSource <= "00";
				state_out <= S1;

			when S1 =>
				AluSrcA	<= '0';
				AluSrcB	<= "11";
				AluOp	<= "000";

				if opcode = lw then
					state_out <= S2;

				elsif opcode = sw then
					state_out <= S2;

				elsif opcode = Rtype then
					state_out <= S6;

				elsif opcode = BEQ then
					state_out <= S8;

				elsif opcode = BNE then
					state_out <= S9;

				elsif opcode = jump then
					state_out <= S10;

				elsif opcode = ADDI then
					state_out <= S11;

				elsif opcode = ANDI then
					state_out <= S12;

				elsif opcode = ORI then
					state_out <= S13;
				else
					state_out <= S0;
				end if;

			when S2 =>
				AluSrcA	<= '1';
				AluSrcB	<= "10";
				AluOp		<= "000";

				if opcode = lw then
					state_out <= S3;

				elsif opcode = sw then
					state_out <= S5;
				end if;

			when S3 =>
				memRead 	<= '1';
				lorD <= '1';
				state_out 	<= S4;

			when S4 =>
				RegDst 	<= '0';
				RegWrite <= '1';
				MemtoReg	<= '1';
				state_out 	<= S0;

			when S5 =>
				memWrite <= '1';
				lorD <= '1';
				state_out 	<= S0;

			when S6 =>
				AluSrcA 	<= '1';
				AluSrcB 	<= "00";
				ALUOP 	<= "010";
				state_out	<= S7;

			when S7 =>
				RegDst 		<= '1';
				RegWrite 	<= '1';
				MemtoReg	 	<= '0';
				state_out	<= S0;

			when S8 =>
				AluSrcA 		<= '1';
				AluSrcB 		<= "00";
				AluOp			<= "001";
				PCWriteCond <= '1';
				PCSource 	<= "01";
				BranchCond 	<= '0';
				state_out 	<= S0;

			when S9 =>
				AluSrcA 		<= '1';
				AluSrcB 		<= "00";
				AluOp			<= "001";
				PCWriteCond <= '1';
				PCSource 	<= "01";
				BranchCond 	<= '1';
				state_out 	<= S0;

			when S10 =>
				PCWrite 		<= '1';
				PCSource 	<= "10";
				state_out	<= S0;

			when S11 =>
				ALUSrcA 		<= '1';
				ALUSrcB 		<= "10";
				ALUOP 		<= "100";
				state_out	<= S14;

			when S12 =>
				ALUSrcA 		<= '1';
				ALUSrcB 		<= "10";
				ALUOP 		<= "101";
				state_out	<= S14;

			when S13 =>
				ALUSrcA 		<= '1';
				ALUSrcB 		<= "10";
				ALUOP 		<= "110";
				state_out	<= S14;

			when S14 =>
				RegDst 		<= '0';
				RegWrite		<= '1';
				MemtoReg		<= '0';
				state_out	<= S0;

			when others =>
				state_out <= S0;

		end case;
	end process;
end behav;
