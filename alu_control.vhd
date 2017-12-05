library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control is
	port (
		-- function field
		ffield	: in 	std_logic_vector(5 downto 0);
		AluOP		: in 	std_logic_vector(2 downto 0);
		ALUCon	: out std_logic_vector(3 downto 0)
	);
end entity;

architecture behav of alu_control is
	constant add_ffield : std_logic_vector(5 downto 0) := "100000";
	constant sub_ffield : std_logic_vector(5 downto 0) := "100010";
	constant AND_ffield : std_logic_vector(5 downto 0) := "100100";
	constant OR_ffield  : std_logic_vector(5 downto 0) := "100101";
	constant NOR_ffield : std_logic_vector(5 downto 0) := "100111";
	constant slt_ffield : std_logic_vector(5 downto 0) := "101010";

begin
	process(ffield, AluOP)
	begin
		case AluOP is
			-- lw and sw
			when "000" =>
				ALUCon <= "0010";

			-- beq and bne
			when "001" =>
				ALUCon <= "0110";

			-- ADDI
			when "100" =>
				ALUCon <= "0010";

			-- ANDI
			when "101" =>
				ALUCon <= "0000";

			-- ORI
			when "110" =>
				ALUCon <= "0001";

			-- R-type
			when "010" =>
				-- add
				if ffield = add_ffield then
					ALUCon <= "0010";

				-- sub
				elsif ffield = sub_ffield then
					ALUCon <= "0110";

				-- AND
				elsif ffield = AND_ffield then
					ALUCon <= "0000";

				-- OR
				elsif ffield = OR_ffield then
					ALUCon <= "0001";

				-- NOR
				elsif ffield = NOR_ffield then
					ALUCon <= "1100";

				-- slt
				elsif ffield = slt_ffield then
					ALUCon <= "0111";

				end if;

			when others =>
				ALUCon <= (others => 'X');
		end case;
	end process;
end behav;
