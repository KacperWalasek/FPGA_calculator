library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_arith.all;
use     ieee.std_logic_misc.all;

entity PROJECT_TB is
  generic (
    F_ZEGARA		:natural := 20000000;			-- czestotliwosc zegata w [Hz]
    L_BODOW		:natural := 2000000;			-- predkosc nadawania w [bodach]
    B_SLOWA		:natural := 8;				-- liczba bitow slowa danych (5-8)
    B_PARZYSTOSCI	:natural := 0;				-- liczba bitow parzystosci (0-1)
    B_STOPOW		:natural := 2;				-- liczba bitow stopu (1-2)
    N_SERIAL		:boolean := FALSE;			-- negacja logiczna sygnalu szeregowego
    N_SLOWO		:boolean := FALSE	;		-- negacja logiczna slowa danych
    L_CYFR		:natural := 3;				-- liczba cyfr dziesietnych
    L_BODOW_PRZERWY	:natural := 10				-- czas przerwy w nadawaniu w [bodach]
  );
end PROJECT_TB;

architecture behavioural of PROJECT_TB is

  signal   R		:std_logic := '0';			-- symulowany sygnal resetujacacy
  signal   C		:std_logic := '1';			-- symulowany zegar taktujacy inicjowany na '1'
  signal   RX		:std_logic;				-- symulowane wejscie 'RX'
  signal   TX		:std_logic;				-- symulowane wyjscie 'TX'
  
  constant O_ZEGARA	:time := 1 sec/F_ZEGARA;		-- okres zegara systemowego
  constant O_BITU	:time := 1 sec/L_BODOW;			-- okres czasu trwania jednego bodu

constant r1: string := "2+2=";
constant r2: string := "2+2*2=";
constant r3: string := "5*0*2=";
constant r4: string := "100-300=";
constant r5: string := "1+1+1+1+1+1+1+1+1+1+1+1=";

  signal Numer_rozkazu : integer := 0;
  signal   WYNIK	:string(11 downto 1); -- sekwencja odebranych znakow ASCII

  function neg(V :std_logic; N :boolean) return std_logic is	-- deklaracja funkcji wewnetrznej 'neg'
  begin								-- czesc wykonawcza funkcji wewnetrznej
    if (N=FALSE) then return (V); end if;			-- zwrot wartosc 'V' gdy 'N'=FALSE
    return (not(V));						-- zwrot zanegowanej wartosci 'V'
  end function;							-- zakonczenie funkcji wewnetrznej
 
begin

 process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    R <= '1'; wait for 100 ns;					
    R <= '0'; wait;
    end process;							-- zakonczenie procesu

  process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    C <= not(C); wait for O_ZEGARA/2;				-- zanegowanie sygnalu 'clk' i odczekanie pol okresu zegara
  end process;							-- zakonczenie procesu
  
  process is
    procedure send(constant r : in string;
                   signal RX: out std_logic;
                   signal RES: out std_logic
                   ) is	-- deklaracja funkcji wewnetrznej 'neg'
      variable D :std_logic_vector(B_SLOWA-1 downto 0);		-- deklaracja zmiennej 'D' slowa nadawanego
      begin                            -- czesc wykonawcza funkcji wewnetrznej
         RX <= neg('0',N_SERIAL);					-- incjalizacja sygnalu 'RX' na wartosci spoczynkowa
          wait for 200 ns;                        -- odczekanie 200 ns
          for i in 1 to r'length loop                -- petla po kolenych wysylanych znakach
            wait for 10*O_BITU;                    -- odczekanie zadanego czasu przerwy 
            D := CONV_STD_LOGIC_VECTOR(character'pos(r(i)),D'length); -- pobranie i konwersja 'i-tego' znaku ASCII
            RX <= neg('1',N_SERIAL);                    -- ustawienie 'RX' na wartosc bitu START
            wait for O_BITU;                        -- odczekanie jednego bodu
            for i in 0 to B_SLOWA-1 loop                -- petla po kolejnych bitach slowa danych 'D'
              RX <= neg(neg(D(i),N_SLOWO),N_SERIAL);            -- ustawienie 'RX' na wartosc bitu 'D(i)'
              wait for O_BITU;                    -- odczekanie jednego bodu
            end loop;                            -- zakonczenie petli
            if (B_PARZYSTOSCI = 1) then                -- badanie aktywowania bitu parzystosci
              RX <= neg(neg(XOR_REDUCE(D),N_SLOWO),N_SERIAL);        -- ustawienie 'RX' na wartosc bitu parzystosci    
              wait for O_BITU;                    -- odczekanie jednego bodu
            end if;                            -- zakonczenie instukcji warunkowej
            for i in 0 to B_STOPOW-1 loop                -- petla po liczbie bitow STOP
              RX <= neg('0',N_SERIAL);                    -- ustawienie 'RX' na wartosc bitu STOP
              wait for O_BITU;                    -- odczekanie jednego bodu
            end loop;                            -- zakonczenie petli
          end loop;                            -- zakonczenie petli
          
          wait for 100000ns;
          RES <= '1'; wait for 100 ns;					
          RES <= '0'; wait  for 100 ns;
      end procedure;							-- proces bezwarunkowy
  begin			
    Numer_rozkazu <= 1;		
    send(r1, RX, R);			
    Numer_rozkazu <= 2;    
    send(r2, RX, R);
    Numer_rozkazu <= 3;							
    send(r3, RX, R);
    Numer_rozkazu <= 4;
    send(r4, RX, R);	
    Numer_rozkazu <= 5;
    send(r5, RX, R);
    wait;
  end process;							-- zakonczenie procesu
  
  serial_sum_inst: entity work.ASCIICalculator
    generic map (
      F_ZEGARA             => F_ZEGARA,				-- czestotliwosc zegata w [Hz]
      L_BODOW              => L_BODOW,				-- predkosc odbierania w [bodach]
      B_SLOWA              => B_SLOWA,				-- liczba bitow slowa danych (5-8)
      B_PARZYSTOSCI        => B_PARZYSTOSCI,			-- liczba bitow parzystosci (0-1)
      B_STOPOW             => B_STOPOW,				-- liczba bitow stopu (1-2)
      N_SERIAL             => N_SERIAL,				-- negacja logiczna sygnalu szeregowego
      N_SLOWO              => N_SLOWO,				-- negacja logiczna slowa danych
      L_BODOW_PRZERWY      => L_BODOW_PRZERWY			-- czas przerwy w nadawaniu w [bodach]
    )                      
    port map (             
      R                    => R,				-- sygnal resetowania
      C                    => C,				-- zegar taktujacy
      RX                   => RX,				-- odbierany sygnal szeregowy
      TX                   => TX				-- wysylany sygnal szeregowy
   );

  process is							-- proces bezwarunkowy
    function neg(V :std_logic; N :boolean) return std_logic is	-- deklaracja funkcji wewnetrznej 'neg'
    begin							-- czesc wykonawcza funkcji wewnetrznej
      if (N=FALSE) then return (V); end if;			-- zwrot wartosc 'V' gdy 'N'=FALSE
      return (not(V));						-- zwrot zanegowanej wartosci 'V'
    end function;						-- zakonczenie funkcji wewnetrznej

    variable D    :std_logic_vector(B_SLOWA-1 downto 0);	-- deklaracja zmiennej bufora bitow
    variable blad : boolean;					-- deklaracja zmiennej flagi bledu odbioru
  begin								-- czesc wykonawcza procesu
    D := (others => '0');					-- zerowanie bufora odbioru
    loop							-- nieskonczona petla odbioru danych
      blad := FALSE;						-- skasowanie  flagi bledu
      wait until neg(TX,N_SERIAL)='1';				-- oczekiwanie na poczatek bitu START
      wait for O_BITU/2;					-- odczekanie polowy trwania jednego bodu 
      if (neg(TX,N_SERIAL) /= '1') then				-- zbadanie niepoprawnosci stanu bit START
        blad := TRUE;						-- dla nieporawnego stanu ustawienie flagi BLAD
      end if;							-- zakonczenie instukcji warunkowej
      wait for O_BITU;						-- odczekanie okresu jednego bodu
      for i in 0 to B_SLOWA-1 loop				-- petla po kolejnych bitach odbieranej danej
        D(D'left-1 downto 0) := D(D'left downto 1);		-- przesuniecie bufora 'D' w prawo o jedna pozycje
        D(D'left) := neg(TX,N_SERIAL);				-- przypisanie odebranego bitu na najstarsza pozycje
        wait for O_BITU;					-- odczekanie okresu jednego bodu
      end loop;							-- zakonczenie petli
      if (B_PARZYSTOSCI = 1) then				-- badanie aktywowania bitu parzystosci
        if ((neg(TX,N_SERIAL) = XOR_REDUCE(D)) = N_SLOWO) then	-- zbadanie niezgodnosci stanu bitu parzystaosci
          blad := TRUE;						-- dla nieporawnego stanu ustawienie flagi BLAD
        end if;							-- zakonczenie instukcji warunkowej
        wait for O_BITU;					-- odczekanie okresu jednego bodu
      end if;							-- zakonczenie instukcji warunkowej
      for i in 0 to B_STOPOW-1 loop				-- petla po liczbie bitow STOP
        if (neg(TX,N_SERIAL) /= '0') then			-- zbadanie niepoprawnosci stanu bit STOP
          blad := TRUE;						-- dla nieporawnego stanu ustawienie flagi BLAD
        end if;							-- zakonczenie instukcji warunkowej
      end loop;							-- zakonczenie petli
      if (N_SLOWO=TRUE) then					-- zbadanie ustawienia flagi negacji danej
        D := not(D);						-- negacja odebranej danej dla usawionej flagi
      end if;							-- zakonczenie instukcji warunkowej
      WYNIK(WYNIK'left downto 2) <= WYNIK(WYNIK'left-1 downto 1); -- przesuniecie o jedna pozycje w lewo bufora znakow
      WYNIK(1) <= character'val(CONV_INTEGER(D));		-- przypisanie odebranej wartosci jako znaku ASCII
      if (blad=TRUE) then					-- zbadanie ustawienia flagi bledu
        WYNIK(1) <= '#';					-- przypisanie odebranego znaku na '#' jako bledu
      end if;							-- zakonczenie instukcji warunkowej
    end loop;							-- zakonczenie petli
  end process;							-- zakonczenie procesu

end behavioural;
