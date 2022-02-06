library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_ECHO is
	Generic( CLK_FREQ   : INTEGER := 50_000_000;
	         SAMPLE_DPT : INTEGER := 8;
	         DIV_DPT    : INTEGER := 12;
				MEM_DPT    : INTEGER := 10);
    Port ( CLK          : in   STD_LOGIC;
           RX           : in   STD_LOGIC;
			  TX           : out  STD_LOGIC);
end uart_ECHO;

architecture Behavioral of uart_ECHO is

Component uart_FIFO is
	Generic( CLK_FREQ   : INTEGER := 100_000_000;
	         SAMPLE_DPT : INTEGER := 8;
	         DIV_DPT    : INTEGER := 12;
				MEM_DPT    : INTEGER := 10);
    Port ( CLK          : in   STD_LOGIC;
           STOP_BIT     : in   STD_LOGIC_VECTOR (1 downto 0);
           SAMPLE       : in   STD_LOGIC_VECTOR (SAMPLE_DPT-1 downto 0);
           DIVISOR      : in   STD_LOGIC_VECTOR (DIV_DPT-1 downto 0);
           TX_SEND      : in   STD_LOGIC;
           TX_MEM_WE    : in   STD_LOGIC;
           RX_MEM_READ  : in   STD_LOGIC;
           RX           : in   STD_LOGIC;
			  TX_MEM_DATI  : in   STD_LOGIC_VECTOR (7 downto 0);
           TX_MEM_FULL  : out  STD_LOGIC;
           TX_MEM_EMPTY : out  STD_LOGIC;
           RX_MEM_READY : out  STD_LOGIC;
           RX_BUSY      : out  STD_LOGIC;
           RX_MEM_FULL  : out  STD_LOGIC;
           RX_MEM_EMPTY : out  STD_LOGIC;
           RX_MEM_VLD   : out  STD_LOGIC;
           RX_MEM_DATO  : out  STD_LOGIC_VECTOR (7 downto 0);
			  TX           : out  STD_LOGIC);
end Component;

signal txStartQ : STD_LOGIC := '0';
signal txMemWQ : STd_LOGIC := '0';
signal rxMemR : STD_LOGIC := '0';
signal rxMemDatoQ : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal rxMemReadyQ : STD_LOGIC;
signal rxMemEmptyQ : STD_LOGIC;
signal readingStartedQ : STD_LOGIC := '0';

begin

U1: uart_FIFO
	Generic map( CLK_FREQ => CLK_FREQ,
	         SAMPLE_DPT => SAMPLE_DPT,
	         DIV_DPT => DIV_DPT,
				MEM_DPT => MEM_DPT)
    Port map( CLK => CLK,
           STOP_BIT => "00", -- NO Stop Bit
           SAMPLE => x"10", -- 16 Sample Rate
           DIVISOR => x"032", -- CLK_FREQ / 50
           TX_SEND => txStartQ,
           TX_MEM_WE => txMemWQ,
           RX_MEM_READ => rxMemR,
           RX => RX,
			  TX_MEM_DATI => rxMemDatoQ,
           TX_MEM_FULL => open,
           TX_MEM_EMPTY => open,
           RX_MEM_READY => rxMemReadyQ,
           RX_BUSY => open,
           RX_MEM_FULL => open,
           RX_MEM_EMPTY => rxMemEmptyQ,
           RX_MEM_VLD => open,
           RX_MEM_DATO => rxMemDatoQ,
			  TX => TX);
			  
process(CLK)
begin
   if(rising_edge(CLK)) then
	   txStartQ <= '0';
	   if(rxMemReadyQ = '1') then
		   rxMemR <= '1';
			readingStartedQ <= '1';
		end if;
		if(readingStartedQ = '1') then
		   txMemWQ <= '1';
		end if;
		if(rxMemEmptyQ = '1') then
		   if(readingStartedQ = '1') then
			   readingStartedQ <= '0';
			   txStartQ <= '1';
			end if;
		   rxMemR <= '0';
			txMemWQ <= '0';
		end if;
		
	end if;
end process;

end Behavioral;

