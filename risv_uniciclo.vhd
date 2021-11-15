library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;	

entity riscV is
  port(
      clk : in std_logic
  );
end entity riscV;

architecture arc_riscV of riscV is
      
component mux_2to1 is
    port (
           sel : in  std_logic;
           A   : in  std_logic_vector(31 downto 0);
           B   : in  std_logic_vector(31 downto 0);
           X   : out std_logic_vector(31 downto 0)
          );
end component;

component mux_2to1_5bits is
    port (
           sel : in  std_logic;
           A   : in  std_logic_vector(4 downto 0);
           B   : in  std_logic_vector(4 downto 0);
           X   : out std_logic_vector(4 downto 0)
          );
end component;

component and_gate is
    port(
         A : in std_logic;
         B : in std_logic;
         Y : out std_logic
         );
end component;

component adder_32_bit is
    port ( num1 : in  std_logic_vector(31 downto 0);
           num2 : in  std_logic_vector(31 downto 0);
           soma : out  std_logic_vector(31 downto 0)
          );
end component;

component pc is
    port ( 
           clk : in  std_logic;
           input : in  std_logic_vector(31 downto 0);
           output : out  std_logic_vector(31 downto 0)
          );
end component;

component rom is 
	port(
		address: in std_logic_vector;
		dataout: out std_logic_vector
	);
end component;

component ram is
 	port (
 		clock : in std_logic;
 		we : in std_logic;
 		address : in std_logic_vector;
 		datain : in std_logic_vector;
 		dataout : out std_logic_vector
 );
end component;

component controle_ULA is
	port (
		aluOP: in std_logic_vector(2 downto 0);
		func3: in std_logic_vector(2 downto 0);
		func7: in std_logic;
		ULA_control: out std_logic_vector(3 downto 0)
		);
end component;

component ulaRV is
  port (
    opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		Z : out std_logic_vector(31 downto 0);
		zero : out std_logic
  );
end component;

component breg is
	port (
		clk : in std_logic;
		writeEnable : in std_logic;
	  select_rs1 : in  std_logic_vector(4 downto 0);
    select_rs2 : in  std_logic_vector(4 downto 0);
	  select_rd : in std_logic_vector(4 downto 0);
		write_data : in std_logic_vector(31 downto 0);
		output_rs1 : out std_logic_vector(31 downto 0);
    output_rs2 : out std_logic_vector(31 downto 0)
		);
end component;

component bloco_controle is 
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
end component;

component genImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out std_logic_vector(31 downto 0)
  );
end component;


--Clock
signal aux_clk :  std_logic;

--Memoria de instrucoes(ROM) e PC
signal aux_input_pc           : std_logic_vector(31 downto 0);
signal aux_output_pc          : std_logic_vector(31 downto 0);
signal instruction            : std_logic_vector(31 downto 0);
alias aux_adress              : std_logic_vector(9 downto 0) is aux_output_pc(11 downto 2);--aux_output_pc(7 downto 0);--mudar para aux_output_pc(11 downto 2)

--Bloco de controle
signal aux_branch   : std_logic;
signal aux_memRead  : std_logic;
signal aux_memToReg : std_logic;
signal aux_aluOP    : std_logic_vector(2 downto 0);
signal aux_memWrite : std_logic;
signal aux_aluSrc   : std_logic;
signal aux_regWrite : std_logic;
signal aux_is_LUI   : std_logic;
signal aux_is_AUIPC : std_logic;
signal aux_is_JALX  : std_logic;
signal aux_is_JALR  : std_logic;
alias aux_opcode : std_logic_vector(6 downto 0) is instruction(6 downto 0);

--Banco de registradores
signal aux_write_data  :  std_logic_vector(31 downto 0);
alias aux_writeEnable :  std_logic is aux_regWrite;
alias aux_select_rs1 : std_logic_vector(4 downto 0) is instruction(19 downto 15);
alias aux_select_rs2 : std_logic_vector(4 downto 0) is instruction(24 downto 20);
alias aux_select_rd : std_logic_vector(4 downto 0) is instruction(11 downto 7);
signal aux_output_rs1         : std_logic_vector(31 downto 0);
signal aux_output_rs2         : std_logic_vector(31 downto 0);

--Gerador de imediatos
alias aux_instruction_imm : std_logic_vector(31 downto 0) is instruction;
signal aux_imm32 : std_logic_vector(31 downto 0);

--Controle da ULA
alias aux_aluOP_ULA : std_logic_vector(2 downto 0) is aux_aluOP;
alias aux_func3 : std_logic_vector(2 downto 0) is instruction(14 downto 12);
alias aux_func7 : std_logic is instruction(30);
signal aux_ULA_control : std_logic_vector(3 downto 0);

--ULA
alias aux_ULA_opcode : std_logic_vector(3 downto 0) is aux_ULA_control;
alias aux_ULA_A : std_logic_vector(31 downto 0) is aux_output_rs1;
signal aux_ULA_B : std_logic_vector(31 downto 0);
signal aux_ULA_Z : std_logic_vector(31 downto 0);
signal aux_ULA_zero : std_logic;

--Memoria de dados(RAM)
alias aux_we_ram       : std_logic is aux_memWrite;
alias aux_address_ram  : std_logic_vector(9 downto 0) is aux_ULA_Z(11 downto 2);
alias aux_datain_ram   : std_logic_vector is aux_output_rs2;
signal aux_dataout_ram : std_logic_vector(31 downto 0);

--Somador pc + imediato
signal aux_soma_pc_imm : std_logic_vector(31 downto 0);

--Somador pc + 4
signal aux_sinal_4 : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
signal aux_soma_pc_4 : std_logic_vector(31 downto 0);

--Porta AND
signal aux_saida_AND : std_logic;

--Mux_somadores
signal aux_pc_somado : std_logic_vector(31 downto 0);

--Mux LUI
signal aux_sinal_LUI_0 : std_logic_vector(4 downto 0) := "00000";
signal aux_select_rs1_final : std_logic_vector(4 downto 0);

--Mux RAM
signal aux_saida_mux_ram : std_logic_vector(31 downto 0);

--Mux AUIPC
signal aux_saida_mux_AUIPC : std_logic_vector(31 downto 0);


begin

pc_pc: pc port map(
                   clk => aux_clk,
                   input => aux_input_pc,
                   output => aux_output_pc
                  );

memoria_instrucoes: rom port map(
                                  address => aux_adress,
                                  dataout => instruction
                                );
                                
bloco_de_controle: bloco_controle port map(
                                            opcode => aux_opcode,
                                            branch => aux_branch,
                                            memRead => aux_memRead,
                                            memToReg => aux_memToReg,
                                            aluOP => aux_aluOP,
                                            memWrite => aux_memWrite,
                                            aluSrc => aux_aluSrc,
                                            regWrite => aux_regWrite,
                                            is_LUI => aux_is_LUI,
                                            is_AUIPC => aux_is_AUIPC,
                                            is_JALX => aux_is_JALX,
                                            is_JALR => aux_is_JALR
                                          );
                                          
banco_de_registradores: breg port map(
                                        write_data => aux_write_data,
                                        writeEnable => aux_writeEnable,
                                        select_rs1 => aux_select_rs1_final,
                                        select_rs2 => aux_select_rs2,
                                        select_rd => aux_select_rd,
                                        clk => aux_clk,
                                        output_rs1 => aux_output_rs1,
                                        output_rs2 => aux_output_rs2
                                      );
                                      
gerador_imediato: genImm32 port map(
                                     instr => aux_instruction_imm,
                                     imm32 => aux_imm32
                                    );
                                    
ULA_control: controle_ULA port map(
                                    aluOP => aux_aluOP_ULA,
		                                func3 => aux_func3,
		                                func7 => aux_func7,
		                                ULA_control => aux_ULA_control
                                  );
                                  
mux_breg_imm_toULA: mux_2to1 port map(
                                       sel => aux_aluSrc,
                                       A => aux_output_rs2,
          	                            B => aux_imm32,
                                       X => aux_ULA_B
                                      );
                                      
ULA: ulaRV port map(
                     opcode => aux_ULA_opcode,
		                 A => aux_ULA_A,
		                 B => aux_ULA_B,
		                 Z => aux_ULA_Z,
		                 zero => aux_ULA_zero
                    );
                    
memoria_dados: ram port map(
                             clock => aux_clk,
 		                         we => aux_we_ram,
 		                         address => aux_address_ram,
 		                         datain => aux_datain_ram,
 		                         dataout => aux_dataout_ram
                            );
                            
mux_ram_ula_toBreg: mux_2to1 port map(
                                       sel => aux_memToReg,
                                       A => aux_ULA_Z,
          	                            B => aux_dataout_ram,
                                       X => aux_saida_mux_ram
                                      );
                                      
somador_pc_imm: adder_32_bit port map(
                                        num1 => aux_output_pc,
                                        num2 => aux_imm32,
                                        soma => aux_soma_pc_imm
                                      );
                                      
somador_pc_4: adder_32_bit port map(
                                        num1 => aux_output_pc,
                                        num2 => aux_sinal_4,
                                        soma => aux_soma_pc_4
                                      );
                                      
porta_and_branch: and_gate port map(
                              A => aux_branch,
                              B => aux_ULA_zero,
                              Y => aux_saida_AND
                             );
                             
mux_somadores: mux_2to1 port map(
                                       sel => aux_saida_AND,
                                       A => aux_soma_pc_4,
          	                            B => aux_soma_pc_imm,
                                       X => aux_pc_somado
                                      );
                                      
mux_LUI: mux_2to1_5bits port map(
                            sel => aux_is_LUI,
                            A => aux_select_rs1,
 	                          B => aux_sinal_LUI_0,
                            X => aux_select_rs1_final
                           );
                           
mux_AUIPC: mux_2to1 port map(
                              sel => aux_is_AUIPC,
                              A => aux_saida_mux_ram,
          	                   B => aux_soma_pc_imm,
                              X => aux_saida_mux_AUIPC
                             );
                             
mux_JAL_JALR: mux_2to1 port map(
                              sel => aux_is_JALX,
                              A => aux_saida_mux_AUIPC,
          	                   B => aux_soma_pc_4,
                              X => aux_write_data
                             );
                             
mux_JALR: mux_2to1 port map(
                              sel => aux_is_JALR,
                              A => aux_pc_somado,
          	                   B => aux_ULA_Z,
                              X => aux_input_pc
                             );

process
  begin
    aux_clk <= '0';
    wait for 1000 ns;
    aux_clk <= '1';
    wait for 1000 ns;
  end process;
  
end arc_riscV;