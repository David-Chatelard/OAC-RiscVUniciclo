library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	
	
entity bloco_controle is 
	port(
		opcode: in std_logic_vector(6 downto 0);
		branch: out std_logic;
		memRead: out std_logic;
		memToReg: out std_logic;
		aluOP: out std_logic_vector(2 downto 0);
		memWrite: out std_logic;
		aluSrc: out std_logic;
		regWrite: out std_logic;
		is_LUI: out std_logic;
		is_AUIPC: out std_logic;
		is_JALX: out std_logic;
		is_JALR: out std_logic
	);
end entity bloco_controle;

architecture arc of bloco_controle is
  
  signal aux_opcode : std_logic_vector(6 downto 0);
  signal aux_branch : std_logic;
  signal aux_memRead : std_logic;
  signal aux_memToReg : std_logic;
  signal aux_aluOP : std_logic_vector(2 downto 0);
  signal aux_memWrite : std_logic;
  signal aux_aluSrc : std_logic;
  signal aux_regWrite : std_logic;
  signal aux_is_LUI: std_logic;
	signal aux_is_AUIPC: std_logic;
	signal aux_is_JALX: std_logic;
	signal aux_is_JALR: std_logic;
  
begin
  
  aux_opcode <= opcode;
  branch <= aux_branch;
  memRead <= aux_memRead;
  memToReg <= aux_memToReg;
  aluOP <= aux_aluOP;
  memWrite <= aux_memWrite;
  aluSrc <= aux_aluSrc;
  regWrite <= aux_regWrite;
  is_LUI <= aux_is_LUI;
	is_AUIPC <= aux_is_AUIPC;
	is_JALX <= aux_is_JALX;
	is_JALR <= aux_is_JALR;
  
  
  process (aux_opcode)
    begin
      case aux_opcode is
        when "0110011" => -- R Type(Logico Aritmetico)
          aux_branch <= '0';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "010";
          aux_memWrite <= '0';
          aux_aluSrc <= '0';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "0010011" => -- I Type(Logico Aritmetico)
          aux_branch <= '0';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "011";
          aux_memWrite <= '0';
          aux_aluSrc <= '1';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "0100011" => -- S Type (SW)
          aux_branch <= '0';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "000";
          aux_memWrite <= '1';
          aux_aluSrc <= '1';
          aux_regWrite <= '0';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
	        
	       when "0000011" => -- LW
          aux_branch <= '0';
          aux_memRead <= '1';
          aux_memToReg <= '1';
          aux_aluOP <= "000";
          aux_memWrite <= '0';
          aux_aluSrc <= '1';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "1100011" => -- B(SB) Type
          aux_branch <= '1';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "001";
          aux_memWrite <= '0';
          aux_aluSrc <= '0';
          aux_regWrite <= '0';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "0110111" => -- U Type(LUI)
          aux_branch <= '0';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "000";
          aux_memWrite <= '0';
          aux_aluSrc <= '1';
          aux_regWrite <= '1';
          aux_is_LUI <= '1';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "0010111" => -- U Type(AUIPC)
          aux_branch <= '0';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "000";
          aux_memWrite <= '0';
          aux_aluSrc <= '1';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '1';
	        aux_is_JALX <= '0';
	        aux_is_JALR <= '0';
          
        when "1101111" => -- UJ Type(JAL)
          aux_branch <= '1';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "100";
          aux_memWrite <= '0';
          aux_aluSrc <= '0';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '1';
	        aux_is_JALR <= '0';
        
        when "1100111" => -- JALR
          aux_branch <= '1';
          aux_memRead <= '0';
          aux_memToReg <= '0';
          aux_aluOP <= "110";
          aux_memWrite <= '0';
          aux_aluSrc <= '1';
          aux_regWrite <= '1';
          aux_is_LUI <= '0';
	        aux_is_AUIPC <= '0';
	        aux_is_JALX <= '1';
	        aux_is_JALR <= '1';
          
      when others =>
        aux_branch <= '0';
        aux_memRead <= '0';
        aux_memToReg <= '0';
        aux_aluOP <= "000";
        aux_memWrite <= '0';
        aux_aluSrc <= '0';
        aux_regWrite <= '0';
        aux_is_LUI <= '0';
	      aux_is_AUIPC <= '0';
	      aux_is_JALX <= '0';
	      aux_is_JALR <= '0';
        
    end case;
  end process;
end arc;