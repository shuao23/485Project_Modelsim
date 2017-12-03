------------------------------------------------
--Or Gate
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity or_gate is
   port(
      x, y : in std_logic;
      o : out std_logic
   );
end entity or_gate;

architecture behav of or_gate is
begin
   o <= x or y;
end behav;