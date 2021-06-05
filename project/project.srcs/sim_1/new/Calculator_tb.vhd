library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Calculator_tb is
--  Port ( );
end Calculator_tb;

architecture Behavioral of Calculator_tb is
    signal clk      :std_logic  :='0';
    signal R	    :std_logic  :='1';
    signal input    :integer    := 0;
    signal output   :integer    := 0;
    signal number   :std_logic;
begin
    clk <= not clk after 500ns;
    process is							
    begin    
    wait for 100 ns;
    R <= '0';          
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
     
    wait for 500 ns;
    R <='1';    wait for 400 ns;         
            
    end process;
    Calc: entity work.Calculator
        port map(
            reset => R,
            C=> clk,
            input => input,
            number => number,
            output => output
        );
end Behavioral;
