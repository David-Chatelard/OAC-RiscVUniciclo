library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity controle_ULA is 
	port(
		aluOP: in std_logic_vector(2 downto 0);
		func3: in std_logic_vector(2 downto 0);
		func7: in std_logic;
		ULA_control: out std_logic_vector(3 downto 0)
	);
end entity controle_ULA;

architecture arc of controle_ULA is
  
  signal aux_aluOP : std_logic_vector(2 downto 0);
  signal aux_func3 : std_logic_vector(2 downto 0);
  signal aux_func7 : std_logic;
  signal aux_ULA_control : std_logic_vector(3 downto 0);
  
begin
  
  aux_aluOP <= aluOP;
  aux_func3 <= func3;
  aux_func7 <= func7;
  ULA_control <= aux_ULA_control;
  
  process (aux_aluOP, aux_func3, aux_func7)
    begin
      case aux_aluOP is
        
        when "000" => -- ADD(SW, LW, LUI, AUIPC)
          aux_ULA_control <= "0000"; --ADD          
          
        when "001" => -- Branch
          if func3 = "000" then --BEQ
            aux_ULA_control <= "1101"; --SNE
          end if;
          
          if func3 = "001" then --BNE
            aux_ULA_control <= "1100"; --SEQ
          end if;
          
          if func3 = "100" then --BLT
            aux_ULA_control <= "1010"; --SGE
          end if;
          
          if func3 = "101" then --BGE
            aux_ULA_control <= "1000"; --SLT
          end if;
          
          
        when "010" => -- R Type
          
          if func3 = "000" then --ADD ou SUB
            if func7 = '1' then --SUB
              aux_ULA_control <= "0001"; --SUB
            else
              aux_ULA_control <= "0000"; --ADD
            end if;
          end if;
          
          if func3 = "001" then --SLL
            aux_ULA_control <= "0101"; --SLL
          end if;
          
          if func3 = "010" then --SLT
            aux_ULA_control <= "1000"; --SLT
          end if;
          
          if func3 = "011" then --SLTU
            aux_ULA_control <= "1001"; --SLTU
          end if;
          
          if func3 = "100" then --XOR
            aux_ULA_control <= "0100"; --XOR
          end if;
          
          if func3 = "101" then --SRL ou SRA
            if func7 = '1' then --SRA
              aux_ULA_control <= "0111"; --SRA
            else
              aux_ULA_control <= "0110"; --SRL
            end if;
          end if;
          
          if func3 = "110" then --OR
            aux_ULA_control <= "0011"; --OR
          end if;
          
          if func3 = "111" then --AND
            aux_ULA_control <= "0010"; --AND
          end if;
	        
	        
	       when "011" => -- I Type
	         
          if func3 = "000" then --ADDi
            aux_ULA_control <= "0000"; --ADDi
          end if;
          
          if func3 = "010" then --SLTi
            aux_ULA_control <= "1000"; --SLTi
          end if;
          
          if func3 = "011" then --SLTUi
            aux_ULA_control <= "1001"; --SLTUi
          end if;
          
          if func3 = "100" then --XORi
            aux_ULA_control <= "0100"; --XORi
          end if;
          
          if func3 = "001" then --SLLi
            aux_ULA_control <= "0101"; --SLLi
          end if;
          
          if func3 = "101" then --SRLi ou SRAi
            if func7 = '1' then --SRAi
              aux_ULA_control <= "0111"; --SRAi
            else
              aux_ULA_control <= "0110"; --SRLi
            end if;
          end if;
          
          if func3 = "110" then --ORi
            aux_ULA_control <= "0011"; --ORi
          end if;
          
          if func3 = "111" then --ANDi
            aux_ULA_control <= "0010"; --ANDi
          end if;
          
          
        when "100" => --JAL
          aux_ULA_control <= "1110"; --JAL
          
        when "110" => --JALR
          aux_ULA_control <= "1111"; --JALR
          
        when others =>
          aux_ULA_control <= "0000";
        
    end case;
  end process;
end arc;