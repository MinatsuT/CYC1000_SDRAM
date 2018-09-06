# CYC1000 Nios SDRAM example
A sample Quartus Prime project for CYC1000 works with on-board 8MB SDRAM. This project is based on the [reference NIOS design provided by TrenzElectronic](https://wiki.trenz-electronic.de/display/PD/NIOS:https://wiki.trenz-electronic.de/display/PD/NIOS), and fixed sdram related issues.

## Changes from original reference design
- A **phase shifted** PLL output and its output **pin** are added for SDRAM clock.
- Sample Eclipse projects are included, which use SDRAM as a main memory.

## How to use
1. Clone the project, and open **cyc1000_nios.qpf** by Quartus Prime 18.1 or newer.
2. Double click the **top** entity at the hierarchy window of the Quartus Prime, then read instructions in **top.v** file.
3. According to the instructions, **Start Compile**. Then **program your CYC1000**.
3. **Run Eclipse** from the menu [Tools->Nios II Software Build Tools for Eclipse].
4. Choose the project top directory as Eclipse workspace.
5. Click the menu [File->**import**], then choose [General->**Existing Projects into Workspace**].
6. Select the project top directory as root directory.
7. Select **LedCopy** and **LedCopy_bsp** projects. Here, make sure that "Copy projects into workspace" is **unchecked**.
8. Click the Finish button.
9. Build **LedCopy_bsp** project **first**. After that, build **LedCopy** project.
10. **Run LedCopy** project by "Run As"->"Nios II Hardware".