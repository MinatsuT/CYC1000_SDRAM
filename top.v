/* Hardware test for Arrow CYC1000
 *	
 * Instructions:
 * 
 * 1. Compile logic part
 *    - Regenerate Qsys source code if necessary.
 *    - If you make changes on the Qsys, you will have to generate BSP again in Eclipse tools
 *
 * 2. Convert programming files (.SOF --> .JIC for EPCQ16)
 *		- Recommend to "burn" the logic part in non-volatile memory of the board so it is saved
 *      when power is off. Then we will focus only on Eclipse and treat the board as an "Arduino"
 *		- Go to File -> Convert Programming Files -> Open conversion setup data -> jic_generate.cof
 *    - Select JIC file on programmer & burn it to the board
 *
 *	3. RESTART THE BOARD. This must be a "hard restart" or unplug & plug back the board to force 
 *    reload of configuration memory. NIOS CPU WON'T START UP WITHOUT THIS
 *
 * 4. Tools -> Nios II Software build tools for Eclipse
 *		- Select as workspace the same directory of this Quartus project
 *		
 *
 */

module top (
	input CLK12M,
	output [7:0] LED,
	input USER_BTN,
	input CLK_X,
	input SEN_INT1,
	input SEN_INT2,
	input SEN_SDI,
	input SEN_SDO,
	input SEN_SPC,
	input SEN_CS,
	output CKE,
	output RAS,
	output WE,
	output CS,
	output CAS,
	input D11_R,
	input D12_R,
	input AIN_X,
	input ADBUS_4,
	input ADBUS_7,
	input [7:0]	PIO,
	input [5:0]	BDBUS,
	inout [15:0] DQ,
	output [1:0] DQM,
	output [11:0] A,
	output [1:0] BA,
	input [14:0] D,
	input [7:0] AIN,
	output MEM_CLK
);
wire nreset;
assign nreset = USER_BTN;

wire CLK48M;
wire [7:0] nios_leds;

// PLL generate 48MHz clock
//  Freq. of c0 and c1 are the same (48MHz), but the phase of c0 (MEM_CLK) is shifted
//  so that edges occur in the middle of the valid signal window.
//  See the section "Clock, PLL and Timing Considerations" of the "SDRAM Controller Core" document:
//  https://www.intel.cn/content/dam/altera-www/global/zh_CN/pdfs/literature/hb/nios2/n2cpu_nii51005.pdf
my_pll pll0(
	.areset(~nreset),
	.inclk0(CLK12M),
	.c0(MEM_CLK),
	.c1(CLK48M),
	.locked()
);

	
// To test CLK48M is good
reg [31:0] div_counter;
reg div_out;

always @(posedge CLK48M, negedge nreset)
if (~nreset) begin
	div_counter <= 'b0;
	div_out <= 'b0;
end else begin
	if (div_counter == 32'd10000000) begin
		div_counter <= 'b0;
		div_out <= 1'b1;
	end else begin
		div_counter <= div_counter + 32'b1;
		div_out <= 1'b0;
	end
end


// Counter
reg [7:0] leds_reg;


always @(posedge CLK48M, negedge nreset)
if (~nreset) begin
	leds_reg <= 8'b1;
end else begin
	if (div_out) begin
		leds_reg <= leds_reg + 8'b1;
	end 
end


wire [7:0] nios_pio0;
wire reset_request;

my_nios u0 (
  .clk_clk					(CLK48M),
  .reset_reset_n			(nreset & ~reset_request),
  .reset_request_reset	(reset_request),
  .pio0_export				(nios_pio0),
  .pio1_export				(leds_reg),
  .sdram_addr				(A),
  .sdram_ba					(BA),
  .sdram_cas_n				(CAS),
  .sdram_cke				(CKE),
  .sdram_cs_n				(CS),
  .sdram_dq					(DQ),
  .sdram_dqm				(DQM),
  .sdram_ras_n				(RAS),
  .sdram_we_n				(WE),
);


assign LED = {leds_reg[3:0], nios_pio0[3:0]};

endmodule