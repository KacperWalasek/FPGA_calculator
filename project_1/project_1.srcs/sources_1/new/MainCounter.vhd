
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockTransorm is
    generic (						-- mapowanie parametrow biezacych
      N_BOD: natural := 4
     );
    Port (
        R : in std_logic;
        C : in std_logic;
        BOD_C : out std_logic
     );
end ClockTransorm;

architecture Behavioral of ClockTransorm is
    signal bit_nr: integer := 0;
    signal clock: std_logic := '0';
begin
    process (R,C) is 
    begin
        if(R'event and  R='1') then
            bit_nr <= 0;
        elsif(C'event and C='1') then
            bit_nr <= bit_nr + 1;
            if(bit_nr=N_BOD/2-1) then 
                clock <= not clock;
            elsif(bit_nr=N_BOD-1) then
                bit_nr <=0;
            end if;
        end if;
    end process;
    BOD_C <= clock;
end Behavioral;
