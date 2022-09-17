/* @project 
 * 
 * License to access, copy or distribute this file.
 * This file or any portions of it, is Copyright (C) 2012, Radu Motisan ,  http://www.pocketmagic.net . All rights reserved.
 * @author Radu Motisan, radu.motisan@gmail.com
 * 
 * This file is protected by copyright law and international treaties. Unauthorized access, reproduction 
 * or distribution of this file or any portions of it may result in severe civil and criminal penalties.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * 
 * @purpose Eth interface for Atmega microcontrollers
 * http://www.pocketmagic.net/?p=2866
 */

/*
 * CS can be configured in hw_enc28j60.h
 * Configure mymac and myip below
 */

#include <avr/io.h>
#include <stdlib.h>
#include <string.h>
#include <avr/wdt.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "ip_arp_udp_tcp.h"
#include "avr_compat.h"
#include "net.h"
#include "aux_globals.h"
#include "hw_enc28j60.h"
#include "hw_ds18b20.h"
#include "hw_dht11.h"

// HD44780 LCD Class

// enc28j60 Ethernet Class


// please modify the following two lines. mac and ip have to be unique
// in your local area network. You can not have the same numbers in
// two devices:
static uint8_t mymac[6] = {0x14,0x15,0x16,0x17,0x18,0x19};
static uint8_t myip[4] = {192,168,1,107};
// listen port for tcp/www (max range 1-254)
#define MYWWWPORT 80
// working buffer
#define BUFFER_SIZE 500
static uint8_t buf[BUFFER_SIZE+1];
// Global counters
static int nPingCount = 0, nAccessCount = 0;
// Objects

float ds18b20_temp = 0;
int		milis = 0,sec = 0,
// sensor data
dht11_temp=0, dht11_humidity=0;

			//
	
 /*
	timer0 overflow interrupt
	event to be exicuted every  1.024ms here
*/
ISR (TIMER0_OVF_vect)  
{
	milis ++;
	if (milis >= 976) {
		 sec++;
		 milis = 0; // 976 x 1.024ms ~= 1000 ms = 1sec
		
 
		if (sec%2 == 0) { //every 2 seconds
			// read sensors //
			
			// ds18b20
			ds18b20_temp = therm_read_temperature();
			// dht-11
			int tmp_humi = 0 , tmp_temp = 0;
			if (DHT11_read(&tmp_temp, &tmp_humi) == 0) {
				dht11_temp = tmp_temp;
				dht11_humidity = tmp_humi;
			}
			
			
		}	
		
		if (sec%60 ==0) {
			sec = 0;
		}
	}		

		
}


/*
 * Main entry point
 */
int main(void) {
	// 2.CREATE Timer T0 to count seconds
	//
	TIMSK |= (1 << TOIE0);
	// set prescaler to 64 and start the timer
	TCCR0 |= (1 << CS01) | (1 << CS00);
	// start timer and interrupts
	sei();

	//=====setup eth interface
	uint16_t plen = 0,  dat_p = 0;

	//initialize enc28j60
    enc28j60Init(mymac);
	fcpu_delay_ms(100);
        
    // Magjack leds configuration, see enc28j60 datasheet, page 11 
	enc28j60PhyWrite(PHLCON,0x476);

	fcpu_delay_ms(100);

    //init the ethernet/ip layer:
    init_ip_arp_udp_tcp(mymac,myip,MYWWWPORT);
	fcpu_delay_ms(100);
		
    while(1){
		uint16_t plen, dat_p;
	
		plen = enc28j60PacketReceive(BUFFER_SIZE, buf);
		// plen will ne unequal to zero if there is a valid packet
		if(plen!=0)
		{
			// arp is broadcast if unknown but a host may also verify
			// the mac address by sending it to a unicast address.
			if(eth_type_is_arp_and_my_ip(buf,plen))
			{
				make_arp_answer_from_request(buf);
				continue;
			}		
			// check if ip packets are for us:
			if(eth_type_is_ip_and_my_ip(buf,plen)==0)
			{
				continue;
			}
			//reply to PING
			if(buf[IP_PROTO_P]==IP_PROTO_ICMP_V && buf[ICMP_TYPE_P]==ICMP_TYPE_ECHOREQUEST_V) 
			{
				nPingCount++;
				make_echo_reply_from_request(buf,plen);
				continue;
			}
		
			// tcp port www start, compare only the lower byte
			if (buf[IP_PROTO_P]==IP_PROTO_TCP_V && buf[TCP_DST_PORT_H_P]== 0 && buf[TCP_DST_PORT_L_P]== MYWWWPORT) 
			{
				if (buf[TCP_FLAGS_P] & TCP_FLAGS_SYN_V)
				{
					// make_tcp_synack_from_syn does already send the syn,ack
					make_tcp_synack_from_syn(buf);
					continue;
				}
				if (buf[TCP_FLAGS_P] & TCP_FLAGS_ACK_V)
				{
					init_len_info(buf); // init some data structures
					dat_p = get_tcp_data_pointer();
					if (dat_p==0) // we can possibly have no data, just ack:
					{
						if (buf[TCP_FLAGS_P] & TCP_FLAGS_FIN_V)
						{
							make_tcp_ack_from_any(buf);
						}
						continue;
					}
					// count page requests
					nAccessCount++;
					
					// generate WEBPAGE
					char szS1[200] = {0};
					sprintf(szS1, "Server pings:</b>%d Access Count:%d <br><br>Sensors:<br><li>DS18B20 Temp: %3.3f°C</li><li>DHT-11 Temp: %d°C Humidity: %dRH</li>",
						nPingCount,nAccessCount, ds18b20_temp,dht11_temp, dht11_humidity);
						
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"));
					plen=fill_tcp_data_p(buf,plen,PSTR("<font face=\"tahoma\"><b>Webserver running on Atmega8</b><br><br>"));
					//active data
					plen=fill_tcp_data(buf,plen,szS1);
					plen=fill_tcp_data_p(buf,plen,PSTR("</font></body>"));
					// send data over TCP IP
					make_tcp_ack_from_any(buf);
					make_tcp_ack_with_data(buf,plen);
				}
			}
		}
		//---------------------------------------------
    } // while
    return (0);
} 