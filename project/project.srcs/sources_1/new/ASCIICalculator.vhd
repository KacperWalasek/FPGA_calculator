library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ASCIICalculator is
    Port ( C : in STD_LOGIC;
           R : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(7 downto 0);
           result_character : out STD_LOGIC_VECTOR(7 downto 0));
end ASCIICalculator;

architecture Behavioral of ASCIICalculator is
    signal in_number : STD_LOGIC := '0';
    signal out_number : STD_LOGIC := '0';
    signal digit : natural := 0;
    signal result : integer;
    signal result_digit : integer;
begin
    ASCII_TO_NR: entity work.ASCIIToNumber
    port map (
        input => input,
        number => in_number,
        output => digit
    );

    CALC: entity work.Calculator 
    port map(
        reset => R,
        C => C,
        input => digit,
        number => in_number,
        output => result        
    );
    NrToDgt: entity work.NumberToDigits
    port map(
        R => '0',
        C => C,
        input => result,
        output => result_digit,
        number => out_number
    );
    NrToASCII: entity work.NumberToASCII
    port map(
        input => result_digit,
        number => out_number,
        output => result_character
    );

end Behavioral;
