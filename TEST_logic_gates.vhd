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

   component not_gate is
      port(
         i : in std_logic;
         o : out std_logic
      );
   end component not_gate;

   component xor_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component xor_gate;

   component or32_gate is
      port(
         i : in std_logic_vector (31 downto 0);
         o : out std_logic
      );
   end component or32_gate;

   signal I : std_logic_vector (31 downto 0);
   signal X, Y, O_OR, O_XOR, O_AND, O_NOT, O_OR32 : std_logic;

begin

	or_gate_test : or_gate port map (X, Y, O_OR);
   xor_gate_test : xor_gate port map (X, Y, O_XOR);
   and_gate_test : and_gate port map (X, Y, O_AND);
   not_gate_test : not_gate port map (X, O_NOT);
   or32_gate_test : or32_gate port map (I, O_OR32);


   process
   begin
      X <= '0';
      Y <= '0';
      wait for 10 ns;
      assert (O_OR = '0') report "OR bad out" severity failure;
      assert (O_XOR = '0') report "XOR bad out" severity failure;
      assert (O_AND = '0') report "AND bad out" severity failure;
      assert (O_NOT = '1') report "NOT bad out" severity failure;

      X <= '0';
      Y <= '1';
      wait for 10 ns;
      assert (O_OR = '1') report "OR bad out" severity failure;
      assert (O_XOR = '1') report "XOR bad out" severity failure;
      assert (O_AND = '0') report "AND bad out" severity failure;

      X <= '1';
      Y <= '0';
      wait for 10 ns;
      assert (O_OR = '1') report "OR bad out" severity failure;
      assert (O_XOR = '1') report "XOR bad out" severity failure;
      assert (O_AND = '0') report "AND bad out" severity failure;
      assert (O_NOT = '0') report "NOT bad out" severity failure;

      X <= '1';
      Y <= '1';
      wait for 10 ns;
      assert (O_OR = '1') report "OR bad out" severity failure;
      assert (O_XOR = '0') report "XOR bad out" severity failure;
      assert (O_AND = '1') report "AND bad out" severity failure;

      --TESTING or32_gate
      I <= x"00000000";
      wait for 10 ns;
      assert (O_OR32 = '0') report "OR32 bad out" severity failure;

      I <= x"00000001";
      wait for 10 ns;
      assert (O_OR32 = '1') report "OR32 bad out" severity failure;

      I <= x"FFFFFFFF";
      wait for 10 ns;
      assert (O_OR32 = '1') report "OR32 bad out" severity failure;
		stop(0);
   end process;
end TB;
