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
    signal last_trigger : std_logic := '0';
    signal found_first: std_logic := '0';
    signal ind : integer := 5;
    signal value : integer := 0;
begin

process (C, R, input) is
    variable k : integer := 0;
    variable ind_tmp : integer;
    variable value_tmp : integer;
begin
    ind_tmp := ind;
    value_tmp := value;
    if R'event or input'event  then
        value_tmp := 0;
        found_first <= '0';
        ind_tmp := 5;
        done <= '0';
        left <= -1;
    else
        if trigger = '1' and last_trigger = '0' then
            if ind_tmp = -1 then
                done <= '1';
            else
                number <= '1';
                if found_first = '0' then
                    while ind_tmp >= 0 and value_tmp = 0 loop
                        k := 10**ind_tmp;
                        value_tmp := (abs(input) mod (k*10) - abs(input) mod k ) / k;
                        ind_tmp := ind_tmp - 1;
                    end loop;
                    if input < 0 then
                        number <= '0';
                        value_tmp := 2;
                        ind_tmp := ind_tmp + 1;
                    end if;
                    found_first <= '1';
                else
                    k := 10**ind_tmp;
                    value_tmp := (abs(input) mod (k*10) - abs(input) mod k ) / k;
                    ind_tmp := ind_tmp - 1;
                end if;
                
                output <= value_tmp;
                left <= ind_tmp;
            end if;
        end if;
        last_trigger <= trigger;
    end if;
    value <= value_tmp;
    ind <= ind_tmp;
end process;

end Behavioral;
