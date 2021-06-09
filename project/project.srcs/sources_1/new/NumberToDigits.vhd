library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity NumberToDigits is
    Port ( input : in integer;
           C : in STD_LOGIC;
           R : in STD_LOGIC;
           trigger : in STD_LOGIC;
           output : out integer;
           number : out STD_LOGIC;
           done: out STD_LOGIC := '0');
end NumberToDigits;

architecture Behavioral of NumberToDigits is
    signal left : integer := 0;
begin

process (C, R, input) is
    variable ind : integer := 5;
    variable value : integer := 0;
    variable found_first: std_logic := '0';
    variable k : integer := 0;
    variable last_trigger : std_logic := '0';
begin
    if R'event or input'event  then
        value := 0;
        found_first := '0';
        ind := 5;
        done <= '0';
        left <= -1;
    else
        if trigger = '1' and last_trigger = '0' then
            if ind = -1 then
                done <= '1';
            else
                number <= '1';
                if found_first = '0' then
                    while ind >= 0 and value = 0 loop
                        k := 10**ind;
                        value := (abs(input) mod (k*10) - abs(input) mod k ) / k;
                        ind := ind - 1;
                    end loop;
                    if input < 0 then
                        number <= '0';
                        value := 2;
                        ind := ind + 1;
                    end if;
                    found_first := '1';
                else
                    k := 10**ind;
                    value := (abs(input) mod (k*10) - abs(input) mod k ) / k;
                    ind := ind - 1;
                end if;
                
                output <= value;
                left <= ind;
            end if;
        end if;
        last_trigger := trigger;
    end if;
end process;

end Behavioral;
