library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_misc.all;

entity ClockTransfor_tb is
end ClockTransfor_tb;

architecture behavioural of ClockTransfor_tb is
    signal R : std_logic :='0';
    signal C: std_logic := '0';
    signal BOD_C: std_logic :='0';
begin
 C <= not C after 100ns;
 process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    R <= '1'; wait for 100 ns;					-- ustawienie sygnalu 'res' na '1' i odczekanie 100 ns
    R <= '0'; wait;						-- ustawienie sygnalu 'res' na '0' i zatrzymanie
  end process;							-- zakonczenie procesu
						
  
  Clock_Transorm_INST: entity work.ClockTransorm
    port map(							-- mapowanie sygnalow do portow
      R                    => R,				-- sygnal resetowania
      C                    => C,				-- zegar taktujacy
      BOD_C                => BOD_C
    );

end behavioural;

