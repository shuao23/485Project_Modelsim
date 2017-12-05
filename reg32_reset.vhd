------------------------------------------------
--32 Bit register with reset
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg32_reset is
   port(
      clk, reset, set : in std_logic;
      D : in std_logic_vector (31 downto 0);
      Q : out std_logic_vector (31 downto 0)
   );
end entity reg32_reset;

architecture behav of reg32_reset is

   signal stored_data : std_logic_vector (31 downto 0) := (others => '0');

begin
   Q <= stored_data;

   storage : process(clk, reset)
   begin
      if(reset = '1') then
         stored_data <= (others => '0');
      elsif(clk'event and clk = '1' and reset = '0' and set = '1') then
         stored_data <= D;
      end if;
   end process;

end architecture behav;
