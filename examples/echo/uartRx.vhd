library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uartRx is
    Generic(CLK_FREQ   : INTEGER := 100_000_000;
	         SAMPLE_DPT : INTEGER := 8;
	         DIV_DPT    : INTEGER := 12);
    Port ( CLK      : in   STD_LOGIC;
           SAMPLE   : in   STD_LOGIC_VECTOR (SAMPLE_DPT-1 downto 0);
           DIVISOR  : in   STD_LOGIC_VECTOR (DIV_DPT-1 downto 0);
           RX       : in   STD_LOGIC;
			  DONE     : out  STD_LOGIC;
           BUSY     : out  STD_LOGIC;
           DATO     : out  STD_LOGIC_VECTOR (7 downto 0));
end uartRx;

architecture Behavioral of uartRx is

type statesHandle is (IDLE, START, RECEIVE);

-- PORT SIGNALS
signal rxQM      : std_logic;
signal rxQ       : std_logic;
signal divisorQ  : INTEGER RANGE 0 TO (2**DIV_DPT)-1;
signal sampleQ   : INTEGER RANGE 0 TO (2**SAMPLE_DPT)-1;
signal doneQ     : std_logic := '0';
signal busyQ     : std_logic := '0';
signal datoQ     : std_logic_vector(7 downto 0);
-- INTERNAL SIGNALS
signal states       : statesHandle := IDLE;
signal rxFirstQ     : std_logic;
signal bitCnt       : INTEGER RANGE 0 TO 8 := 0;
signal baudCnt      : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal baudCntLim   : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal baudCntLimMin: INTEGER RANGE 0 TO CLK_FREQ := 0;
signal baudCntLimMax: INTEGER RANGE 0 TO CLK_FREQ := 0;
signal sampleCntLim : INTEGER RANGE 0 TO (2**SAMPLE_DPT)-1 := 0;

begin
sampleQ <= conv_integer(SAMPLE);
divisorQ <= conv_integer(DIVISOR);
DONE <= doneQ;
BUSY <= busyQ;

process(CLK)
begin
   if(rising_edge(CLK)) then
	   rxQM <= RX;
		rxQ <= rxQM; -- preventing metastability.
		case states is
		   when IDLE =>
			   doneQ <= '0';
			   if(rxQ = '0') then
				   busyQ <= '1';
				   bitCnt <= 0;
					baudCnt <= 0;
					baudCntLim <= divisorQ;
			      baudCntLimMin <= divisorQ/2 - sampleCntLim/2;
					baudCntLimMax <= divisorQ/2 + sampleCntLim/2;
					states <= START;
				else
				   busyQ <= '0';
				end if;
			when START => 
				baudCnt <= baudCnt + 1;
				if(baudCnt >= baudCntLimMin and baudCnt <= baudCntLimMax) then
					if(rxQ /= '0') then
						states <= IDLE;
					end if;
				end if;
				if(baudCnt = baudCntLim) then
					baudCnt <= 0;
					states <= RECEIVE;
				end if;
				when RECEIVE =>
				if(bitCnt = 8) then
				   busyQ <= '0';
				   doneQ <= '1';
					DATO <= datoQ;
				   states <= IDLE;
				else
					baudCnt <= baudCnt + 1;
					if(baudCnt = baudCntLimMin) then
						rxFirstQ <= rxQ;
					end if;
					if(baudCnt > baudCntLimMin and baudCnt <= baudCntLimMax) then
						if(rxQ /= rxFirstQ) then
							states <= IDLE;
						end if;
					end if;
					if(baudCnt = baudCntLim) then
						baudCnt <= 0;
						bitCnt <= bitCnt + 1;
						datoQ(bitCnt) <= rxFirstQ;
					end if;
				end if;
		end case;
	end if;
end process;

end Behavioral;

