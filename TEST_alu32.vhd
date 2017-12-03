------------------------------------------------
--Tests 32 bit ALU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_alu32 is
end entity TB_alu32;

architecture TB of TB_alu32 is
   component alu32 is
      port(
         a, b : in std_logic_vector (31 downto 0);
         op : in std_logic_vector (3 downto 0);
         zero, oflow, carry_out : out std_logic;
         o : out std_logic_vector (31 downto 0));
   end component alu32;

   signal a, b, o : std_logic_vector (31 downto 0);
   signal op : std_logic_vector (3 downto 0);
   signal zero, oflow, carry_out : std_logic;

begin

   alu32_test : alu32 port map (a, b, op, zero, oflow, carry_out, o);

   tst_process : process
   begin
      --Testing and gate
      a <= x"FFFFAA00";
      b <= x"DC555555";
      op <= "0000";
      wait for 10 ns;
      assert (o = x"DC550000")
         report "And op wrong output"
         severity failure;

      --Testing or gate
      a <= x"AAFFAA00";
      b <= x"DC555555";
      op <= "0001";
      wait for 10 ns;
      assert (o = x"FEFFFF55")
         report "or op wrong output"
         severity failure;

      --Testing A invert gate through or gate
      a <= x"AAAAAAAA";
      b <= x"00000000";
      op <= "1001";
      wait for 10 ns;
      assert (o = x"55555555")
         report "invert A wrong output"
         severity failure;

      --Testing B invert gate through or gate
      a <= x"00000000";
      b <= x"AAAAAAAA";
      op <= "0101";
      wait for 10 ns;
      assert (o = x"55555555")
         report "invert B wrong output"
         severity failure;

      --Testing Adding
      a <= x"01491C67";
      b <= x"5D7C44DE";
      op <= "0010";
      wait for 10 ns;
      assert (o = x"5EC56145" and zero = '0' and oflow = '0')
         report "Adding wrong output"
         severity failure;

      --Testing subtracting
      a <= x"5EC56145";
      b <= x"5D7C44DE";
      op <= "0110";
      wait for 10 ns;
      assert (o = x"01491C67" and zero = '0' and oflow = '0')
         report "subtracting wrong output"
         severity failure;

      --Testing zero
      a <= x"5EC56145";
      b <= x"5EC56145";
      op <= "0110";
      wait for 10 ns;
      assert (o = x"00000000" and zero = '1' and oflow = '0')
         report "zero wrong output"
         severity failure;

      --Testing Overflow
      a <= x"5EC56145";
      b <= x"7A176C12";
      op <= "0010";
      wait for 10 ns;
      assert (o = x"D8DCCD57" and zero = '0' and oflow = '1')
         report "Overflow wrong output"
         severity failure;
      a <= x"7FFFFFFF";
      b <= x"80000001";
      op <= "0110";
      wait for 10 ns;
      assert (o = x"FFFFFFFE" and zero = '0' and oflow = '1')
         report "Overflow wrong output"
         severity failure;

      --Testing Underflow
      a <= x"9A984D12";
      b <= x"7A176C12";
      op <= "0110";
      wait for 10 ns;
      assert (o = x"2080E100" and zero = '0' and oflow = '1')
         report "Underflow wrong output"
         severity failure;
      a <= x"80000001";
      b <= x"80000001";
      op <= "0010";
      wait for 10 ns;
      assert (o = x"00000002" and zero = '0' and oflow = '1')
         report "Underflow wrong output"
         severity failure;

      --Testing set pos, pos
      a <= x"00000005";
      b <= x"00000002";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000000")
         report "Set less than wrong output"
         severity failure;
      a <= x"00000002";
      b <= x"00000005";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000001")
         report "Set less than wrong output"
         severity failure;

      --Testing set pos, neg
      a <= x"FFFFFFFB";
      b <= x"00000002";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000001")
         report "Set less than wrong output"
         severity failure;
      a <= x"00000002";
      b <= x"FFFFFFFB";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000000")
         report "Set less than wrong output"
         severity failure;

      --Testing set neg, neg
      a <= x"FFFFFFFB";
      b <= x"FFFFFFFE";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000001")
         report "Set less than wrong output"
         severity failure;
      a <= x"FFFFFFFE";
      b <= x"FFFFFFFB";
      op <= "0111";
      wait for 10 ns;
      assert (o = x"00000000")
         report "Set less than wrong output"
         severity failure;

      stop(0);
   end process;
end architecture TB;
