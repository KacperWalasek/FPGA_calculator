library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ASCIItoNumber is
    Port ( 
        input : in STD_LOGIC_VECTOR(7 downto 0);
        output : out natural;
        number : out STD_LOGIC -- if 1 output is number, if 0 output is type of operation 
    );
end ASCIItoNumber;

architecture Behavioral of ASCIItoNumber is
    signal ascii_code : unsigned(7 downto 0):= (others => '0');
begin
    ascii_code <= unsigned(input);
    output <= 
        to_integer(ascii_code) - 48     when (ascii_code > 47 and ascii_code < 58) else
        1                               when (ascii_code = 43) else  -- + 
        2                               when (ascii_code = 45) else  -- -
        3                               when (ascii_code = 42) else  -- *
        0;
    number <= '1' when (ascii_code > 47 and ascii_code < 58) else '0';
--    process(ascii_code) is
--    begin
--        if ascii_code > 47 and ascii_code < 58 then --is number
--            output <= to_integer(ascii_code) - 47;
--            number <= '1';
--        else
--            output <= 43 when 1 else 45;
            
--        end if;
        
--    end process;
end Behavioral;
