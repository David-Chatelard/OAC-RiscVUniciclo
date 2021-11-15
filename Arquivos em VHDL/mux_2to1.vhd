library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1 is
    port (
           sel : in  std_logic;
           A   : in  std_logic_vector(31 downto 0);
           B   : in  std_logic_vector(31 downto 0);
           X   : out std_logic_vector(31 downto 0)
          );
end mux_2to1;

architecture arc of mux_2to1 is
  begin
    X <= A when (sel = '0') else B;
end arc;
