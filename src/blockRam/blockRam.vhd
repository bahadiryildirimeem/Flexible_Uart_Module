----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:53 09/26/2021 
-- Design Name: 
-- Module Name:    blockRam - Behavioral 
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

entity blockRam is
generic(	BIT_WIDTH					:	INTEGER 	:= 8;
			BLOCK_SIZE_2S_POW			:	INTEGER	:= 10;
			B_RAM_STYLE					:	STRING	:=	"BLOCK");
port( clk		:	IN		STD_LOGIC;
		addr		:	IN		INTEGER RANGE 0 TO 2**BLOCK_SIZE_2S_POW - 1;
		dataIn	:	IN 	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0);
		wren		:	IN		STD_LOGIC;
		dataOut	:	OUT	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0));
end blockRam;

architecture Behavioral of blockRam is 

type			ramBlockHandle	is array (2**BLOCK_SIZE_2S_POW - 1 DOWNTO 0) of STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0);
signal		ramBlk		:	ramBlockHandle	:= (others=>(others=>'0'));
attribute	ram_style	:	string;
attribute	ram_style of ramBlk	: signal is B_RAM_STYLE;

-- port signals
signal	addrSig		:	INTEGER RANGE 0 TO 2**BLOCK_SIZE_2S_POW	:= 0;
signal	dataInSig	:	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0) := (others => '0');
signal	wrenSig		:	STD_LOGIC := '0';
signal	dataOutSig	:	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0)	:= (others => '0');

begin
	addrSig <= addr;
	dataInSig <= dataIn;
	wrenSig <= wren;
	dataOut <= dataOutSig;
	dataOutSig <= ramBlk(addrSig);
		
	process(clk)
	constant	maxAddr	:	INTEGER := 2**BLOCK_SIZE_2S_POW;
	begin
		if(rising_edge(clk)) then
			if(wren = '1') then
				ramBlk(addrSig) <= dataInSig;
			end if;
		end if;
	end process;

end Behavioral;

