------------------------------------------------
--Tests for Bit extender
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_bitextend16_32 is
end entity TB_bitextend16_32;

architecture behav of TB_bitextend16_32 is

   component bitextend16_32 is
      port(
         i : in std_logic_vector (15 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component bitextend16_32;

   signal I : std_logic_vector (15 downto 0);
   signal O : std_logic_vector (31 downto 0);

begin

   bitextend16_32_test : bitextend16_32 port map (I, O);

   process
   begin

      I <= x"FFFF";
      wait for 10 ns;
      assert(O = x"FFFFFFFF")
         report "Shifting failed"
         severity failure;

      I <= x"7FFF";
      wait for 10 ns;
      assert(O = x"00007FFF")
         report "Shifting failed"
         severity failure;

      stop(0);
   end process;

end architecture behav;
