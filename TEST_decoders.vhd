------------------------------------------------
--Tests for Decoders
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library std;
use std.env.all;

entity TB_decoders is
end entity TB_decoders;

architecture TB of TB_decoders is

   component decoder_32 is
      port(
         i : in std_logic_vector (4 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component decoder_32;

   --CLOCK
   constant CLK_PERIOD : time := 100 ns;
   signal CLK : std_logic := '0';

   signal I : std_logic_vector (4 downto 0) := (others => '0');
   signal O : std_logic_vector (31 downto 0);

begin

   decoder_32_test : decoder_32 port map (I, O);

   clk_process : process
   begin
      CLK <= '0';
      wait for CLK_PERIOD/2;
      CLK <= '1';
      wait for CLK_PERIOD/2;
   end process;

   process
   begin
      for x in 0 to 31 loop
         wait until CLK'event and CLK = '1';
         I <= std_logic_vector(to_unsigned(x, 5));
         wait for 10 ns;
         if(x /= 31) then
            assert (O = std_logic_vector(to_unsigned(2 ** x, 32)))
               report "Invalid decoded value"
               severity failure;
         else
            assert (O = x"80000000")
               report "Invalid decoded value"
               severity failure;
         end if;
      end loop;

      stop(0);
   end process;

end architecture TB;
