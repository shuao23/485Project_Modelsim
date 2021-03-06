------------------------------------------------
--Tests for Muxes
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity cpu32_testbench is
end entity cpu32_testbench;

architecture TB of cpu32_testbench is

   component memory32 is
      generic(size : natural := 256);
      port(
         wrln, rdln : in std_logic;
         adr, wrdat : in std_logic_vector (31 downto 0);
         rddat : out std_logic_vector (31 downto 0)
      );
   end component memory32;

   component cpu32 is
      port(
         clk, reset : in std_logic;
         mem_rddat : in std_logic_vector (31 downto 0);
         mem_wr, mem_rd : out std_logic;
         addr, mem_wrdat : out std_logic_vector (31 downto 0)
      );
   end component cpu32;


   signal mem_rddat, addr, mem_wrdat : std_logic_vector (31 downto 0) := (others => '0');
   signal mem_wr, mem_rd, clk, reset : std_logic := '0';

   constant CLK_PERIOD : time := 100 ns;
   signal clock_enable : std_logic := '0';

   --For setting up memory32
   signal init : std_logic := '1';
   signal mem_wr_cpu, mem_wr_debug, mem_wr_bus : std_logic := '0';
   signal mem_rd_cpu, mem_rd_debug, mem_rd_bus : std_logic := '0';
   signal cpuToMem_d, debugToMem_d, memBus_d : std_logic_vector (31 downto 0) := (others =>'0');
   signal cpuToMem_a, debugToMem_a, memBus_a : std_logic_vector (31 downto 0) := (others =>'0');

begin

   memory32_test : memory32 port map (mem_wr_bus, mem_rd_bus, memBus_a, memBus_d, mem_rddat);
   cpu32_test : cpu32 port map (clk, reset, mem_rddat, mem_wr_cpu, mem_rd_cpu, cpuToMem_a, cpuToMem_d);

   with init select memBus_a <=
      cpuToMem_a when '0',
      debugToMem_a when others;
   with init select memBus_d <=
      cpuToMem_d when '0',
      debugToMem_d when others;
   with init select mem_wr_bus <=
      mem_wr_cpu when '0',
      mem_wr_debug when others;
   with init select mem_rd_bus <=
      mem_rd_cpu when '0',
      mem_rd_debug when others;

   clk_process : process
   begin
      if(clock_enable = '0') then
         wait until clock_enable = '1';
      end if;
         clk <= '0';
         wait for CLK_PERIOD / 2;

         if(clock_enable = '1') then
            clk <= '1';
            wait for CLK_PERIOD / 2;
         end if;
   end process clk_process;

   tst_process : process
      file mem_file : text;
      variable line_content : line;
      variable content : std_logic_vector(31 downto 0);
      variable x : natural := 0;
   begin
      --Load data into memory
      reset <= '1';
      x := 0;
      mem_wr_debug <= '0';
      file_open(mem_file, "memory.txt", read_mode);
      while not endfile(mem_file) loop
         readline(mem_file, line_content);
         read(line_content, content);
         debugToMem_a <= std_logic_vector(to_unsigned(x * 4, 32));
         debugToMem_d <= content;
         x := x + 1;
         mem_wr_debug <= '1';
         wait for 10 ns;
         mem_wr_debug <= '0';
         wait for 10 ns;
      end loop;
      file_close(mem_file);

      --Initialize cpu and clock
      clock_enable <= '1';
      wait for 200 ns;
      init <= '0';
      reset <= '0';
      wait;
   end process tst_process;

end architecture TB;
