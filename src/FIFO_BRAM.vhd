library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity FIFO_BRAM is
	 Generic(WDT	: integer range 1 to 1024 := 8;
				DPTH	: integer range 1 to 20	  := 10);
    Port ( CLK 	: in  	STD_LOGIC;
           WE 		: in  	STD_LOGIC;
           DATI 	: in  	STD_LOGIC_VECTOR (WDT-1 downto 0);
           RE 		: in  	STD_LOGIC;
           DATO 	: out  	STD_LOGIC_VECTOR (WDT-1 downto 0);
           VLD 	: out  	STD_LOGIC;
           EMPTY 	: out  	STD_LOGIC;
           FULL 	: out  	STD_LOGIC;
           AMOUNT : out  	STD_LOGIC_VECTOR (DPTH-1 downto 0));
end FIFO_BRAM;

architecture Behavioral of FIFO_BRAM is

type tip is array (2**DPTH-1 downto 0) of std_logic_vector(WDT-1 downto 0);

signal Mem 		: tip := (others => (others => '0'));
signal Wr_Cnt	: STD_LOGIC_VECTOR(DPTH-1 DOWNTO 0) := (others => '0');
signal Rd_Cnt	: STD_LOGIC_VECTOR(DPTH-1 DOWNTO 0) := (others => '0');
signal FrkCnt	: STD_LOGIC_VECTOR(DPTH-1 DOWNTO 0) := (others => '0');
signal Empq		: STD_LOGIC;
signal Fulq		: STD_LOGIC;
signal Vldq		: STD_LOGIC := '0';

begin

process(CLK)
begin
	if(rising_edge(CLK)) then
		--if(Vldq = '1') then
			Vldq <= '0';
		--end if;
		if(WE = '1' and Fulq = '0') then
			Mem (conv_integer(Wr_Cnt)) <= DATI;
			Wr_Cnt <= Wr_Cnt + 1;
		end if;
		if(RE = '1' and Empq = '0') then
			DATO <= Mem(conv_integer(Rd_Cnt));
			Rd_Cnt <= Rd_Cnt + 1;
			Vldq <= '1';
		end if;
		if(WE = '1') then
			if(RE = '0') then
				if(Fulq = '0') then
					FrkCnt <= FrkCnt + 1;
				end if;
			else
				
			end if;
		else
			if(RE = '1') then
				if(Empq = '0') then
					FrkCnt <= FrkCnt - 1;
				end if;
			else
				
			end if;
		end if;
	end if;
end process;

Empq <= '1' when (FrkCnt = conv_std_logic_vector(0, DPTH)) else '0';
Fulq <= '1' when (FrkCnt = conv_std_logic_vector(2**DPTH-1, DPTH)) else '0';

EMPTY <= Empq;
FULL 	<= Fulq;
VLD	<= Vldq;
AMOUNT <= FrkCnt;

end Behavioral;

