-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
port (
instr : in std_logic_vector(31 downto 0);
imm32 : out std_logic_vector(31 downto 0));
end entity genImm32;


architecture gerador of genImm32 is
signal opcode : std_logic_vector(6 downto 0);
signal func3 : std_logic_vector(2 downto 0);
signal func7 : std_logic;
signal instrucao : std_logic_vector(31 downto 0);

begin
	opcode <= instr(6 downto 0);
	func3 <= instr(14 downto 12);
	instrucao <= instr;
	process (opcode, instrucao)
    begin
		case opcode is
			when "0110011" =>	--R Type
				imm32 <= "00000000000000000000000000000000";
			when "0000011"|"0010011"|"1100111" =>  --I Type
			  if func3 = "101" then --SRAI e SRLI
			    imm32 <= std_logic_vector(resize(signed(instr(24 downto 20)), 32));
			  else
			    imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
			  end if;
			when "0100011" =>  --S Type
				imm32 <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));
			when "1100011" =>  --SB Type
				imm32 <= std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32));
			when "0110111"|"0010111" =>  --U Type
				imm32 <= std_logic_vector(resize(signed(instr(31 downto 12)), 32) sll 12);
			when "1101111" =>  --UJ Type
				imm32 <= std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'),32));
			when others =>
            	imm32 <= "00000000000000000000000000000000";
		end case;
	end process;
end gerador;
