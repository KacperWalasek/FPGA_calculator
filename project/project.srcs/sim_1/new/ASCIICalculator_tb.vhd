library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ASCIICalculator_tb is
--  Port ( );
end ASCIICalculator_tb;

architecture Behavioral of ASCIICalculator_tb is
    signal clk      :std_logic  :='0';
    signal R	    :std_logic  :='1';
    signal input    :natural    := 0;
    signal ascii    :std_logic_vector(7 downto 0);
    signal number   :std_logic;
    signal result : std_logic_vector(7 downto 0);
begin
    clk <= not clk after 500ns;
    process is							
    begin    
    wait for 100 ns;
    R <= '0';          
    number <= '1';         
    input <= 2; wait for 500 ns; 
                                          
    number <= '1';         
    input <= 2; wait for 500 ns;
     
    number <= '0';       
    input <= 1; wait for 500 ns;   
           
    number <= '1';         
    input <= 2; wait for 500 ns; 
                               
    number <= '0';       
    input <= 2; wait for 500 ns; 
                
    number <= '1';                      
    input <= 2; wait for 500 ns; 
    
    number <= '0';       
    input <= 3; wait for 500 ns;
                   
    number <= '1';                      
    input <= 3; wait for 500 ns;
                           
    number <= '1';                      
    input <= 1; wait for 500 ns;
                           
    number <= '0';                      
    input <= 0; 
    wait for 5000 ns;
    R <='1';    wait for 400 ns;         
            
    end process;
    Nr2ASCII: entity work.NumberToASCII
        port map(
            input => input,
            number => number,
            output => ascii
        );
    Calc: entity work.ASCIICalculator
        port map(
            R => R,
            C=> clk,
            input => ascii,
            result_character => result
        );
end Behavioral;
