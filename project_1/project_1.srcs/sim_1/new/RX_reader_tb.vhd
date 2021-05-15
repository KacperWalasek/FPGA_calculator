library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_misc.all;

entity RX_READER_TB is

end RX_READER_TB;

architecture behavioural of RX_READER_TB is
  
 
 signal clk :std_logic :='0';                  	 
   signal   RX                    : std_logic:='0';			-- obserwowane wyjscie 'GOTOWE'
  signal   R		:std_logic;				-- obserwowane wyjscie 'BLAD'
  signal   tab		:std_logic_vector(7 downto 0):="00000000";		-- symulowana dana transmitowana
  signal done : std_logic:='0';
  signal blad : std_logic:='0';
begin
 clk <= not clk after 500ns;
 RX <= not RX after 350ns;
 
 process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    R <= '1'; wait for 100 ns;					-- ustawienie sygnalu 'res' na '1' i odczekanie 100 ns
    R <= '0'; wait for 5000 ns;	
    
     R <= '1'; wait for 100 ns;					-- ustawienie sygnalu 'res' na '1' i odczekanie 100 ns
       R <= '0'; wait;			-- ustawienie sygnalu 'res' na '0' i zatrzymanie
  end process;							-- zakonczenie procesu

 process(done) is					
  begin								
  
  if(done='1') then
    -- zczytujemy wektor
  end if;  			
  end process;
  	
  SERIAL_RX_INST: entity work.RX_READER				-- instancja odbiornika szeregowego 'SERIAL_RX'

    port map(							-- mapowanie sygnalow do portow
      R                    => R,				-- sygnal resetowania
      clk                    => clk,				-- zegar taktujacy
      RX                   => RX,				-- odebrany sygnal szeregowy
      tab                => tab,				-- odebrane slowo danych
      done               => done,				-- flaga potwierdzenia odbioru			-- flaga wykrycia bledu w odbiorze
      blad => blad
    );

end behavioural;
