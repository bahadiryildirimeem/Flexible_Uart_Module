--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:37:39 09/15/2021
-- Design Name:   
-- Module Name:   /home/ise/bahadir_vs_fpga/uart_module_design/uart_rx_module/uartRx/uartRxTB.vhd
-- Project Name:  uartRx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uartRx
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY uartRxTB IS
	generic(	CLK_FREQ		:	INTEGER	:= 100_000_000;
				MAX_BAUDRATE	:	INTEGER	:= 10_000_000
				);
END uartRxTB;
 
ARCHITECTURE behavior OF uartRxTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component uartRx is
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
	end component uartRx;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rx : std_logic := '1';
   signal baudrate : INTEGER RANGE 0 TO MAX_BAUDRATE + 1 := 1_000_000;
   signal sampleRate : INTEGER RANGE 0 TO MAX_BAUDRATE + 1 := 16;
   signal readingComplete : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal dataReady : std_logic;
   signal dataOut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartRx GENERIC MAP(
			CLK_FREQ => CLK_FREQ,
			MAX_BAUDRATE => MAX_BAUDRATE
	)
	PORT MAP (
          clk => clk,
          rx => rx,
          baudrate => baudrate,
          sampleRate => sampleRate,
          readingComplete => readingComplete,
          busy => busy,
          dataReady => dataReady,
          dataOut => dataOut
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		rx <= '0';
		wait for 1 us;
		for i in 0 to 7 loop
			rx <= not rx;
			wait for 1 us;
		end loop;
		rx <= '1';
		wait for 100 ns;
		readingComplete <= '1';
		wait for 100 ns;
		readingComplete <= '0';
		wait for 10 us;
		rx <= '0';
		wait for 100 ns;
		
		for i in 0 to 7 loop
			--rx <= not rx;
			wait for 1 us;
		end loop;
		rx <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
