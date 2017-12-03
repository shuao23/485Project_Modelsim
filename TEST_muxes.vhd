------------------------------------------------
--Tests for Muxes
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.all;



entity TB_muxes is
end entity TB_muxes;

architecture TB of TB_muxes is

   component mux2_32 is
      port(
         s : in std_logic;
         i0, i1 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux2_32;

   component mux4_32 is
      port(
         s : in std_logic_vector (1 downto 0);
         i0, i1, i2, i3 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux4_32;

   component mux8_32 is
      port(
         s : in std_logic_vector (2 downto 0);
         i0, i1, i2, i3, i4,
         i5, i6, i7 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux8_32;

   component mux32_32 is
      port(
         s : in std_logic_vector (4 downto 0);
         i0, i1, i2, i3, i4,
         i5, i6, i7, i8, i9,
         i10, i11, i12, i13, i14,
         i15, i16, i17, i18, i19,
         i20, i21, i22, i23, i24,
         i25, i26, i27, i28, i29,
         i30, i31 : in std_logic_vector (31 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component mux32_32;

   --CLOCK
   constant CLK_PERIOD: time := 100 ns;
   signal CLK: std_logic := '0';

   type std_logic_vector_arr32 is array (0 to 31) of std_logic_vector(31 downto 0);

   signal MUX_IN_AR : std_logic_vector_arr32;
   signal SEL2 : std_logic;
   signal SEL4 : std_logic_vector (1 downto 0);
   signal SEL8 : std_logic_vector (2 downto 0);
   signal SEL32 : std_logic_vector (4 downto 0);
   signal O_2, O_4, O_8, O_32 : std_logic_vector (31 downto 0);


begin
   mux2_32_test : mux2_32 port map (SEL2, MUX_IN_AR(0), MUX_IN_AR(1), O_2);
	mux4_32_test : mux4_32 port map (
      SEL4, MUX_IN_AR(0), MUX_IN_AR(1), MUX_IN_AR(2), MUX_IN_AR(3), O_4);
   mux8_32_test : mux8_32 port map (
      SEL8, MUX_IN_AR(0), MUX_IN_AR(1), MUX_IN_AR(2),
      MUX_IN_AR(3), MUX_IN_AR(4), MUX_IN_AR(5), MUX_IN_AR(6), MUX_IN_AR(7), O_8);
   mux32_32_test : mux32_32 port map (
      SEL32, MUX_IN_AR(0), MUX_IN_AR(1), MUX_IN_AR(2),
      MUX_IN_AR(3), MUX_IN_AR(4), MUX_IN_AR(5), MUX_IN_AR(6), MUX_IN_AR(7),
      MUX_IN_AR(8), MUX_IN_AR(9), MUX_IN_AR(10), MUX_IN_AR(11), MUX_IN_AR(12),
      MUX_IN_AR(13), MUX_IN_AR(14), MUX_IN_AR(15), MUX_IN_AR(16), MUX_IN_AR(17),
      MUX_IN_AR(18), MUX_IN_AR(19), MUX_IN_AR(20), MUX_IN_AR(21), MUX_IN_AR(22),
      MUX_IN_AR(23), MUX_IN_AR(24), MUX_IN_AR(25), MUX_IN_AR(26), MUX_IN_AR(27),
      MUX_IN_AR(28), MUX_IN_AR(29), MUX_IN_AR(30), MUX_IN_AR(31), O_32);

   clk_process : process
   begin
      CLK <= '0';
      wait for CLK_PERIOD / 2;
      CLK <= '1';
      wait for CLK_PERIOD / 2;
   end process;

   process
   begin
      --fill the input signal table
      for x in 0 to 31 loop
         MUX_IN_AR(x) <= std_logic_vector(to_unsigned(x, 32));
      end loop;

      wait for 10 ns;

      --test 2 input muxes
      wait until CLK'event and CLK = '1';
      SEL2 <= '0';
      wait for 10 ns;
      assert (O_2 = x"00000000")
         report "Error in 2 input mux"
         severity failure;
      SEL2 <= '1';
      wait for 10 ns;
      assert (O_2 = x"00000001")
         report "Error in 2 input mux"
         severity failure;

      --test 4 input muxes
      for x in 0 to 3 loop
         wait until CLK'event and CLK = '1';
         SEL4 <= std_logic_vector(to_unsigned(x, 2));
         wait for 10 ns;
         assert (O_4 = std_logic_vector(to_unsigned(x, 32)))
            report "Error in 4 input mux"
            severity failure;
      end loop;

      --test 8 input muxes
      for x in 0 to 7 loop
         wait until CLK'event and CLK = '1';
         SEL8 <= std_logic_vector(to_unsigned(x, 3));
         wait for 10 ns;
         assert (O_8 = std_logic_vector(to_unsigned(x, 32)))
            report "Error in 8 input mux"
            severity failure;
      end loop;

      --test 32 input muxes
      for x in 0 to 31 loop
         wait until CLK'event and CLK = '1';
         SEL32 <= std_logic_vector(to_unsigned(x, 5));
         wait for 10 ns;
         assert (O_32 = std_logic_vector(to_unsigned(x, 32)))
            report "Error in 32 input mux"
            severity failure;
      end loop;

      stop(0);
   end process;
end TB;
