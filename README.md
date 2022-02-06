# Flexible_Uart_Module
 To improve my digital design skills and contribute something useful for open source community, I have created this repo. VHDL language was used in module designs.
 
baudrate_calc.xlsx file will help you to configure baudrate value according to sample and clock division values.
 
 I have synthesized UART module in Xilinx ISE 14.7 for Spartan 6 XC6SLX16. You can find device utilization summary following.
 
 | Logic Utilization                | Used | Available | Utilization |
 | -------------------------------- |------| ----------|-------------|
 | Number of Slice Registers        | 222  |18224      | 1%          |
 | Number of Slice LUTs             | 389  |9112       | 4%          |
 | Number of full used LUT-FF pairs | 175  |436        | 40%         |
 | Number of bonded IOBs            | 43   |232        | 18%         |
 | Number of Block RAM/FIFO         | 1    |32         | 3%          |
 | Number of BUFG/BUFGCTRLs         | 1    |16         | 6%          |

 
# WARNING!
 I have designed this module for my project. So I don't need parity that exist in UART protocol. Be aware that please. 
