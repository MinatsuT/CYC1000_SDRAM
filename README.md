# CYC1000 Nios SDRAM example
A sample Quartus Prime project for CYC1000 works with on-board 8MB SDRAM. This project is based on the [reference NIOS design provided by TrenzElectronic](https://wiki.trenz-electronic.de/display/PD/NIOS:https://wiki.trenz-electronic.de/display/PD/NIOS), and fixed sdram related issues.

## Changes from original reference design
- SDRAM related port directions (input or output) defined in the top module (top.v) are fixed.
- A **phase shifted** PLL output and its output **pin** are added for SDRAM clock.
- Sample Eclipse projects are included, which use SDRAM as a main memory.

## How to build and run
1. Clone this project, and open **cyc1000_nios.qpf** by Quartus Prime 20.1 or later.
2. Double click the **top** entity at the hierarchy window of the Quartus Prime, then read instructions in **top.v** file.
3. According to the instructions, **Start Compile**. Then **program your CYC1000**.
4. **Run Eclipse** from the menu [Tools->Nios II Software Build Tools for Eclipse].
5. Choose the project top directory as an Eclipse workspace.
6. Import **LedCopy_bsp** and **LedCopy** projects located under the **software/** by the following steps:
    1. Click the menu [File->**import**], select [Nios II Software Build Tools Projectl->**Import Nios II Software Build Tools Project**] and click **Next**.
    2. Click **Browse** and choose **software/LedCopy_bsp** under the project top directory.
    3. Enter **LedCopy_bsp** as a project name.
    4. Click **Finish**.
    5. Import **LedCopy** project by the same steps.
10. Build **LedCopy_bsp** project **first**. After that, build **LedCopy** project. If you are using Linux and failed to build LedCopy_bsp due to errors in Makefile, **right click** the LedCopy_bsp project and re-generate bsp from [Nios II->**Generate BSP**].
10. **Run LedCopy** project by "Run As"->"Nios II Hardware".
