------------------------------------------------
--32 bit mux with 32 inputs
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux32_32 is
   port(
      s : in std_logic_vector (4 downto 0);
      i0, i1, i2, i3, i4,
      i5, i6, i7, i8, i9,
      i10, i11, i12, i13, i14,
      i15, i16, i17, i18, i19,
      i20, i21, i22, i23, i24,
      i25, i26, i27, i28, i29,
      i30, i31 : in std_logic_vector (31 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity mux32_32;

architecture behav of mux32_32 is

   component mux4_32 is
      port(
         s : in std_logic_vector (1 downto 0);
         i0, i1, i2, i3 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux4_32;

   component mux8_32 is
      port(
         s : in std_logic_vector (2 downto 0);
         i0, i1, i2, i3, i4,
         i5, i6, i7 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux8_32;

   signal MUX8_OUT1 : std_logic_vector (31 downto 0);
   signal MUX8_OUT2 : std_logic_vector (31 downto 0);
   signal MUX8_OUT3 : std_logic_vector (31 downto 0);
   signal MUX8_OUT4 : std_logic_vector (31 downto 0);

begin
   mux8_first : mux8_32 port map (s(2 downto 0), i0, i1, i2, i3, i4, i5, i6, i7, MUX8_OUT1);
   mux8_second : mux8_32 port map (s(2 downto 0), i8, i9, i10, i11, i12, i13, i14, i15, MUX8_OUT2);
   mux8_third : mux8_32 port map (s(2 downto 0), i16, i17, i18, i19, i20, i21, i22, i23, MUX8_OUT3);
   mux8_fourth : mux8_32 port map (s(2 downto 0), i24, i25, i26, i27, i28, i29, i30, i31, MUX8_OUT4);
   mux4_merge : mux4_32 port map (s(4 downto 3), MUX8_OUT1, MUX8_OUT2, MUX8_OUT3, MUX8_OUT4, o);
end architecture behav;
