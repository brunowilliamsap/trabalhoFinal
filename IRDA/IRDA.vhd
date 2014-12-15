library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IRDA is
	port (
		irda_data: out std_logic_vector(31 downto 0));
end IRDA;
	

architecture structural of IRDA is

	signal irda_padrao: std_logic_vector(31 downto 0);

begin
	irda_padrao <= x"00000001";
	irda_data <= irda_padrao;

end structural;

