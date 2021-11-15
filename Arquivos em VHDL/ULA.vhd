-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaRV is
	generic (WSIZE : natural := 32);
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end ulaRV;

architecture arc_ula of ulaRV is

signal aux : std_logic_vector(WSIZE-1 downto 0);

begin

	Z <= aux;
    zero <= '1' when (aux = std_logic_vector(resize(unsigned'("0"), 32))) else '0';
    
ulaRV: process (A, B, opcode)
	begin
    	case opcode is
    	  
     	when "0000" => --ADD
         	  aux <= std_logic_vector(signed(A) + signed(B));
            	
      when "0001" => --SUB
            	aux <= std_logic_vector(signed(A) - signed(B));
            	
			when "0010" => --AND
            	aux <= std_logic_vector(A and B);
            	
			when "0011" => --OR
            	aux <= std_logic_vector(A or B);
            	
			when "0100" => --XOR
            	aux <= std_logic_vector(A xor B);
            	
			when "0101" => --SLL
            	aux <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));
            	
			when "0110" => --SRL
            	aux <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));
            	
			when "0111" => --SRA
            	aux <= std_logic_vector(signed(A) sra to_integer(unsigned(B)));
            	
			when "1000" => --SLT
            	if signed(A) < signed(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1001" => --SLTU
            	if unsigned(A) < unsigned(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1010" => --SGE
            	if signed(A) >= signed(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1011" => --SGEU
            	if unsigned(A) >= unsigned(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1100" => --SEQ
            	if signed(A) = signed(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1101" => --SNE
            	if signed(A) /= signed(B) then
            		aux <= std_logic_vector(resize(unsigned'("01"), 32));
				else
                	aux <= std_logic_vector(resize(unsigned'("0"), 32));
				end if;
				
			when "1110" => --JAL
			  aux <= std_logic_vector(resize(unsigned'("0"), 32));
			  
			when "1111" => --JALR
			  aux <= A;
			  
			  
			when others =>
            	aux <= std_logic_vector(resize(unsigned'("0"), 32));
		end case;
	end process;
end arc_ula;
