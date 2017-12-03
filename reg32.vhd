------------------------------------------------
--32 Bit register
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg32 is
   port(
      clk : in std_logic;
      D : in std_logic_vector (31 downto 0);
      Q : out std_logic_vector (31 downto 0)
   );
end entity reg32;

architecture behav of reg32 is

   signal stored_data : std_logic_vector (31 downto 0) := (others => '0');

begin
   Q <= stored_data;

   storage : process(clk)
   begin
      if(clk'event and clk = '1') then
         stored_data <= D;
      end if;
   end process;

end architecture;
