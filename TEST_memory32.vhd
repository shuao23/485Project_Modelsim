------------------------------------------------
--Tests for memory32
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity TB_memory32 is
end entity TB_memory32;

architecture TB of TB_memory32 is

   component memory32 is
      generic(size : natural := 256);
      port(
         wrln, rdln : in std_logic;
         adr, wrdat : in std_logic_vector (31 downto 0);
         rddat : out std_logic_vector (31 downto 0)
      );
   end component memory32;

   --CLOCK
   constant CLK_PERIOD : time := 100 ns;
   signal CLK : std_logic := '0';

   signal WRLN, RDLN : std_logic := '0';
   signal ADR, WRDAT, RDDAT : std_logic_vector (31 downto 0) := (others => '0');


begin

   memory32_test : memory32 port map (WRLN, RDLN, ADR, WRDAT, RDDAT);

   clk_process : process
   begin
      CLK <= '0';
      wait for CLK_PERIOD / 2;
      CLK <= '1';
      wait for CLK_PERIOD / 2;
   end process;

   tst_process : process
      file test_file : text;
      variable line_content : line;
      variable content : std_logic_vector(31 downto 0);
      variable x : natural := 0;
   begin
      --Writing data to memory
      x := 0;
      WRLN <= '0';
      file_open(test_file, "test.txt", read_mode);
      while not endfile(test_file) loop
         wait until CLK'event and CLK = '1';
         readline(test_file, line_content);
         read(line_content, content);
         ADR <= std_logic_vector(to_unsigned(x * 4, 32));
         WRDAT <= content;
         x := x + 1;
         WRLN <= '1';
         wait for 10 ns;
         WRLN <= '0';

      end loop;
		file_close(test_file);

      --Reading data from memory
      x := 0;
      RDLN <= '0';
      file_open(test_file, "test.txt", read_mode);
      while not endfile(test_file) loop
         wait until CLK'event and CLK = '1';
         readline(test_file, line_content);
         read(line_content, content);
         ADR <= std_logic_vector(to_unsigned(x * 4, 32));
         x := x + 1;
         RDLN <= '1';
         wait for 10 ns;
         assert (RDDAT = content)
            report "Reading or Writing failed"
            severity failure;
         RDLN <= '0';
      end loop;
      file_close(test_file);
		stop(0);
   end process;

end architecture;
