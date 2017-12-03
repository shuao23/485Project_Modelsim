------------------------------------------------
--1 bit mux with 2 input
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2_1 is
   port(
      s, i0, i1 : in std_logic;
      o : out std_logic
   );
end entity mux2_1;

architecture behav of mux2_1 is
begin
   with s select o <=
      i0 when '0',
      i1 when '1',
		'U' when others;
end architecture behav;
