------------------------------------------------
--1 Bit flip flop
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflop is
   port(
      clk, D : in std_logic;
      Q : out std_logic
   );
end entity flipflop;

architecture behav of flipflop is

   signal stored_data : std_logic := '0';

begin
   Q <= stored_data;

   storage : process(clk)
   begin
      if(clk'event and clk = '1') then
         stored_data <= D;
      end if;
   end process;

end architecture;
