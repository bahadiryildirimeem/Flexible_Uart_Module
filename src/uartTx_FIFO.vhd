library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uartTx_FIFO is
    Generic(CLK_FREQ : INTEGER := 100_000_000;
	         DIV_DPT  : INTEGER := 12;
				MEM_DPT  : INTEGER := 10);
    Port ( CLK       : in   STD_LOGIC;
           DATI      : in   STD_LOGIC_VECTOR (7 downto 0);
           STOP_BIT  : in   STD_LOGIC_VECTOR (1 downto 0);
           DIVISOR   : in   STD_LOGIC_VECTOR (11 downto 0);
           SEND      : in   STD_LOGIC;
           MEM_WE    : in   STD_LOGIC;
           MEM_FULL  : out  STD_LOGIC;
           MEM_EMPTY : out  STD_LOGIC;
           TX        : out  STD_LOGIC);
end uartTx_FIFO;

architecture Behavioral of uartTx_FIFO is

Component uartTx is
    Generic(CLK_FREQ : INTEGER := 100_000_000;
	         DIV_DPT  : INTEGER := 12);
    Port ( CLK      : in  STD_LOGIC;
           DATI     : in  STD_LOGIC_VECTOR(7 downto 0);
			  STOP_BIT : in  STD_LOGIC_VECTOR(1 downto 0);
			  DIVISOR  : in  STD_LOGIC_VECTOR(DIV_DPT - 1 downto 0);
           SEND     : in  STD_LOGIC;
           BUSY     : out STD_LOGIC;
           TX       : out STD_LOGIC);
end Component;

Component FIFO_BRAM is
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

type statesHandle is (IDLE, START_SEQ, MEM_CHECK);

signal states    : statesHandle := IDLE;
signal busyQ     : STD_LOGIC;
signal oldBusyQ  : STD_LOGIC;
signal startQ    : STD_LOGIC;
signal memReadQ  : STD_LOGIC;
signal memWriteQ : STD_LOGIC;
signal emptyQ    : STD_LOGIC;
signal fullQ     : STD_LOGIC;
signal vldQ      : STD_LOGIC;
signal datoFifoQ : STD_LOGIC_VECTOR(7 DOWNTO 0);
begin

memWriteQ <= MEM_WE;
MEM_FULL <= fullQ;
MEM_EMPTY <= emptyQ;

U1: uartTx
    Generic map(CLK_FREQ => CLK_FREQ,
	             DIV_DPT  => DIV_DPT)
    Port map(CLK      => CLK,
             DATI     => datoFifoQ,
			    STOP_BIT => STOP_BIT,
			    DIVISOR  => DIVISOR,
             SEND     => startQ,
             BUSY     => busyQ,
             TX       => TX);

U2: FIFO_BRAM
  Generic map( WDT => 8,
               DPT => MEM_DPT)
    Port map( CLK => CLK,
              WE => memWriteQ,
              DATI => DATI,
              RE => memReadQ,
              DATO => datoFifoQ,
              VLD => vldQ,
              EMPTY => emptyQ,
              FULL => fullQ,
              AMOUNT => open);
process(CLK)
begin
   if(rising_edge(CLK)) then
	   case states is
		   when IDLE =>
			   memReadQ <= '0';
			   if(SEND = '1' and emptyQ = '0') then
				   memReadQ <= '1';
				   states <= START_SEQ;
				end if;
			when START_SEQ => 
			   memReadQ <= '0';
				startQ   <= '0';
				oldBusyQ <= busyQ;
				if(vldQ = '1') then
				   startQ <= '1';
				end if;
				if(busyQ = '0' and oldBusyQ = '1') then
				   states <= MEM_CHECK;
				end if;
			when MEM_CHECK =>
			   if(emptyQ = '1') then
				   states <= IDLE;
				else
				   memReadQ <= '1';
				   states <= START_SEQ;
				end if;
		end case;
	end if;
end process;

end Behavioral;

