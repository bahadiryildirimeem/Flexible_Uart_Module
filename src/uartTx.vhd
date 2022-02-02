library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- baudrate calculation:
-- baudrate : CLK_FREQ / DIVISOR
entity uartTx is
    Generic( CLK_FREQ : INTEGER := 100_000_000;
	         DIV_DPT  : INTEGER := 12);
    Port ( 	CLK      : in  STD_LOGIC;
			DATI     : in  STD_LOGIC_VECTOR(7 downto 0);
			STOP_BIT : in  STD_LOGIC_VECTOR(1 downto 0);
			DIVISOR  : in  STD_LOGIC_VECTOR(DIV_DPT - 1 downto 0);
			SEND     : in  STD_LOGIC;
			BUSY     : out STD_LOGIC;
			TX       : out STD_LOGIC);
end uartTx;

architecture Behavioral of uartTx is
type statesHandle is (IDLE, START, DATA_SENDING, STOP_SEND);

-- PORT SIGNALS
signal datiQ    : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal stopBitQ : INTEGER RANGE 0 TO 2;
signal divQ     : INTEGER RANGE 0 TO (2**DIV_DPT) - 1;
signal busyQ    : STD_LOGIC;
signal txQ      : STD_LOGIC;

-- INTERNAL SIGNALS
signal states     : statesHandle := IDLE;
signal baudCnt    : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal baudCntLim : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal bitCnt     : INTEGER RANGE 0 TO 7 := 0;
signal stopCnt    : INTEGER RANGE 0 TO 2 := 0;

begin
stopBitQ <= conv_integer(STOP_BIT);
divQ <= conv_integer(DIVISOR);
BUSY <= busyQ;
TX <= txQ;

process(CLK)
begin
   if(rising_edge(CLK)) then
	   case states is
		   when IDLE =>
				if(SEND = '1') then
				   baudCnt <= 0;
					baudCntLim <= divQ - 1;
					bitCnt <= 0;
					stopCnt <= 0;
					datiQ <= DATI;
				   busyQ <= '1';
					states <= START;
				else
				   busyQ <= '0';
				   txQ <= '1';
				end if;
			when START =>
			   txQ <= '0';
			   baudCnt <= baudCnt + 1;
				if(baudCnt = baudCntLim) then
				   baudCnt <= 0;
				   states <= DATA_SENDING;
				end if;
			when DATA_SENDING =>
			    if(bitCnt = 8) then
				   baudCnt <= 0;
				   bitCnt <= 0;
				   states <= STOP_SEND;
				else
				   txQ <= datiQ(bitCnt);
				   baudCnt <= baudCnt + 1;
				end if;
				if(baudCnt = baudCntLim) then
					baudCnt <= 0;
					bitCnt <= bitCnt + 1;
				end if;
			when STOP_SEND => 
			    txQ <= '1';
			    if(bitCnt = stopBitQ) then
				   busyQ <= '0';
					states <= IDLE;
				else
				   baudCnt <= baudCnt + 1;
				end if;
				if(baudCnt = baudCntLim) then
				    baudCnt <= 0;
					bitCnt <= bitCnt + 1;
				end if;
		end case;
	end if;
end process;

end Behavioral;

