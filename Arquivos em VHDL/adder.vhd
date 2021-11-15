library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_32_bit is
    port ( num1 : in  std_logic_vector(31 downto 0);
           num2 : in  std_logic_vector(31 downto 0);
           soma : out  std_logic_vector(31 downto 0)
          );
end adder_32_bit;

architecture arc_add of adder_32_bit is
begin

    soma <= std_logic_vector(signed(num1) + signed(num2));

end arc_add;