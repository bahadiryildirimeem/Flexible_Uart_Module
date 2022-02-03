LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY uartTx_FIFO_TB IS
END uartTx_FIFO_TB;
 
ARCHITECTURE behavior OF uartTx_FIFO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uartTx_FIFO
    PORT(
         CLK : IN  std_logic;
         DATI : IN  std_logic_vector(7 downto 0);
         STOP_BIT : IN  std_logic_vector(1 downto 0);
         DIVISOR : IN  std_logic_vector(11 downto 0);
         SEND : IN  std_logic;
         MEM_WE : IN  std_logic;
         MEM_FULL : OUT  std_logic;
         MEM_EMPTY : OUT  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal DATI : std_logic_vector(7 downto 0) := (others => '0');
   signal STOP_BIT : std_logic_vector(1 downto 0) := (others => '0');
   signal DIVISOR : std_logic_vector(11 downto 0) := (others => '0');
   signal SEND : std_logic := '0';
   signal MEM_WE : std_logic := '0';

 	--Outputs
   signal MEM_FULL : std_logic;
   signal MEM_EMPTY : std_logic;
   signal TX : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartTx_FIFO PORT MAP (
          CLK => CLK,
          DATI => DATI,
          STOP_BIT => STOP_BIT,
          DIVISOR => DIVISOR,
          SEND => SEND,
          MEM_WE => MEM_WE,
          MEM_FULL => MEM_FULL,
          MEM_EMPTY => MEM_EMPTY,
          TX => TX
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
		DIVISOR <= x"064";
		MEM_WE <= '1';
		DATI <= x"AA";
		wait for CLK_period;
		DATI <= x"BB";
		wait for CLK_period;
		DATI <= x"CC";
		wait for CLK_period;
		DATI <= x"DD";
		wait for CLK_period;
		DATI <= x"FF";
		wait for CLK_period;
		DATI <= x"55";
		wait for CLK_period;
		DATI <= x"11";
		wait for CLK_period;
		DATI <= x"22";
		wait for CLK_period;
		DATI <= x"33";
		MEM_WE <= '0';
		wait for CLK_period;
		SEND <= '1';
		wait for CLK_period;
		SEND <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
