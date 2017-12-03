------------------------------------------------
--5 bit Decorder
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_32 is
   port(
      i : in std_logic_vector (4 downto 0);
      o : out std_logic_vector (31 downto 0)
   );
end entity decoder_32;

architecture behav of decoder_32 is

begin
   process(i)
   begin
      o <= (others => '0');
      o(to_integer(unsigned(i))) <= '1';
   end process;
end architecture behav;
