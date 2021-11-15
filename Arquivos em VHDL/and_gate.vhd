library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	

entity and_gate is
    port(
         A : in std_logic;
         B : in std_logic;
         Y : out std_logic
         );
end and_gate;

architecture arc_and of and_gate is
 begin
    
    Y <= A AND B;

end arc_and; 
