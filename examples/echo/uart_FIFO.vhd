library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_FIFO is
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
end uart_FIFO;

architecture Behavioral of uart_FIFO is

Component uartTx_FIFO is
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
end Component;

Component uartRx_FIFO is
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
end Component;

begin

U1: uartTx_FIFO
    Generic map(CLK_FREQ => CLK_FREQ,
	         DIV_DPT => DIV_DPT,
				MEM_DPT => MEM_DPT)
    Port map( CLK => CLK,
				  DATI => TX_MEM_DATI,
              STOP_BIT => STOP_BIT,
              DIVISOR => DIVISOR,
              SEND => TX_SEND,
              MEM_WE => TX_MEM_WE,
              MEM_FULL => TX_MEM_FULL,
              MEM_EMPTY => TX_MEM_EMPTY,
              TX => TX);

U2: uartRx_FIFO
	Generic map( CLK_FREQ => CLK_FREQ,
	         SAMPLE_DPT => SAMPLE_DPT,
	         DIV_DPT => DIV_DPT,
				MEM_DPT => MEM_DPT)
    Port map( CLK =>  CLK,
           SAMPLE => SAMPLE,
           DIVISOR => DIVISOR,
           RX => RX,
			  MEM_READ => RX_MEM_READ,
           READY => RX_MEM_READY,
           BUSY => RX_BUSY,
           MEM_FULL => RX_MEM_FULL,
           MEM_EMPTY => RX_MEM_EMPTY,
			  MEM_VLD => RX_MEM_VLD,
           DATO => RX_MEM_DATO);
end Behavioral;

