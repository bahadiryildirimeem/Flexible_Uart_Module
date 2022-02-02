LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY uartTx_TB IS
END uartTx_TB;
 
ARCHITECTURE behavior OF uartTx_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uartTx
    PORT(
         CLK : IN  std_logic;
         DATI : IN  std_logic_vector(7 downto 0);
         STOP_BIT : IN  std_logic_vector(1 downto 0);
         DIVISOR : IN  std_logic_vector(11 downto 0);
         SEND : IN  std_logic;
         BUSY : OUT  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal DATI : std_logic_vector(7 downto 0) := (others => '0');
   signal STOP_BIT : std_logic_vector(1 downto 0) := (others => '0');
   signal DIVISOR : std_logic_vector(11 downto 0) := (others => '0');
   signal SEND : std_logic := '0';

 	--Outputs
   signal BUSY : std_logic;
   signal TX : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartTx PORT MAP (
          CLK => CLK,
          DATI => DATI,
          STOP_BIT => STOP_BIT,
          DIVISOR => DIVISOR,
          SEND => SEND,
          BUSY => BUSY,
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
		DATI <= x"AA";
		DIVISOR <= x"064";
		STOP_BIT <= "00";
		wait for CLK_period;
		SEND <= '1';
		wait for CLK_period;
		SEND <= '0';
		wait for 10 us;
		DATI <= x"55";
		DIVISOR <= x"0C8";
		STOP_BIT <= "01";
		wait for CLK_period;
		SEND <= '1';
		wait for CLK_period;
		SEND <= '0';
		wait for 15 us;

      -- insert stimulus here 

      wait;
   end process;

END;
