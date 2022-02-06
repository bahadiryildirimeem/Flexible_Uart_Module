LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY uartRx_FIFO_TB IS
END uartRx_FIFO_TB;
 
ARCHITECTURE behavior OF uartRx_FIFO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uartRx_FIFO
    PORT(
         CLK : IN  std_logic;
         SAMPLE : IN  std_logic_vector(7 downto 0);
         DIVISOR : IN  std_logic_vector(11 downto 0);
         RX : IN  std_logic;
         MEM_READ : IN  std_logic;
         READY : OUT  std_logic;
         BUSY : OUT  std_logic;
         MEM_FULL : OUT  std_logic;
         MEM_EMPTY : OUT  std_logic;
         MEM_VLD : OUT  std_logic;
         DATO : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal SAMPLE : std_logic_vector(7 downto 0) := (others => '0');
   signal DIVISOR : std_logic_vector(11 downto 0) := (others => '0');
   signal RX : std_logic := '1';
   signal MEM_READ : std_logic := '0';

 	--Outputs
   signal READY : std_logic;
   signal BUSY : std_logic;
   signal MEM_FULL : std_logic;
   signal MEM_EMPTY : std_logic;
   signal MEM_VLD : std_logic;
   signal DATO : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartRx_FIFO PORT MAP (
          CLK => CLK,
          SAMPLE => SAMPLE,
          DIVISOR => DIVISOR,
          RX => RX,
          MEM_READ => MEM_READ,
          READY => READY,
          BUSY => BUSY,
          MEM_FULL => MEM_FULL,
          MEM_EMPTY => MEM_EMPTY,
          MEM_VLD => MEM_VLD,
          DATO => DATO
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

      wait for CLK_period*10;
		DIVISOR <= x"064"; -- clk_freq / 100 = 1M baud
		SAMPLE <= x"10"; -- 16 sample
      wait for CLK_period;
		RX <= '0';
		wait for 1 us;
		RX <= '1';
		wait for 8 us;
		RX <= '0';
		wait for 1 us;
		for i in 0 to 7 loop
		RX <= not RX;
		wait for 1 us;
		end loop;
		RX <= '1';
		wait for 1 us;
		RX <= '0';
		wait for 500 ns;
		RX <= '1';
		wait for 8 us;
		MEM_READ <= '1';
		wait for 500 ns;
      wait;
   end process;

END;
