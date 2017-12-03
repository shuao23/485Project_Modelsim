------------------------------------------------
--1 bit Adder
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder1 is
   port(a, b, carry_in : in std_logic;
   sum, carry_out : out std_logic);
end entity adder1;

architecture behav of adder1 is

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

   signal o_and1, o_and2, o_and3, o_or1, o_xor1 : std_logic;

begin

   --Carry out
   and1 : and_gate port map (a, b, o_and1);
   and2 : and_gate port map (a, carry_in, o_and2);
   and3 : and_gate port map (b, carry_in, o_and3);
   or1 : or_gate port map (o_and1, o_and2, o_or1);
   or2 : or_gate port map (o_and3, o_or1, carry_out);

   --SUM
   xor1 : xor_gate port map (a, b, o_xor1);
   xor2 : xor_gate port map (carry_in, o_xor1, sum);


end architecture behav;
