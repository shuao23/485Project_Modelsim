------------------------------------------------
--32 bit mux with 2 input
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2_32 is
   port(
      s : in std_logic;
      i0, i1 : in std_logic_vector (31 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity mux2_32;

architecture behav of mux2_32 is

begin
   with s select o <=
      i0 when '0',
      i1 when '1',
		(others => 'U') when others;
end architecture behav;
