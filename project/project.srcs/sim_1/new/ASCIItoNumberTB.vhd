----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.06.2021 16:17:17
-- Design Name: 
-- Module Name: ASCIItoNumberTB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ASCIItoNumberTB is
--  Port ( );
end ASCIItoNumberTB;

architecture Behavioral of ASCIItoNumberTB is
    signal input: std_logic_vector(7 downto 0) := "00000000";
    signal output: natural;
    signal number: bit;
begin
    process is							
    begin								
        input <= "00000000";  wait for 100 ns;								
        input <= "00101011";  wait for 100 ns;								
        input <= "00101010";  wait for 100 ns;								
        input <= "00101101";  wait for 100 ns;								
        input <= "00101111";  wait for 100 ns;								
        input <= "00110000";  wait for 100 ns;								
        input <= "00110001";  wait for 100 ns;								
        input <= "00110010";  wait for 100 ns;								
        input <= "00110011";  wait for 100 ns;								
        input <= "00110100";  wait for 100 ns;								
        input <= "00110101";  wait for 100 ns;								
        input <= "00110110";  wait for 100 ns;								
        input <= "00110111";  wait for 100 ns;								
        input <= "00111000";  wait for 100 ns;								
        input <= "00111001";  wait for 100 ns;								
        input <= "00111010";  wait for 100 ns;								
        input <= "00111011";  wait for 100 ns;								
        input <= "00111100";  wait for 100 ns;								
        input <= "00111101";  wait for 100 ns;
    end process;
    
    ASCIItoNrInst: entity work.ASCIItoNumber
        port map(
            input => input,
            output => output,
            number => number
        );
    

end Behavioral;
