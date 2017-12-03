------------------------------------------------
--Tests for 32 32 bit registers
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_registers_32 is
end entity TB_registers_32;

architecture TB of TB_registers_32 is

   component registers_32 is
      port(
         clk : in std_logic;
         rdnum1, rdnum2, wrnum : in std_logic_vector (4 downto 0);
         wrdat : in std_logic_vector (31 downto 0);
         rddat1, rddat2 : out std_logic_vector (31 downto 0)
      );
   end component registers_32;

   --CLOCK
   constant CLK_PERIOD : time := 10 ns;
   signal CLK : std_logic := '0';

   signal WRITE_CLK, WRITE_IN : std_logic := '0';
   signal RDNUM_1, RDNUM_2, WRNUM : std_logic_vector (4 downto 0) := (others => '0');
   signal WRDAT, RDDAT_1, RDDAT_2 : std_logic_vector (31 downto 0) := (others => '0');

begin

   registers_32_test : registers_32 port map (
      WRITE_CLK, RDNUM_1, RDNUM_2, WRNUM, WRDAT, RDDAT_1, RDDAT_2);

   WRITE_CLK <= CLK and WRITE_IN;

   clk_process : process
   begin
      CLK <= '0';
      wait for CLK_PERIOD / 2;
      CLK <= '1';
      wait for CLK_PERIOD / 2;
   end process;

   process
   begin
      --Testing read 1 output
      for x in 0 to 31 loop
         wait until CLK'event and CLK = '1';
         wait for 10 ns;
         WRITE_IN <= '1';
         RDNUM_1 <= std_logic_vector(to_unsigned(x, 5));
         WRNUM <= std_logic_vector(to_unsigned(x, 5));
         WRDAT <= (
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)));

         wait until CLK'event and CLK = '1';
         wait for 10 ns;
         WRITE_IN <= '0';
         assert (RDDAT_1 = std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)))
            report "Register 1 wrong"
            severity failure;
      end loop;

      --Testing read 2 output
      for x in 0 to 31 loop
         wait until CLK'event and CLK = '1';
         wait for 10 ns;
         WRITE_IN <= '1';
         RDNUM_2 <= std_logic_vector(to_unsigned(x, 5));
         WRNUM <= std_logic_vector(to_unsigned(x, 5));
         WRDAT <= (
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)) &
            std_logic_vector(to_unsigned(x, 8)));

         wait until CLK'event and CLK = '1';
         wait for 10 ns;
         WRITE_IN <= '0';
         assert (RDDAT_2 = std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)) &
                           std_logic_vector(to_unsigned(x, 8)))
            report "Register 2 wrong"
            severity failure;
      end loop;

      --Testing timing of write
      wait until CLK'event and CLK = '1';
      wait for 10 ns;
      WRITE_IN <= '1';
      RDNUM_1 <= "00000";
      RDNUM_2 <= "00001";
      WRNUM <= "00001";
      WRDAT <= x"AAAAAAAA";
      wait until CLK'event and CLK = '1';
      wait for 10 ns;
      WRITE_IN <= '1';
      WRNUM <= "00000";
      WRDAT <= x"55555555";
      wait until CLK'event and CLK = '1';
      wait for 10 ns;
      WRITE_IN <= '0';
      assert (RDDAT_1 = x"55555555" and RDDAT_2 = x"AAAAAAAA")
         report "Timing is not correct"
         severity failure;
		stop(0);
   end process;

end architecture TB;
