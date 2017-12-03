------------------------------------------------
--32 Bit register
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers_32 is
   port(
      clk : in std_logic;
      rdnum1, rdnum2, wrnum : in std_logic_vector (4 downto 0);
      wrdat : in std_logic_vector (31 downto 0);
      rddat1, rddat2 : out std_logic_vector (31 downto 0)
   );
end entity registers_32;

architecture behav of registers_32 is

   component reg32 is
      port(
         clk : in std_logic;
         D : in std_logic_vector (31 downto 0);
         Q : out std_logic_vector (31 downto 0)
      );
   end component reg32;

   component and_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component and_gate;

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

   component decoder_32 is
      port(
         i : in std_logic_vector (4 downto 0);
         o : out std_logic_vector (31 downto 0)
      );
   end component decoder_32;

   type std_logic_vector_arr32 is array (0 to 31) of std_logic_vector (31 downto 0);

   signal WRITE_IN : std_logic := '0';
   signal SEL : std_logic_vector (31 downto 0) := (others => '0'); --Connected from decoder
   signal C_AR : std_logic_vector (31 downto 0):= (others => '0'); --Connected to clk of each registers
   signal Q_AR : std_logic_vector_arr32 := ((others => (others => '0')));

begin

   decoder : decoder_32 port map (wrnum, SEL);

   AndArr32 : for i in 0 to 31 generate
   begin
      and_x : and_gate port map (WRITE_IN, SEL(i), C_AR(i));
   end generate AndArr32;

   RegArr32 : for i in 0 to 31 generate
   begin
      reg_x : reg32 port map (C_AR(i) ,wrdat, Q_AR(i));
   end generate RegArr32;

   mux32_1 : mux32_32 port map (
      rdnum1, Q_AR(0), Q_AR(1), Q_AR(2), Q_AR(3), Q_AR(4),
      Q_AR(5), Q_AR(6), Q_AR(7), Q_AR(8), Q_AR(9),
      Q_AR(10), Q_AR(11), Q_AR(12), Q_AR(13), Q_AR(14),
      Q_AR(15), Q_AR(16), Q_AR(17), Q_AR(18), Q_AR(19),
      Q_AR(20), Q_AR(21), Q_AR(22), Q_AR(23), Q_AR(24),
      Q_AR(25), Q_AR(26), Q_AR(27), Q_AR(28), Q_AR(29),
      Q_AR(30), Q_AR(31), rddat1);

   mux32_2 : mux32_32 port map (
      rdnum2, Q_AR(0), Q_AR(1), Q_AR(2), Q_AR(3), Q_AR(4),
      Q_AR(5), Q_AR(6), Q_AR(7), Q_AR(8), Q_AR(9),
      Q_AR(10), Q_AR(11), Q_AR(12), Q_AR(13), Q_AR(14),
      Q_AR(15), Q_AR(16), Q_AR(17), Q_AR(18), Q_AR(19),
      Q_AR(20), Q_AR(21), Q_AR(22), Q_AR(23), Q_AR(24),
      Q_AR(25), Q_AR(26), Q_AR(27), Q_AR(28), Q_AR(29),
      Q_AR(30), Q_AR(31), rddat2);

    WRITE_IN <= clk after 1 ns;

end architecture;
