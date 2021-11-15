library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1_5bits is
    port (
           sel : in  std_logic;
           A   : in  std_logic_vector(4 downto 0);
           B   : in  std_logic_vector(4 downto 0);
           X   : out std_logic_vector(4 downto 0)
          );
end mux_2to1_5bits;

architecture arc of mux_2to1_5bits is
  begin
    X <= A when (sel = '0') else B;
end arc;


