
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity ram is
 	port (
 		clock : in std_logic;
 		we : in std_logic;
 		address : in std_logic_vector;
 		datain : in std_logic_vector;
 		dataout : out std_logic_vector
 );
end entity ram;

architecture arc of ram is 
	type ram_type is array (0 to (2**(address'length)-1)) of std_logic_vector(datain' range);
	
	impure function init_ram return ram_type is
		file text_file: text open read_mode is "testeRAM.txt";
		variable text_line: line;
		variable ram_content: ram_type;
		
		begin 
			for i in 0 to (2**(address'length) - 1)  loop
			if not endfile(text_file) then
			 readline(text_file,text_line);
			 hread(text_line,ram_content(i));
			end if;
			end loop;
		return ram_content;
	end function;	
	
	signal ram: ram_type := init_ram;
	signal s_addr : std_logic_vector(address' range);

begin
Write: process(clock) begin
if rising_edge(clock) then 
if we = '1' then
ram(to_integer(unsigned(address))) <= datain;
end if;
end if;
s_addr <= address;
end process;
dataout <= ram(to_integer(unsigned(s_addr)));

end arc;

