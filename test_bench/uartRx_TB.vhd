LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY uartRx_TB IS
END uartRx_TB;
 
ARCHITECTURE behavior OF uartRx_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uartRx
    PORT(
         CLK : IN  std_logic;
         SAMPLE : IN  std_logic_vector(7 downto 0);
         DIVISOR : IN  std_logic_vector(11 downto 0);
         RX : IN  std_logic;
         DONE : OUT  std_logic;
         BUSY : OUT  std_logic;
         DATO : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal SAMPLE : std_logic_vector(7 downto 0) := (others => '0');
   signal DIVISOR : std_logic_vector(11 downto 0) := (others => '0');
   signal RX : std_logic := '1';

 	--Outputs
   signal DONE : std_logic;
   signal BUSY : std_logic;
   signal DATO : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartRx PORT MAP (
          CLK => CLK,
          SAMPLE => SAMPLE,
          DIVISOR => DIVISOR,
          RX => RX,
          DONE => DONE,
          BUSY => BUSY,
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
      wait;
   end process;

END;
