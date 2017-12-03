------------------------------------------------
--1 bit mux with 4 input
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4_1 is
   port(
      s : in std_logic_vector (1 downto 0);
      i0, i1, i2, i3 : in std_logic;
      o : out std_logic
   );
end entity mux4_1;

architecture behav of mux4_1 is
begin
   with s select o <=
      i0 when "00",
      i1 when "01",
      i2 when "10",
      i3 when "11",
		'U' when others;
end architecture behav;
