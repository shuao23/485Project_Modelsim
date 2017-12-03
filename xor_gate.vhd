------------------------------------------------
--XOR Gate
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_gate is
   port(
      x, y : in std_logic;
      o : out std_logic
   );
end entity xor_gate;

architecture behav of xor_gate is
begin
   o <= x xor y;
end behav;
