----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:40:11 09/14/2021 
-- Design Name: 
-- Module Name:    uartRx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uartRx is
generic(	CLK_FREQ		:	INTEGER	:= 50_000_000;
			MAX_BAUDRATE	:	INTEGER	:= 10_000_000
			);
port(	clk						: 	in			STD_LOGIC;
		rx							:	in			STD_LOGIC;
		baudrate					:	in			INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
		sampleRate				:	in			INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
		readingComplete		:	in			STD_LOGIC;
		busy						:	out		STD_LOGIC;
		dataReady				:	out		STD_LOGIC;
		dataOut					:	out		STD_LOGIC_VECTOR(7 DOWNTO 0));
end uartRx;

architecture Behavioral of uartRx is
TYPE		uartRx_states	is (IDLE, START, RECEIVE);
signal	uartRxSt				:	uartRx_states	:= IDLE;
signal	rxSig					:	STD_LOGIC;
signal	baudrateSig			:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
signal	sampleRateSig		:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
signal	busySig				:	STD_LOGIC	:= '0';
signal	dataReadySig		:	STD_LOGIC	:= '0';
signal	readingCompleteSig:	STD_LOGIC;
signal	dataOutSig			:	STD_LOGIC_VECTOR(7 DOWNTO 0)	:= x"00";

begin
rxSig <= rx;
baudrateSig <= baudrate;
sampleRateSig <= sampleRate;
busy <= busySig;
readingCompleteSig <= readingComplete;
dataOut <= dataOutSig;

	main: process(clk)
	variable baudCounter			:	INTEGER RANGE 0 TO CLK_FREQ + 1 := 0;
	variable baudCountLim		:	INTEGER RANGE 0 TO CLK_FREQ + 1 := (CLK_FREQ / baudrateSig)- 1;
	variable sampleRateOffset	:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
	variable sampleRateMinOff	:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1;
	variable sampleRateMaxOff	:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1 := (CLK_FREQ / baudrateSig)- 1;
	variable sampleRateCountLim:	INTEGER RANGE 0 TO MAX_BAUDRATE + 1 := sampleRateSig;
	variable rcvdData				:	STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	variable	dataBitCounter		:	INTEGER RANGE 0 TO 8 := 0;
	variable	oldRx					:	STD_LOGIC	:= '1';
	
	begin
		if(rising_edge(clk)) then
			case uartRxSt is
				when IDLE =>
					if(oldRx = '1' and rxSig = '0') then -- falling edge detection.
						busySig <= '1';
						baudCounter := 0;
						baudCountLim := (CLK_FREQ / baudrateSig) - 1;
						sampleRateOffset	:= (baudCountLim + 1) / 2;
						sampleRateMinOff	:= sampleRateOffset - (sampleRateCountLim / 2);
						sampleRateMaxOff	:= sampleRateOffset + (sampleRateCountLim / 2);
						if(sampleRateCountLim > baudCountLim) then
							uartRxSt <= IDLE;
						else
							uartRxSt <= START;
						end if;
						dataBitCounter := 0;
					else
						busySig <= '0';
					end if;
					if(oldRx /= rxSig) then
						oldRx := rxSig;
					end if;
				when START =>
					baudCounter := baudCounter + 1;
					if((baudCounter >= sampleRateMinOff) and (baudCounter < sampleRateMaxOff)) then
						if(rxSig /= '0') then
							uartRxSt <= IDLE;
						end if;
					elsif(baudCounter >= sampleRateMaxOff) then
						baudCounter := 0;
						uartRxSt <= RECEIVE;
					end if;
				when RECEIVE =>
					baudCounter := baudCounter + 1;
					if((baudCounter > sampleRateMinOff) and (baudCounter < sampleRateMaxOff)) then
						if(oldRx /= rxSig) then
							uartRxSt <= IDLE;
						end if;
					elsif(baudCounter = sampleRateMinOff) then
						oldRx := rxSig;
					elsif(baudCounter >= sampleRateMaxOff) then
						dataBitCounter := dataBitCounter + 1;
						baudCounter := 0;
						if(dataBitCounter >= 8) then
							dataOutSig <= rcvdData;
							busySig <= '0';
							dataReadySig <= '1';
							uartRxSt <= IDLE;
						else
							rcvdData(dataBitCounter) := rxSig;
						end if;
					end if;
			end case;
		end if;
	end process main;

transferControl:process(readingComplete)
	begin
		if(rising_edge(readingComplete)) then
			dataReadySig <= '0';
		end if;
	end process transferControl;
end Behavioral;

