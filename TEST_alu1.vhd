------------------------------------------------
--Tests 1 bit ALU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_alu1 is
end entity TB_alu1;

architecture TB of TB_alu1 is

   component alu1 is
      port(
         a, b, less, carry_in, a_invert, b_invert : in std_logic;
         op : in std_logic_vector (1 downto 0);
         o, set, oflow : out std_logic);
   end component alu1;

   signal a, b, less, carry_in, o, set, oflow : std_logic;
   signal alu_op : std_logic_vector (3 downto 0);

begin
   alu1_test : alu1 port map (a, b, less, carry_in,
      alu_op(3), alu_op(2), alu_op(1 downto 0), o, set, oflow);

   tst_process : process
      type answer_arr_type is array (0 to 7) of std_logic_vector (0 to 1);
      variable answer : answer_arr_type := (
         "00", "11", "01", "00",
         "01", "00", "10", "01"
      );
   begin
      --Testing And Gate
      alu_op <= "0000";
      a <= '0';
      b <= '0';
      wait for 10 ns;
      assert (o = '0')
         report "AND gate wrong output"
         severity failure;
      a <= '0';
      b <= '1';
      wait for 10 ns;
      assert (o = '0')
         report "AND gate wrong output"
         severity failure;
      a <= '1';
      b <= '0';
      wait for 10 ns;
      assert (o = '0')
         report "AND gate wrong output"
         severity failure;
      a <= '1';
      b <= '1';
      wait for 10 ns;
      assert (o = '1')
         report "AND gate wrong output"
         severity failure;

      --Testing OR Gate
      alu_op <= "0001";
      a <= '0';
      b <= '0';
      wait for 10 ns;
      assert (o = '0')
         report "OR gate wrong output"
         severity failure;
      a <= '0';
      b <= '1';
      wait for 10 ns;
      assert (o = '1')
         report "OR gate wrong output"
         severity failure;
      a <= '1';
      b <= '0';
      wait for 10 ns;
      assert (o = '1')
         report "OR gate wrong output"
         severity failure;
      a <= '1';
      b <= '1';
      wait for 10 ns;
      assert (o = '1')
         report "OR gate wrong output"
         severity failure;

      --Testing inverters passing through or
      alu_op <= "1001";
      a <= '0';
      b <= '0';
      wait for 10 ns;
      assert (o = '1')
         report "Inverter A wrong output"
         severity failure;
      a <= '1';
      b <= '0';
      wait for 10 ns;
      assert (o = '0')
         report "Inverter A wrong output"
         severity failure;
      alu_op <= "0101";
      a <= '0';
      b <= '0';
      wait for 10 ns;
      assert (o = '1')
         report "Inverter B wrong output"
         severity failure;
      a <= '0';
      b <= '1';
      wait for 10 ns;
      assert (o = '0')
         report "Inverter B wrong output"
         severity failure;

      --Testing adder and overflow
      alu_op <= "0010";
      for x in 0 to 7 loop
         a <= std_logic(to_unsigned(x ,3)(2));
         b <= std_logic(to_unsigned(x ,3)(1));
         carry_in <= std_logic(to_unsigned(x ,3)(0));
         wait for 10 ns;

         assert (o = answer(x)(1) and
            set = answer(x)(1) and oflow = answer(x)(0))
            report "Adder wrong output"
            severity failure;
      end loop;

      --Testing less
      alu_op <= "0011";
      less <= '0';
      wait for 10 ns;
      assert (o = '0')
         report "less wrong output"
         severity failure;
      less <= '1';
      wait for 10 ns;
      assert (o = '1')
         report "less wrong output"
         severity failure;



      stop(0);
   end process;

end architecture TB;
