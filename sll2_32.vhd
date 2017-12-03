------------------------------------------------
--32 Bit register
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sll2_32 is
   port(
      i : in std_logic_vector (31 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity sll2_32;

architecture behav of sll2_32 is
begin
   o <= i(29 downto 0) & "00";
end architecture behav;
