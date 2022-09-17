#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdlib.h>
#include "lan.h"
#include "counter.h"
#include "mmc.h"
#include "httpd.h"

#define LAN_LED_PORT	PORTB
#define LAN_LED_DDR		DDRB
#define LAN_LED_BIT		(1<<PB0)

#define lan_led_on()	LAN_LED_PORT &= ~LAN_LED_BIT
#define lan_led_off()	LAN_LED_PORT |= LAN_LED_BIT
#define lan_led_init()	LAN_LED_DDR |= LAN_LED_BIT; lan_led_off()

void udp_packet(eth_frame_t *frame, uint16_t len) {}

int main()
{
	lan_led_init();
	
	_delay_ms(200);

	while(!mmc_mount());

	lan_init();
	counter_init();
	httpd_init();
	sei();

	while(1)
	{
		lan_poll();
		httpd_poll();
		
		if(lan_up()) lan_led_on();
		else lan_led_off();
	}

	return 0;
}
