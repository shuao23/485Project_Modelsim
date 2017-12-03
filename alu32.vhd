------------------------------------------------
--32 bit ALU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu32 is
   port(
      a, b : in std_logic_vector (31 downto 0);
      op : in std_logic_vector (3 downto 0);
      zero, oflow, carry_out : out std_logic;
      o : out std_logic_vector (31 downto 0));
end entity alu32;

architecture behav of alu32 is

   component alu1 is
      port(
         a, b, less, carry_in, a_invert, b_invert : in std_logic;
         op : in std_logic_vector (1 downto 0);
         o, set, carry_out : out std_logic);
   end component alu1;
   
   component or32_gate is
      port(
         i : in std_logic_vector (31 downto 0);
         o : out std_logic
      );
   end component or32_gate;

   component xor_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component xor_gate;

   component not_gate is
      port(
         i : in std_logic;
         o : out std_logic
      );
   end component not_gate;

   signal result_arr : std_logic_vector (31 downto 0);
   signal cout_arr : std_logic_vector (30 downto 0);
   signal set_31 : std_logic;

begin
   Alu1_32 : for i in 31 downto 0 generate
   begin
      first_adder : if i = 0 generate
         alu1_x : alu1 port map (
            a(i), b(i), set_31, op(2), op(3), op(2), op(1 downto 0),
            result_arr(i), open, open);
      end generate first_adder;

      last_adder : if i = 31 generate
         alu1_x : alu1 port map (
            a(i), b(i), '0', cout_arr(i - 1), op(3), op(2), op(1 downto 0),
            result_arr(i), set_31, oflow);
      end generate last_adder;

      other_adders : if i /= 0 and i /= 31 generate
         alu1_x : alu1 port map (
            a(i), b(i), '0', cout_arr(i - 1), op(3), op(2), op(1 downto 0),
            result_arr(i), open, open);
      end generate other_adders;
   end generate;
end architecture behav;
