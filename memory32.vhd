------------------------------------------------
--32 Bit register
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory32 is
   generic(size : natural := 256);
   port(
      wrln, rdln : in std_logic;
      adr, wrdat : in std_logic_vector (31 downto 0);
      rddat : out std_logic_vector (31 downto 0)
   );
end entity memory32;

architecture behav of memory32 is

   type std_logic_vector_arr is array (0 to size) of std_logic_vector (31 downto 0);

   signal MEM : std_logic_vector_arr := (others => (others => '0'));

begin

   mem_write : process(wrln)
   begin
      if(wrln'event and wrln = '1') then
         MEM(to_integer(unsigned(adr))) <= wrdat;
      end if;
   end process;

   mem_read : process(rdln)
   begin
      if(rdln'event and rdln = '1') then
         rddat <= MEM(to_integer(unsigned(adr)));
      end if;
   end process;

end architecture behav;
