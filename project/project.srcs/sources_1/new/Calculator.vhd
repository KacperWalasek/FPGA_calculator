library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Calculator is
    Port ( 
        reset : in std_logic;
        C : in std_logic;
        input : in natural;
        number : in std_logic;
        output : out integer     
    );
end Calculator;
    
architecture Behavioral of Calculator is
    signal result : integer := 0; -- wartoœæ liczonego zadania bez obecnie wczytywanego wyra¿enia (a*b*...*c)
    signal current_expression : integer := 0;   -- wartoœæ obecnie liczbonego wyra¿enia (a*b*...*c) bez obecnie wczytywanej liczby
    signal current_number : integer := 0;   -- obecnie wczytywana liczba
    signal expression_modifier : integer := 1; -- 1 lub -1 w zale¿noœci, czy przed wyra¿eniem by³ znak - czy +
    
    type STATE_T is (EXPRESSION_START, EXPRESSION_NUMBER, EXPRESSION_ANY);
    signal state : STATE_T := EXPRESSION_START;
begin
    process(reset, C)
    begin
        if reset = '1' then
            state <= EXPRESSION_START;
            result <= 0;
            current_expression <= 0;
            expression_modifier <= 1;
        elsif C'event then
            case state is
                when EXPRESSION_START =>
                    -- odzczytaj pierwsz¹ cyfrê pierwszej liczby wyra¿enia
                    current_number <= input;
                    current_expression <= expression_modifier;
                    state <= EXPRESSION_ANY;                 
               when EXPRESSION_NUMBER =>
                   -- odczytaj pierwsz¹ cyfrê liczby
                   current_number <= input; 
                   state <= EXPRESSION_ANY;
                when EXPRESSION_ANY =>
                    if number = '0' then
                        -- odczytaj znak
                        case input is
                            when 1 => -- +
                                result <= result + current_expression * current_number;
                                expression_modifier <= 1;
                                current_number <= 0;
                                current_expression <= 0;
                                state <= EXPRESSION_START;
                            when 2 =>  -- -
                                result <= result + current_expression * current_number;
                                expression_modifier <= -1;
                                current_number <= 0;
                                current_expression <= 0;
                                state <= EXPRESSION_START;
                            when 3 => -- *
                                current_expression <= current_expression * current_number;
                                current_number <= 1;
                                state <= EXPRESSION_NUMBER;
                            when others=>
                                
                        end case;  
                    else
                        -- odczytaj kolejn¹ cyfrê liczby
                        current_number <= current_number * 10 + input;
                    end if;
            end case;
        end if;
    end process;
    
    output <= result + current_expression * current_number;
end Behavioral;
