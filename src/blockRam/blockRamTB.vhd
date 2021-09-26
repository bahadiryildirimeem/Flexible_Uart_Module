--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:41 09/26/2021
-- Design Name:   
-- Module Name:   /home/ise/bahadir_vs_fpga/ram_module/blockRam/blockRamTB.vhd
-- Project Name:  blockRam
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: blockRam
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
 
ENTITY blockRamTB IS
generic(	BIT_WIDTH					:	INTEGER 	:= 8;
			BLOCK_SIZE_2S_POW			:	INTEGER	:= 10;
			B_RAM_STYLE					:	STRING	:=	"BLOCK");
END blockRamTB;
 
ARCHITECTURE behavior OF blockRamTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
component blockRam is
generic(	BIT_WIDTH					:	INTEGER 	:= 8;
			BLOCK_SIZE_2S_POW			:	INTEGER	:= 10;
			B_RAM_STYLE					:	STRING	:=	"BLOCK");
port( clk		:	IN		STD_LOGIC;
		addr		:	IN		INTEGER RANGE 0 TO 2**BLOCK_SIZE_2S_POW - 1;
		dataIn	:	IN 	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0);
		wren		:	IN		STD_LOGIC;
		dataOut	:	OUT	STD_LOGIC_VECTOR(BIT_WIDTH - 1 DOWNTO 0));
end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal addr : INTEGER RANGE 0 TO 2**BLOCK_SIZE_2S_POW;
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal wren : std_logic := '0';

 	--Outputs
   signal dataOut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: blockRam PORT MAP (
          clk => clk,
          addr => addr,
          dataIn => dataIn,
          wren => wren,
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

      -- insert stimulus here 

      wait;
   end process;

END;
