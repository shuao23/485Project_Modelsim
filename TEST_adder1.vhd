------------------------------------------------
--Tests for 1 bit adder
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_adder1 is
end entity TB_adder1;

architecture TB of TB_adder1 is

   component adder1 is
      port(a, b, carry_in : in std_logic;
      sum, carry_out : out std_logic);
   end component adder1;

   signal A, B, CARRY_IN, SUM, CARRY_OUT : std_logic;

begin

   adder1_test : adder1 port map (A, B, CARRY_IN, SUM, CARRY_OUT);

   tst_process : process
      type std_logic_vector_arr is array (0 to 7) of std_logic_vector (0 to 1);
      variable answer : std_logic_vector_arr := (
         "00", "01", "01", "10",
         "01", "10", "10", "11"
      );
   begin
      for x in 0 to 7 loop
         A <= std_logic(to_unsigned(x ,3)(2));
         B <= std_logic(to_unsigned(x ,3)(1));
         CARRY_IN <= std_logic(to_unsigned(x ,3)(0));
         wait for 10 ns;

         assert (SUM = answer(x)(1) and CARRY_OUT = answer(x)(0))
            report "Wrong output"
            severity failure;
      end loop;
      stop(0);
   end process;

end architecture TB;
