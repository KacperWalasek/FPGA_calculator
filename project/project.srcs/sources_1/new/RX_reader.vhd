library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;


entity RX_reader	is			-- instancja odbiornika szeregowego 'SERIAL_RX'
    generic (
      B_SLOWA              :natural := 8;				-- liczba bitow slowa danych (5-8)
      B_PARZYSTOSCI       :natural := 1;			-- liczba bitow parzystosci (0-1)
      B_STOPOW             :natural := 2;				-- liczba bitow stopu (1-2)
      N_SLOWO             :boolean := FALSE			-- negacja logiczna slowa danych
    );
    port (			-- mapowanie sygnalow do portow  
      clk                   :in std_logic;
      bod_c                 :in std_logic;		 
      RX                    :in std_logic;	
      R : in std_logic;		-- odebrany sygnal szeregowy				-- flaga potwierdzenia odbioru
      tab :out std_logic_vector(B_SLOWA-1 downto 0);	
      done                    : out std_logic;
      blad :out std_logic			-- flaga wykrycia bledu w odbiorze
    );
   end RX_reader;
    
  architecture  behavioral of RX_reader	is
    signal change : std_logic:= '0';
  begin
        
    process(clk,RX,R) is
    variable c: natural :=0;
    variable d:std_logic :='0';
    variable p:std_logic :='0';
    variable last_bod_c: std_logic:='0';
    begin
        if R ='1' then
            c:=0;
            d:='0';
            p:='0';
            done<='0';
            blad<='0';
            tab<=(0 => '0', others => '0');
        elsif clk'event and d='0' then
            if last_bod_c = not bod_c then
                change<=not change;
                if c=B_SLOWA+1 then
                    -- sprawdŸ parzystoœæ
                    if p= not RX and B_PARZYSTOSCI = 1 then
                        blad <= '1';
                    end if;
                else 
                    if c>0 then
                        if N_SLOWO then
                            tab(c-1)<= not RX;
                        else 
                            tab(c-1)<= RX;
                        end if;
                        if RX='1' then
                            p:= not p;
                        end if;
                    end if;       
                end if;
                if c>0 or RX='1' then
                    c:=c+1;
                end if;
                if c>B_SLOWA+1 then
                    d:='1';
                    done<='1';
                end if;
            end if; --bod_c tick
        end if;
        last_bod_c:= bod_c;
    end process;
  	
  end behavioral;