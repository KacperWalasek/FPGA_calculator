library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;


entity UART_TX	is			-- instancja odbiornika szeregowego 'SERIAL_RX'
    generic (						-- mapowanie parametrow biezacych
      F_ZEGARA            :natural := 20_000_000;			-- czestotliwosc zegata w [Hz]
      L_BODOW             :natural := 9600;				-- predkosc odbierania w [bodach]
      B_SLOWA              :natural := 8;				-- liczba bitow slowa danych (5-8)
      B_PARZYSTOSCI       :natural := 1;			-- liczba bitow parzystosci (0-1)
      B_STOPOW             :natural := 2;				-- liczba bitow stopu (1-2)
      N_TX                 :boolean := FALSE;			-- negacja logiczna sygnalu szeregowego
      N_SLOWO             :boolean := FALSE			-- negacja logiczna slowa danych
    );
    port (							-- mapowanie sygnalow do portow
      R		:in  std_logic;					-- sygnal resetowania
      C        :in  std_logic;                    -- zegar taktujacy
      TX        :out std_logic;                    -- wysylany sygnal szeregowy
      SLOWO    :in  std_logic_vector(B_SLOWA-1 downto 0);    -- wysylane slowo danych
      NADAJ    :in  std_logic;                    -- flaga zadania nadania
      WYSYLANIE    :out std_logic                    -- flaga potwierdzenia wysylanie
    );
   end UART_TX;
    
  architecture  behavioral of UART_TX	is
  signal   bufor	:std_logic_vector(SLOWO'range);		-- rejestr kolejno odebranych bitow danych
  signal   f_parzystosc    :std_logic;                -- flaga parzystosci 
  signal   nadawaj    :std_logic;                -- wysylany sygnal szeregowy
  constant T		:positive := F_ZEGARA/L_BODOW-1;
  signal   l_czasu  	:natural range 0 to T;			
  signal   l_bitow      :natural range 0 to B_SLOWA-1;    
  signal working: boolean:= false;
  begin
        
        process (R, C) is						-- proces odbiornika
        
        begin
  	     
             if (R='1') then                        -- asynchroniczna inicjalizacja rejestrow
               bufor        <= (others => '0');                -- wyzerowanie bufora bitow danych
               f_parzystosc <= '0';                    -- wyzerowanie flagi parzystosci
               l_czasu      <= 0;                    -- wyzerowanie licznika czasu bodu
               l_bitow      <= 0;                    -- wyzerowanie licznika odebranych bitow
               nadawaj        <= '0';                    -- wyzerowanie sygnalu nadawania szeregowego
               WYSYLANIE    <= '0';                    -- wyzerowanie flagi potwierdzenia nadania
               
                elsif (rising_edge(C)) then	            
                    if (not working) and NADAJ='1' then
                    l_czasu <= 0;					
                    l_bitow <= 0;    
                    working <= true;
                    WYSYLANIE <= '1';
                        bufor     <= SLOWO;				-- zapisanie bufora bitow danych
                        f_parzystosc <= XOR_REDUCE(SLOWO);            -- wyznaczenie flagi parzystosci
                            if (N_SLOWO = TRUE) then                -- badanie warunku zanegowania odebranego slowa
                              bufor        <= not(SLOWO);            -- zapisanie bufora zanegowanych bitow danych
                          f_parzystosc <= not(XOR_REDUCE(SLOWO));        -- wyznaczenie flagi parzystosci
                        end if;                        -- zakonczenie instukcji warunkowej
                   elsif (l_czasu /= T) then
                        l_czasu <= l_czasu + 1;
                   else 
                        l_czasu <= 0;
                        if l_bitow = 0 then
                             nadawaj <= '1';    
                        elsif l_bitow < B_SLOWA + 1 then
                            nadawaj <= bufor(l_bitow - 1);	
                        elsif l_bitow < B_SLOWA + B_PARZYSTOSCI + 1 then
                            nadawaj <= f_parzystosc;
                        elsif l_bitow < B_SLOWA + B_PARZYSTOSCI + B_STOPOW + 1 then	
                             nadawaj <= '0';
                             if l_bitow = B_SLOWA + B_PARZYSTOSCI + B_STOPOW then
                                WYSYLANIE <= '0';	
                                working <= false;	     
                             end if;                 
                        end if;	
                        l_bitow <= l_bitow + 1;
                   end if; 
               end if;
               
     	end process;
  	
  	 TX <= nadawaj when N_TX = FALSE else not(nadawaj);		-- opcjonalne zanegowanie sygnalu TX
       
  end behavioral;