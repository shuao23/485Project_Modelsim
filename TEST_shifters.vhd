------------------------------------------------
--Tests for Shifters
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_shifters is
end entity TB_shifters;

architecture behav of TB_shifters is

   component sll2_32 is
      port(
         i : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component sll2_32;

   signal I, O : std_logic_vector (31 downto 0);

begin

   sll2_32_test : sll2_32 port map (I, O);

   process
   begin

      I <= x"2AAAAAAA";
      wait for 10 ns;
      assert(O = x"AAAAAAA8")
         report "Shifting failed"
         severity failure;

      I <= x"FFFFFFFF";
      wait for 10 ns;
      assert(O = x"FFFFFFFC")
         report "Shifting failed"
         severity failure;

      stop(0);
   end process;

end architecture behav;
