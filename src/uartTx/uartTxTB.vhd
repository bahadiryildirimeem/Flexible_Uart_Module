--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:14:44 09/14/2021
-- Design Name:   
-- Module Name:   /home/ise/bahadir_vs_fpga/uart_module_design/uart_tx_module/uartTx/uartTxTB.vhd
-- Project Name:  uartTx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uartTx
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
 
ENTITY uartTxTB IS
generic(
		CLK_FREQ				:			INTEGER 	:= 50_000_000;
		CONFIG_BIT_DEPTH	:			INTEGER	:= 12;
		MAX_BAUDRATE		:			INTEGER	:= 10_000_000;
		MAX_STOP_BIT		:			INTEGER	:= 2;
		INITIAL_BAUD_VAL	:			INTEGER	:= 115_200);
END uartTxTB;
 
ARCHITECTURE behavior OF uartTxTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
component uartTx is
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
end component uartTx;
    

   --Inputs
   signal clk : std_logic := '0';
   signal baudrate : integer	range	0 to	MAX_BAUDRATE := 1_000_000;
   signal stopBit : integer	range 0 to MAX_STOP_BIT + 1 := 0;
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal uartWrite : std_logic := '0';

 	--Outputs
   signal busy : std_logic;
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uartTx 
	GENERIC MAP(CLK_FREQ => 100_000_000,
					CONFIG_BIT_DEPTH => 12,
					MAX_BAUDRATE => 10_000_000,
					MAX_STOP_BIT => 2,
					INITIAL_BAUD_VAL => 115_200
	)
	PORT MAP (
          clk => clk,
          baudrate => baudrate,
          stopBit => stopBit,
          dataIn => dataIn,
          uartWrite => uartWrite,
          busy => busy,
          tx => tx
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
		dataIn <= x"AA";
		uartWrite <= '1';
		wait for 100 ns;
		uartWrite <= '0';
		wait for 20 us;
		
      -- insert stimulus here 

      wait;
   end process;

END;
