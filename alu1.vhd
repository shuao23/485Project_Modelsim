------------------------------------------------
--1 bit ALU
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu1 is
   port(
      a, b, less, carry_in, a_invert, b_invert : in std_logic;
      op : in std_logic_vector (1 downto 0);
      o, set, carry_out : out std_logic);
end entity alu1;

architecture behav of alu1 is

   component and_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component and_gate;

   component or_gate is
      port(
         x, y : in std_logic;
         o : out std_logic
      );
   end component or_gate;

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

   component adder1 is
      port(a, b, carry_in : in std_logic;
      sum, carry_out : out std_logic);
   end component adder1;

   component mux2_1 is
      port(
         s, i0, i1 : in std_logic;
         o : out std_logic
      );
   end component mux2_1;

   component mux4_1 is
      port(
         s : in std_logic_vector (1 downto 0);
         i0, i1, i2, i3 : in std_logic;
         o : out std_logic
      );
   end component mux4_1;

   signal inv_a_o, inv_b_o, mux_a_o, mux_b_o, and_o,
      or_o, sum_o : std_logic;

begin

   inv_a : not_gate port map (a, inv_a_o);
   inv_b : not_gate port map (b, inv_b_o);

   mux_a : mux2_1 port map (a_invert, a, inv_a_o, mux_a_o);
   mux_b : mux2_1 port map (b_invert, b, inv_b_o, mux_b_o);

   and_alu : and_gate port map (mux_a_o, mux_b_o, and_o);
   or_alu : or_gate port map (mux_a_o, mux_b_o, or_o);
   adder_alu : adder1 port map (mux_a_o, mux_b_o, carry_in, sum_o, carry_out);

   mux_merge : mux4_1 port map (op, and_o, or_o, sum_o, less, o);

   set <= sum_o;

end architecture behav;
