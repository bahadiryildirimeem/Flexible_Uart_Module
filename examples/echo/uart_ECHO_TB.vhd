LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY uart_ECHO_TB IS
END uart_ECHO_TB;
 
ARCHITECTURE behavior OF uart_ECHO_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_ECHO
    PORT(
         CLK : IN  std_logic;
         RX : IN  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RX : std_logic := '1';

 	--Outputs
   signal TX : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_ECHO PORT MAP (
          CLK => CLK,
          RX => RX,
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

      		RX <= '0';
		wait for 1 us;
		RX <= '1';
		wait for 78 us;
		RX <= '0';
		wait for 8 us;
		for i in 0 to 7 loop
		RX <= not RX;
		wait for 8.68 us;
		end loop;
		RX <= '1';
		wait for 8.68 us;
		for i in 0 to 7 loop
		RX <= not RX;
		wait for 8.68 us;
		end loop;
		RX <= '1';
		wait for 8.68 us;
		for i in 0 to 7 loop
		RX <= not RX;
		wait for 8.68 us;
		end loop;
		wait for 1 us;
		RX <= '0';
		wait for 500 ns;
		RX <= '1';
		wait for 30 us;

      wait;
   end process;

END;
