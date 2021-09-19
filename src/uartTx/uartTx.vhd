----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:52 09/13/2021 
-- Design Name: 
-- Module Name:    uartTx - Behavioral 
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

entity uartTx is
generic(
		CLK_FREQ				:			INTEGER 	:= 50_000_000;
		CONFIG_BIT_DEPTH	:			INTEGER	:= 12;
		MAX_BAUDRATE		:			INTEGER	:= 10_000_000;
		MAX_STOP_BIT		:			INTEGER	:= 2;
		INITIAL_BAUD_VAL	:			INTEGER	:= 115_200);
port(
		clk					:	in		std_logic;
		baudrate				:	in		integer	range	0 to	MAX_BAUDRATE;
		stopBit				:	in		integer	range 0 to MAX_STOP_BIT + 1;
		dataIn				:	in		std_logic_vector(7 downto 0);
		uartWrite			:	in		std_logic;
		busy					:	out	std_logic;
		tx						:	out	std_logic);
end uartTx;

architecture Behavioral of uartTx is
		type 		uartTx_st is (IDLE, START, SEND, STOP);
		signal	uartTx_states 	:	uartTx_st	:= IDLE;
		signal	baudrateSig		:	integer	range	0 to MAX_BAUDRATE := INITIAL_BAUD_VAL;	
		signal	stopBitSig		:	integer	range 0 to MAX_STOP_BIT + 1;
		signal	dataInSig		:	std_logic_vector(7 downto 0) := (others=> '0');
		signal	uartWriteSig	:	std_logic := '1';
		signal	busySig			:	std_logic := '0';
		signal	txSig				:	std_logic := '1';
		
begin
	baudrateSig	<= baudrate;
	stopBitSig <= stopBit;
	dataInSig <= dataIn;
	tx	<= txSig;
	uartWriteSig <= uartWrite;
	busy <= busySig;

	process(clk)
	variable dataBitCounter 	: 	integer  range 0 to 2**3					:= 0;
	variable	stopBitCounter		:	integer	range 0 to MAX_STOP_BIT + 1	:= 0;
	variable	stopBitCounterLim	:	integer	range 0 to MAX_STOP_BIT + 1	:= 0;
	variable baudCounter			:	integer	range 0 to CLK_FREQ + 1 		:= 0;
	variable	baudCounterLim		:	integer	range 0 to CLK_FREQ + 1 		:= CLK_FREQ/INITIAL_BAUD_VAL;
	variable	baudVal				:	integer	range 0 to MAX_BAUDRATE			:= INITIAL_BAUD_VAL;

		
	begin
		if(rising_edge(clk)) then
			case uartTx_states is
				when 	IDLE 	=>
					txSig <= '1';
					if(uartWriteSig = '1') then
						dataBitCounter := 0;
						stopBitCounter	:= 0;
						baudCounter		:= 0;
						baudCounterLim	:= CLK_FREQ/baudrateSig - 1;
						stopBitCounterLim := stopBitSig;
						busySig <= '1';
						uartTx_states <= START;
					end if;
				when 	START => 
					txSig <= '0';
					baudCounter	:= baudCounter + 1;
					if(baudCounter >= baudCounterLim) then
						uartTx_states <= SEND;
						baudCounter	:= 0;
					end if;
				when	SEND	=>
					txSig <= dataInSig(dataBitCounter);
					baudCounter := baudCounter + 1;
					if(baudCounter >= baudCounterLim) then
						baudCounter  := 0;
						dataBitCounter := dataBitCounter + 1;
						if(dataBitCounter >= 8) then
							uartTx_states <= STOP;
							if(stopBitSig > MAX_STOP_BIT) then
								uartTx_states <= IDLE;
							end if;
						end if;
					end if;
				when	STOP	=>
					if(stopBitCounter >= stopBitCounterLim) then
						uartTx_states <= IDLE;
						busySig <= '0';
					else
						txSig <= '0';
					end if;
					baudCounter := baudCounter + 1;
					if(baudCounter >= baudCounterLim) then
						stopBitCounter := stopBitCounter + 1;
						baudCounter := 0;
					end if;
				end case;
		end if;
	end process;


end Behavioral;

