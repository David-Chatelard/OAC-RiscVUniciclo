library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity rom is 
	port(
		address: in std_logic_vector;
		dataout: out std_logic_vector
	);
end entity rom;

architecture arc of rom is 
	type rom_type is array (0 to (2**(address'length)-1)) of std_logic_vector(dataout' range);
	
	impure function init_rom return rom_type is
		file text_file: text open read_mode is "testeROM.txt";
		variable text_line: line;
		variable rom_content: rom_type;
		
		begin 
			for i in 0 to (2**(address'length) - 1)  loop
			if not endfile(text_file) then
			 readline(text_file,text_line);
			 hread(text_line,rom_content(i));
			end if;
			end loop;
		return rom_content;
	end function;	
	
	signal rom: rom_type := init_rom;
	signal s_addr : std_logic_vector(address' range);
begin

s_addr <= address;

process (s_addr)
begin
	dataout <= rom(to_integer(unsigned(s_addr)));
end process;

end arc;


