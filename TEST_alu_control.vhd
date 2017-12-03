library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library std;
	use std.env.all;

--entity declaration
entity TB_alu_Control is
end TB_alu_Control;

--architecture declaration
architecture TB of TB_alu_Control is

	component alu_control
	port
	(
		ffield	: in 	std_logic_vector(5 downto 0);
		AluOP		: in 	std_logic_vector(1 downto 0);
		ALUCon	: out std_logic_vector(3 downto 0)
	);
	end component;
		-- declare input of components 
		signal ffield 	: std_logic_vector(5 downto 0) := "000000";
		signal AluOP 	: std_logic_vector(1 downto 0) := "00";

		-- declare output of components
		signal ALUCon	: std_logic_vector(3 downto 0);

begin 
	dut : alu_control port map
	(
		ffield	=> ffield,
		AluOP		=> AluOP,
		ALUCon	=> ALUCon
	);

	stimulus : process
	begin
		-- lw and sw
		AluOP <= "00";
		wait for 10 ns;
		assert(ALUCon = "0010")
			report "Not lw or sw" severity failure;

		-- beq
		AluOP <= "01";
		wait for 10 ns;
		assert(ALUCon = "0110")
			report "Not beq" severity failure;

		-- R-type
		-- add
		AluOP <= "10";
		ffield<= "100000";
		wait for 10 ns;
		assert(ALUCon = "0010")
			report "Not add" severity failure;

		-- sub
		AluOP <= "10";
		ffield<= "100010";
		wait for 10 ns;
		assert(ALUCon = "0110")
			report "Not sub" severity failure;

		-- AND
		AluOP <= "10";
		ffield<= "100100";
		wait for 10 ns;
		assert(ALUCon = "0000")
			report "Not AND" severity failure;

		-- OR
		AluOP <= "10";
		ffield<= "100101";
		wait for 10 ns;
		assert(ALUCon = "0001")
			report "Not OR" severity failure;

		-- slt
		AluOP <= "10";
		ffield<= "101010";
		wait for 10 ns;
		assert(ALUCon = "0111")
			report "Not slt" severity failure;
		stop(1);
	end process;
end architecture TB;
