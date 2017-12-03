------------------------------------------------
--Tests for Logic Gates
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_logic_gates is
end entity TB_logic_gates;

architecture TB of TB_logic_gates is

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

   signal X, Y, O_OR, O_AND : std_logic;

begin
   and_gate_test : and_gate port map (X, Y, O_AND);
	or_gate_test : or_gate port map (X, Y, O_OR);

   process 
   begin
      X <= '0';
      Y <= '0';
      wait for 10 ns;
      assert (O_OR = '0') report "OR 0, 0 is not 1" severity failure;
      assert (O_AND = '0') report "And 0, 0 is not 0" severity failure;

      X <= '0';
      Y <= '1';
      wait for 10 ns;
      assert (O_OR = '1') report "OR 0, 1 is not 1" severity failure;
      assert (O_AND = '0') report "And 0, 1 is not 0" severity failure;

      X <= '1';
      Y <= '0';
      wait for 10 ns;
      assert (O_OR = '1') report "OR 1, 0 is not 1" severity failure;
      assert (O_AND = '0') report "And 1, 0 is not 0" severity failure;

      X <= '1';
      Y <= '1';
      wait for 10 ns;
      assert (O_OR = '1') report "OR 1, 1 is not 1" severity failure;
      assert (O_AND = '1') report "And 1, 1 is not 1" severity failure;

		stop(0);
   end process;
end TB;
