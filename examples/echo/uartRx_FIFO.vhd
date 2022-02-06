library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uartRx_FIFO is
	Generic( CLK_FREQ   : INTEGER := 100_000_000;
	         SAMPLE_DPT : INTEGER := 8;
	         DIV_DPT    : INTEGER := 12;
				MEM_DPT    : INTEGER := 10);
    Port ( CLK       : in   STD_LOGIC;
           SAMPLE    : in   STD_LOGIC_VECTOR (SAMPLE_DPT-1 downto 0);
           DIVISOR   : in   STD_LOGIC_VECTOR (DIV_DPT-1 downto 0);
           RX        : in   STD_LOGIC;
			  MEM_READ  : in   STD_LOGIC;
           READY     : out  STD_LOGIC;
           BUSY      : out  STD_LOGIC;
           MEM_FULL  : out  STD_LOGIC;
           MEM_EMPTY : out  STD_LOGIC;
			  MEM_VLD   : out  STD_LOGIC;
           DATO      : out  STD_LOGIC_VECTOR (7 downto 0));
end uartRx_FIFO;

architecture Behavioral of uartRx_FIFO is

Component uartRx
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
end Component;

Component FIFO_BRAM
  generic( WDT    : integer range 1 to 1024 :=  8 ;
           DPT    : integer range 1 to   20 := 10 );
    Port ( CLK    : in  STD_LOGIC;
           WE     : in  STD_LOGIC;
           DATI   : in  STD_LOGIC_VECTOR (WDT-1 downto 0);
           RE     : in  STD_LOGIC;
           DATO   : out STD_LOGIC_VECTOR (WDT-1 downto 0);
           VLD    : out STD_LOGIC;
           EMPTY  : out STD_LOGIC;
           FULL   : out STD_LOGIC;
           AMOUNT : out STD_LOGIC_VECTOR (DPT-1 downto 0));
end Component;

-- PORT SIGNALS
signal doneQ    : STD_LOGIC;
signal busyQ    : STD_LOGIC;
signal readyQ   : STD_LOGIC;
signal memEmptyQ: STD_LOGIC;
signal rxDatoQ  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal divisorQ : STD_LOGIC_VECTOR(DIV_DPT-1 DOWNTO 0);
-- INTERNAL SIGNALS
type statesHandle is (IDLE, RECEIVING, REC_DONE);
signal states         : statesHandle := IDLE;
signal recTimeoutQ    : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal recTimeoutLimQ : INTEGER RANGE 0 TO CLK_FREQ := 0;
signal rxBusyQ        : std_logic;

begin
divisorQ <= DIVISOR;
BUSY <= busyQ;
READY <= readyQ;
MEM_EMPTY <= memEmptyQ;

    U1: uartRx
    Generic map(CLK_FREQ => CLK_FREQ,
	             SAMPLE_DPT => SAMPLE_DPT,
	             DIV_DPT => DIV_DPT)
    Port map( CLK => CLK,
              SAMPLE => SAMPLE,
              DIVISOR => divisorQ,
              RX => RX,
			     DONE => doneQ,
              BUSY => rxBusyQ,
              DATO => rxDatoQ);
    U2: FIFO_BRAM
   Generic map( WDT => 8,
                DPT => MEM_DPT)
    Port map(   CLK => CLK,
                WE => doneQ,
                DATI => rxDatoQ,
                RE => MEM_READ,
                DATO => DATO,
                VLD => MEM_VLD,
                EMPTY => memEmptyQ,
                FULL => MEM_FULL,
                AMOUNT => open);
process(CLK)
begin
   if(rising_edge(CLK)) then
	   case states is
		   when IDLE =>
			   busyQ <= '0';
			   readyQ <= '0';
			   if(rxBusyQ = '1') then
				   busyQ <= '1';
				   recTimeoutLimQ <= (2 * conv_integer(divisorQ)) + 1;
				   states <= RECEIVING;
				end if;
				if(recTimeoutQ /= 0) then
				   recTimeoutQ <= recTimeoutQ + 1;
					if(recTimeOutQ = recTimeOutLimQ) then
					   if(memEmptyQ = '0') then
							readyQ <= '1';
							recTimeOutQ <= 0;
						end if;
					end if;
				end if;
			when RECEIVING => 
			   if(rxBusyQ = '0') then
				   if(doneQ = '1') then
					   recTimeoutQ <= 0;
					   states <= REC_DONE;
					else
					   states <= IDLE;
					end if;
				end if;
			when REC_DONE => 
			   recTimeoutQ <= recTimeoutQ + 1;
				if(rxBusyQ = '0') then
					if(recTimeoutQ = recTimeoutLimQ) then
						readyQ <= '1';
						states <= IDLE;
					end if;
				else
				  states <= RECEIVING;
				end if;
		end case;
	end if;
end process;
end Behavioral;

