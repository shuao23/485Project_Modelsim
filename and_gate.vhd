------------------------------------------------
--And Gate
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_gate is
   port(
      x, y : in std_logic;
      o : out std_logic
   );
end entity and_gate;

architecture behav of and_gate is
begin
   o <= x and y;
end behav;
