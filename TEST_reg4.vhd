------------------------------------------------
--Tests for 4 bit register
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;

entity TB_reg4 is
end entity TB_reg4;

architecture TB of TB_reg4 is
   component reg4 is
      port(
         clk, reset : in std_logic;
         D : in std_logic_vector (3 downto 0);
         Q : out std_logic_vector (3 downto 0)
      );
   end component reg4;

   signal CLK, RESET : std_logic := '0';
   signal D, Q : std_logic_vector (3 downto 0);

   begin
      reg32_test : reg4 port map (CLK, RESET, D, Q);

      process
      begin
         wait for 10 ns;
         assert (Q = "0000") report "Register not initialized properly" severity warning;

         D <= "0001";
         CLK <= '1';

         wait for 10 ns;
         assert (Q = "0001") report "Register did not read 0001" severity failure;

         CLK <= '0';
         wait for 10 ns;
         D <= "0101";
         CLK <= '1';

         wait for 10 ns;
         assert (Q = "0101") report "Register did not read 0101" severity failure;

         CLK <= '0';
         wait for 10 ns;
         RESET <= '1';
         CLK <= '1';

         wait for 10 ns;
         assert (Q = "0000") report "Register did not read 0000" severity warning;

         CLK <= '0';
         RESET <= '0';
         wait for 10 ns;
         D <= "0101";
         CLK <= '1';

         wait for 10 ns;
         assert (Q = "0101") report "Register did not read 0101" severity failure;

         stop(0);
      end process;
end architecture TB;
