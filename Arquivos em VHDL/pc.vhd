library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port ( 
           clk : in  std_logic;
           input : in  std_logic_vector(31 downto 0);
           output : out  std_logic_vector(31 downto 0) :=  "00000000000000000000000000000000"
          );
end pc;

architecture arc_pc of pc is
  
begin

  process (clk) is
    begin
      if rising_edge(clk) then
        output <= input;
      end if;
  end process;
end arc_pc;
