library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instructions_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);

	port (
    clock, enable: in std_logic;
		address_to_read: in std_logic_vector (address_width - 1 downto 0);
		instruction_out: out std_logic_vector (data_width - 1 downto 0));
end instructions_memory;

architecture behavioral of instructions_memory is

	type instructions_sequence is array (0 to length) of std_logic_vector (data_width - 1 downto 0);
	signal instructions: instructions_sequence :=
		
		--------------------------------------------------------------------------------
		--addi $t0, $zero, 0
		(0 => x"20080000",
		--addi $t1, $zero, 9
		1 => x"20090009",
		--add $a0, $zero, $zero
		2 => x"00002020",
		--addi $a1, $zero, 2
		3 => x"20050002",
		--irda $a0
		4 => x"20040001",
		--irda $a1
		5 => x"20050001",
		--beq $a0, $a1, 7
		6 => x"10850001",
		--bne $a0, $a1, 13
		7 => x"14850006",
--amarelo:	addi $t3, $zero, 1
		8 => x"200B0001",
		--lw $v0, 0($t3)
		9 => x"8D620000",
		--sw $v0, 0($t0)
		10 => x"AD020000",
		--addi $t0, $t0, 1
		11 => x"21080001",
		--bne $t0, $t1, 7
		12 => x"1509FFFB",
		--j 17
		13 => x"08100011",
--azul:		addi $v0, $zero, 0
		14 => x"20020000",
		--sw $v0, 0($t0)
		15 => x"AD020000",
		--addi $t0, $t0, 1
		16 => x"21080001",
		--bne $t0, $t1, 13
		17 => x"1509FFFC",
--fim:		addi $t0, $zero, 
		18 => x"20080000",
		   
		others => (others => 'U'));

begin

	process(clock)
		variable index: integer;
	begin
    if rising_edge(clock) then
      if enable='1' then
      		index := to_integer(unsigned(address_to_read));
			  instruction_out <= instructions(index);
			end if;
    end if;
	end process;

end behavioral;
