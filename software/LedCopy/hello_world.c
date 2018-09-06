/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_alarm.h"

alt_u32 last_sleep_tick = 0;
void mysleep(alt_u32 ms) {
	if (!last_sleep_tick) {
		last_sleep_tick = alt_nticks();
	}
	alt_u32 end = last_sleep_tick + alt_ticks_per_second() * ms / 1000;
	while (alt_nticks() <= end)
		;
	last_sleep_tick = end;
}

int cnt = 0;
int main() {
	while (1) {
		printf("[%d] Hello from Nios II! time=%.2f\n", cnt++,
				(float) alt_nticks() / (float) alt_ticks_per_second());
		for (int j = 0; j < 10; j++) {
			// read pio_1 (upper 4 LEDs, auto increment by logic)
			int pio_1_dat = IORD_ALTERA_AVALON_PIO_DATA(PIO_1_BASE);
			// copy pio_1 to pio_0 (lower 4 LEDs)
			IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, pio_1_dat);
			mysleep(100);
		}
	}
	return 0;
}
