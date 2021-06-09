library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ASCIICalculator is
    generic (
        F_ZEGARA		:natural := 20_000_000;			-- czestotliwosc zegata w [Hz]
        L_BODOW		    :natural := 9600;			-- predkosc nadawania w [bodach]
        B_SLOWA		    :natural := 8;				-- liczba bitow slowa danych (5-8)
        B_PARZYSTOSCI	:natural := 1;				-- liczba bitow parzystosci (0-1)
        B_STOPOW		:natural := 2;				-- liczba bitow stopu (1-2)
        N_SERIAL		:boolean := FALSE;			-- negacja logiczna sygnalu szeregowego
        N_SLOWO		    :boolean := FALSE;			-- negacja logiczna slowa danych
        L_CYFR		    :natural := 3;				-- liczba cyfr dziesietnych
        L_BODOW_PRZERWY	:natural := 0);				-- czas przerwy w nadawaniu w [bodach]
    Port ( C : in STD_LOGIC;
           R : in STD_LOGIC;
           RX: in std_logic;
           TX: out std_logic
           );
end ASCIICalculator;

architecture Behavioral of ASCIICalculator is
    signal slowo_in : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_gotowe : STD_LOGIC;
    signal rx_blad : STD_LOGIC;
    signal tx_wysylanie : STD_LOGIC;
    signal tx_nadaj : STD_LOGIC;
    signal in_number : STD_LOGIC := '0';
    signal out_number : STD_LOGIC := '0';
    signal calc_done : STD_LOGIC;
    signal nrToDgt_done : STD_LoGIC;
    signal digit : natural := 0;
    signal result : integer;
    signal result_digit : integer;
    signal result_character : STD_LOGIC_VECTOR(7 downto 0);
    signal trigger_nrToDgt: STD_LOGIC;
begin
    process (C)
        variable last_calc_done : std_logic := '0';
    begin
        if trigger_nrToDgt = '1' and nrToDgt_done = '0' then  -- przesuniêcie tx_nadaj o jeden tik zegara wzglêdem trigger_nrToDgt
            tx_nadaj <= '1';
        else
            tx_nadaj <= '0';
        end if;
        if calc_done = '1' and (last_calc_done = '0' or tx_wysylanie = '0' ) then
            trigger_nrToDgt <= '1';
        else
            trigger_nrToDgt <= '0';
        end if;
        last_calc_done := calc_done;
    end process;
    UART_RX: entity work.SERIAL_RX
     generic map (
         F_ZEGARA             => F_ZEGARA,                -- czestotliwosc zegata w [Hz]
         L_BODOW              => L_BODOW,                 -- predkosc odbierania w [bodach]
         B_SLOWA              => B_SLOWA,                 -- liczba bitow slowa danych (5-8)
         B_PARZYSTOSCI        => B_PARZYSTOSCI,           -- liczba bitow parzystosci (0-1)
         B_STOPOW             => B_STOPOW,                -- liczba bitow stopu (1-2)
         N_RX                 => N_SERIAL,                -- negacja logiczna sygnalu szeregowego
         N_SLOWO              => N_SLOWO                  -- negacja logiczna slowa danych
         )
    port map(
        R => R,
        C => C,
        RX => RX,
        SLOWO => slowo_in,
        GOTOWE => rx_gotowe,
        BLAD => rx_blad
    ); 
    ASCII_TO_NR: entity work.ASCIIToNumber
    port map (
        input => slowo_in,
        number => in_number,
        output => digit
    );
    CALC: entity work.Calculator 
    port map(
        reset => R,
        C => C,
        TRIGGER => rx_gotowe,
        input => digit,
        number => in_number,
        output => result,   
        done => calc_done
    );
    NrToDgt: entity work.NumberToDigits
    port map(
        R => '0',
        C => C,
        input => result,
        trigger => trigger_nrToDgt,
        output => result_digit,
        number => out_number,
        done => nrToDgt_done
    );
    NrToASCII: entity work.NumberToASCII
    port map(
        input => result_digit,
        number => out_number,
        output => result_character
    );
    UART_TX: entity work.UART_TX
    generic map (
             F_ZEGARA             => F_ZEGARA,                -- czestotliwosc zegata w [Hz]
             L_BODOW              => L_BODOW,                 -- predkosc odbierania w [bodach]
             B_SLOWA              => B_SLOWA,                 -- liczba bitow slowa danych (5-8)
             B_PARZYSTOSCI        => B_PARZYSTOSCI,           -- liczba bitow parzystosci (0-1)
             B_STOPOW             => B_STOPOW,                -- liczba bitow stopu (1-2)
             N_TX                 => N_SERIAL,                -- negacja logiczna sygnalu szeregowego
             N_SLOWO              => N_SLOWO                  -- negacja logiczna slowa danych
             )
    port map(
        R => R,
        C => C,
        TX => TX,
        SLOWO => result_character,
        NADAJ => tx_nadaj,
        WYSYLANIE => tx_wysylanie
    );

end Behavioral;
