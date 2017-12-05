------------------------------------------------
--4 Bit register with reset
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg4 is
   port(
      clk, reset : in std_logic;
      D : in std_logic_vector (3 downto 0);
      Q : out std_logic_vector (3 downto 0)
   );
end entity reg4;

architecture behav of reg4 is

   signal stored_data : std_logic_vector (3 downto 0) := "0000";

begin
   Q <= stored_data;

   storage : process(clk, reset)
   begin
      if(reset = '1') then
         stored_data <= (others => '0');
      elsif(clk'event and clk = '1' and reset = '0') then
         stored_data <= D;
      end if;
   end process;

end architecture behav;
