----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:14:01 05/03/2018 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port ( I_RAM_EN : in  STD_LOGIC;
           I_RAM_RE : in  STD_LOGIC;
           I_RAM_WE : in  STD_LOGIC;
           I_RAM_ADDR : in  STD_LOGIC_VECTOR (31 downto 0);
           I_RAM_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           O_RAM_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end RAM;

architecture Behavioral of RAM is
	impure function init_ram(Filename : in string) return MEM_ARRAY is
		constant LINE_NUM : integer := 256;
		file fp: text;
		variable mem_array : MEM_ARRAY := (others => x"00");
		variable line_cache : line;
		variable word_cache : bit_vector (31 downto 0) := x"00000000";
	begin
		file_open(fp, FileName, read_mode);
		for i in 0 to LINE_NUM loop
			if endfile(fp) then
				exit;
			else 
				readline(fp, line_cache);
				read(line_cache, word_cache);
				mem_array(4 * i) := to_stdlogicvector(word_cache(31 downto 24));
				mem_array(4 * i + 1) := to_stdlogicvector(word_cache(23 downto 16));
				mem_array(4 * i + 2) := to_stdlogicvector(word_cache(15 downto 8));
				mem_array(4 * i + 3) := to_stdlogicvector(word_cache(7 downto 0));
			end if;
		end loop;
		file_close(fp);
		return mem_array;
	end function;

	signal MEM_ARRAY : MEM_ARRAY := init_ram("RAM_init.txt");
begin
	process(I_RAM_EN, I_RAM_RE, I_RAM_WE, I_RAM_ADDR)
	begin
		if I_RAM_EN = '1' then
			if I_RAM_WE = '1' then
				MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR))) <= I_RAM_DATA(31 downto 24);
				MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 1) <= I_RAM_DATA(23 downto 16);
				MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 2) <= I_RAM_DATA(15 downto 8);
				MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 3) <= I_RAM_DATA(7 downto 0);
			end if;
			if I_RAM_RE = '1' then
				O_RAM_DATA(31 downto 24) <= MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)));
				O_RAM_DATA(23 downto 16) <= MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 1);
				O_RAM_DATA(15 downto 8) <= MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 2);
				O_RAM_DATA(7 downto 0) <= MEM_ARRAY(to_integer(unsigned(I_RAM_ADDR)) + 3);
			end if;
		end if;
	end process;
end Behavioral;

