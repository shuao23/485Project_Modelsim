------------------------------------------------
--Or Gate
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity or32_gate is
   port(
      i : in std_logic_vector (31 downto 0);
      o : out std_logic
   );
end entity or32_gate;

architecture behav of or32_gate is
begin
   process(i)
   variable tmp : std_logic;
   begin
      tmp := '0';
      for x in 0 to 31 loop
         tmp := tmp or i(x);
      end loop;
      o <= tmp;
   end process;
end behav;
