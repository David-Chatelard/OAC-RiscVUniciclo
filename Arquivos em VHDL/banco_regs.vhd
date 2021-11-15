library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity breg is
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
end breg;

architecture arc_breg of breg is

type tipoRegistradores is array(0 to 31) of std_logic_vector(31 downto 0);
signal registradores : tipoRegistradores := (others => "00000000000000000000000000000000");


begin
	
  output_rs1 <= registradores(to_integer(unsigned(select_rs1)));
  output_rs2 <= registradores(to_integer(unsigned(select_rs2)));
	
	processo_regs:process(clk)
	begin
		if rising_edge(clk) then
			if writeEnable = '1' and select_rd /= "00000" then
					registradores(to_integer(unsigned(select_rd))) <= write_data;
			end if;
		end if;
	end process;
end arc_breg;