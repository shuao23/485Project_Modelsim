library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitextend16_32 is
   port(
      i : in std_logic_vector (15 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity bitextend16_32;

architecture behav of bitextend16_32 is
begin
   o <= (31 downto 16 => i(15)) &  i;
end architecture behav;
