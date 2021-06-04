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
    signal result : integer := 0;
    signal current_expression : integer := 0;
    signal last_sign : integer :=0;
    
    type STATE_T is (EXPRESSION_START, EXPRESSION_SIGN, EXPRESSION_NUMBER);
    signal state : STATE_T := EXPRESSION_START;
begin
    process(reset, C)
    begin
        if reset = '1' then
            state <= EXPRESSION_START;
            result <= 0;
        elsif C'event then
            case state is
                when EXPRESSION_START =>
                    current_expression <= input;
                    state <= EXPRESSION_NUMBER;
                when EXPRESSION_NUMBER =>
                    last_sign <= input;
                    case input is
                        when 1 => -- +
                            result <= result + current_expression;
                            current_expression <= 0;
                            state <= EXPRESSION_START;
                        when 2 =>  -- -
                            result <= result - current_expression;
                            current_expression <= 0;
                            state <= EXPRESSION_START;
                        when 3 => -- *
                            state <= EXPRESSION_SIGN;
                        when others=>
                            
                    end case;                   
                when EXPRESSION_SIGN =>
                    current_expression <= current_expression * input; 
                    state <= EXPRESSION_NUMBER;
            end case;
        end if;
    end process;
    
    output <= result + current_expression;
end Behavioral;
