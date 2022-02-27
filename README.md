# Flexible_Uart_Module
 To improve my digital design skills and contribute something useful for open source community, I have created this repo. VHDL language was used in module designs.
 
 This module uses Block RAM as FIFO memory in FPGA. This feature helps the use less logic element utilization. Meaning of the Flexible in that module is you can change baudrate and sample rate during module is running. Module divides the clock and runs according to new divided value.
 
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

 In heritance diagram for UART module following.
 
![flexible_uart](https://user-images.githubusercontent.com/45585791/152695710-ec512817-6a29-49c6-92b2-1ce1012e5959.jpg)

Here, you can find my testing setup.

![setup](https://user-images.githubusercontent.com/45585791/155894473-36d3023d-0576-45a3-952e-0a045eade21b.jpeg)

And the implementation results.

![echo_example](https://user-images.githubusercontent.com/45585791/155894412-ef07fa14-90cd-4e2d-9ce8-08ea21cefc99.jpeg)
 
# WARNING!
 I have designed this module for my project. So I don't need parity that exist in UART protocol. Be aware that please. 
