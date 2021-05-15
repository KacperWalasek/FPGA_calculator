library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;


entity SERIAL_RX	is			-- instancja odbiornika szeregowego 'SERIAL_RX'
    generic (						-- mapowanie parametrow biezacych
      F_ZEGARA            :natural := 20_000_000;			-- czestotliwosc zegata w [Hz]
      L_BODOW             :natural := 9600;				-- predkosc odbierania w [bodach]
      B_SLOWA              :natural := 8;				-- liczba bitow slowa danych (5-8)
      B_PARZYSTOSCI       :natural := 1;			-- liczba bitow parzystosci (0-1)
      B_STOPOW             :natural := 2;				-- liczba bitow stopu (1-2)
      N_RX                 :boolean := FALSE;			-- negacja logiczna sygnalu szeregowego
      N_SLOWO             :boolean := FALSE			-- negacja logiczna slowa danych
    );
    port (							-- mapowanie sygnalow do portow
      R                    :in std_logic;				-- sygnal resetowania
      C                    :in std_logic;			-- zegar taktujacy
      RX                    :in std_logic;			-- odebrany sygnal szeregowy
      SLOWO                :out std_logic_vector(B_SLOWA-1 downto 0);			-- odebrane slowo danych
      GOTOWE               :out std_logic;					-- flaga potwierdzenia odbioru
      BLAD                 :out std_logic				-- flaga wykrycia bledu w odbiorze
    );
   end SERIAL_RX;
    
  architecture  behavioral of SERIAL_RX	is
  
  signal BOD_C : std_logic;
  signal MY_R : std_logic;
  signal done: std_logic := '1';
  signal MY_RX: std_logic;
  begin
    MY_RX <= not RX when N_RX else RX;
  	process(R,RX,C)is
  	begin 
  	MY_R<='0';
  	if R='1' then
  	 MY_R<='1';
  	end if;
  	if RX'event and MY_RX='0' and done='1' then
  	 MY_R<='1';
  	end if;
  	
  	end process;
  	
  	Clk_trans_INST: entity work.ClockTransorm				-- instancja odbiornika szeregowego 'SERIAL_RX'
  	  generic map(
  	     N_BOD => F_ZEGARA/L_BODOW
  	  )
      port map(                            -- mapowanie sygnalow do portow
        R                    => MY_R,                -- sygnal resetowania
        C                    => C,                -- zegar taktujacy
        BOD_C => BOD_C            -- przetransformowany zegar
      );
 
   RX_reader_INST: entity work.RX_reader				-- instancja odbiornika szeregowego 'SERIAL_RX'
            generic map(
            B_SLOWA => B_SLOWA,
            B_PARZYSTOSCI => B_PARZYSTOSCI,
            B_STOPOW =>B_STOPOW,
            N_SLOWO => N_SLOWO
            )
            port map(                            -- mapowanie sygnalow do portow
              R                    => MY_R,                -- sygnal resetowania
              clk                    => BOD_C,                -- zegar taktujacy
              bod_c => BOD_C,
              RX => MY_RX,
              tab => SLOWO,
              done => done,
              blad => BLAD            
            );  
            
  -- BLAD <= '0';
    GOTOWE <= done;         
  end behavioral;