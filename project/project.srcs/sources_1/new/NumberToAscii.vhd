library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity NumberToAscii is
    Port ( 
        input : in natural;
        number : in STD_LOGIC;
        output : out STD_LOGIC_VECTOR(7 downto 0)
    );
end NumberToAscii;

architecture Behavioral of NumberToAscii is

begin
    output <= std_logic_vector(to_unsigned(input + 48, 8)) when (number = '1') else
              std_logic_vector(to_unsigned(43, 8)) when (input = 1) else
              std_logic_vector(to_unsigned(45, 8)) when (input = 2) else
              std_logic_vector(to_unsigned(42, 8)) when (input = 3) else
              std_logic_vector(to_unsigned(32, 8)); --space
end Behavioral;
