------------------------------------------------
--32 bit mux with 8 inputs
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8_32 is
   port(
      s : in std_logic_vector (2 downto 0);
      i0, i1, i2, i3, i4,
      i5, i6, i7 : in std_logic_vector (31 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity mux8_32;

architecture behav of mux8_32 is

   component mux2_32 is
      port(
         s : in std_logic;
         i0, i1 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux2_32;

   component mux4_32 is
      port(
         s : in std_logic_vector (1 downto 0);
         i0, i1, i2, i3 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux4_32;

   signal first_out : std_logic_vector (31 downto 0);
   signal second_out : std_logic_vector (31 downto 0);

begin
   mux4_first : mux4_32 port map (s(1 downto 0), i0, i1, i2, i3, first_out);
   mux4_second : mux4_32 port map (s(1 downto 0), i4, i5, i6, i7, second_out);
   mux2_merge : mux2_32 port map (s(2), first_out, second_out, o);
end architecture behav;
