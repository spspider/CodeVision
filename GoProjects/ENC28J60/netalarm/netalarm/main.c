#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <avr/eeprom.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

#include "ip_arp_udp_tcp.h"
#include "websrv_help_functions.h"
#include "enc28j60.h"
#include "timeout.h"
#include "net.h"
#include "uart.h"
#include "onewire.h"
#include "delay.h"
#include "ds18x20.h"
#include "time.h"

#define RXBAUD 9600
#define RXUBRR F_CPU/16/RXBAUD-1
#define RX_BUF_SIZE 35
char    RXBuffer[RX_BUF_SIZE];
uint8_t RXi;
char    RXc;
uint8_t FLAG_COMMAND = 0;
uint8_t FLAG_LOG = 0;
uint8_t FLAG_ALARM = 0;
uint8_t FLAG_DS18B20 = 1;
uint8_t FLAG_Recursion = 0;

const char FS_OK[] PROGMEM = "OK";
const char FS_BadComand[] PROGMEM = "Bad Command syntax\r\n\r\nExample:\r\n";
const char FS_Pin[] PROGMEM = "Pin#";
const char FS_ON[] PROGMEM = "OFF";
const char FS_OFF[] PROGMEM = "ON";
const char FS_RN[] PROGMEM = "\r\n";

const char SELECTt_0[] PROGMEM = "On OUT9";
const char SELECTt_1[] PROGMEM = "On OUT10";
const char SELECTt_2[] PROGMEM = "Off OUT9";
const char SELECTt_3[] PROGMEM = "Off OUT10";
const char SELECTt_4[] PROGMEM = "Send to Log";
const char SELECTt_5[] PROGMEM = "Send Alarm#0..#9";
const char SELECTt_6[] PROGMEM = "Send Alarm#0";
const char SELECTt_7[] PROGMEM = "Send Alarm#1";
const char SELECTt_8[] PROGMEM = "Send Alarm#2";
const char SELECTt_9[] PROGMEM = "Send Alarm#3";
const char SELECTt_10[] PROGMEM = "Send Alarm#4";
const char SELECTt_11[] PROGMEM = "Send Alarm#5";
const char SELECTt_12[] PROGMEM = "Send Alarm#6";
const char SELECTt_13[] PROGMEM = "Send Alarm#7";
const char SELECTt_14[] PROGMEM = "Send Alarm#8";
const char SELECTt_15[] PROGMEM = "Send Alarm#9";
const char SELECTt_16[] PROGMEM = "Event #0";
const char SELECTt_17[] PROGMEM = "Event #1";
const char SELECTt_18[] PROGMEM = "Event #2";
const char SELECTt_19[] PROGMEM = "Event #3";
const char SELECTt_20[] PROGMEM = "Event #4";
const char SELECTt_21[] PROGMEM = "Event #5";
const char SELECTt_22[] PROGMEM = "Event #6";
const char SELECTt_23[] PROGMEM = "Event #7";
const char SELECTt_24[] PROGMEM = "Event #8";
const char SELECTt_25[] PROGMEM = "Event #9";
const uint8_t *select_t[] = {SELECTt_0, SELECTt_1, SELECTt_2, SELECTt_3, SELECTt_4, SELECTt_5, SELECTt_6, SELECTt_7, SELECTt_8, SELECTt_9, SELECTt_10, SELECTt_11, SELECTt_12, SELECTt_13, SELECTt_14, SELECTt_15, SELECTt_16, SELECTt_17, SELECTt_18, SELECTt_19, SELECTt_20, SELECTt_21, SELECTt_22, SELECTt_23, SELECTt_24, SELECTt_25};

const char SELECTc_0[] PROGMEM = ">";
const char SELECTc_1[] PROGMEM = "=";
const char SELECTc_2[] PROGMEM = "<";
const char *select_c[] = {SELECTc_0, SELECTc_1, SELECTc_2};

const char LOADHTML[] PROGMEM = "function loadHTML(sURL){var request=null;if(!request)try{request=new ActiveXObject('Msxml2.XMLHTTP');}catch(e){}if(!request)try{request=new ActiveXObject('Microsoft.XMLHTTP');}catch(e){}if(!request)try{request=new XMLHttpRequest();}catch(e){}if(!request)return"";request.open('GET', sURL, false);request.send(null);return request.responseText;}";

//ds18b20
#define MAXSENSORS 3
uint8_t gSensorIDs[MAXSENSORS][OW_ROMCODE_SIZE];
uint8_t nSensors;
uint8_t curSensors=0;
int DS18B20SensorsValues[MAXSENSORS];

//Timers Counters
uint8_t TIMER_ONESEC = 0;
uint16_t TIMER_LOG = 0;
uint8_t TIMER_DS18B20 = 0;
uint8_t TIMER_EVENTS = 0;
uint8_t TIMER_CORRECT = 0;
uint8_t TIMER_MAC_LIFE = 0;

// listen port for tcp/www:
#define MYWWWPORT 80
//
// listen port for udp
#define MYUDPPORT 1200

#define BUFFER_SIZE 1024
static uint8_t buf[BUFFER_SIZE+1];
static char Strbuf[170];

char Prm[6];
uint8_t PrmInt;

char PrmM[6];
uint8_t PrmMInt;

#define PIN_COUNT		11

#define IO_INPUT		1
#define IO_INPUT_ADC	2
#define IO_OUT			3
#define IO_DS18B20		4

// PIN Config Array
// 0 - not used
// 1 (IO_INPUT) - Input
// 2 (IO_INPUT_ADC) - Analog Input
// 3 (IO_OUT) - Otput
uint8_t IO_CFG[PIN_COUNT] = {IO_DS18B20,IO_DS18B20,IO_DS18B20,IO_INPUT_ADC,IO_INPUT_ADC,IO_INPUT,IO_INPUT,IO_INPUT,IO_INPUT,IO_OUT,IO_OUT};
// default values Array
uint8_t IO_DEFAULT[PIN_COUNT] = {0,0,0,0,0,0,0,0,0,0,0};

#define TITLE_LENGTH 21

#define STAT_PAGE    98
#define STATUS_PAGE  99
#define XML_PAGE      97


typedef struct {
	unsigned char	myname[TITLE_LENGTH];
	uint8_t			mymac[6];
	uint8_t			myip[4];
	uint8_t			mask[4];
	uint8_t			gateway[4];
	char password[9];//="password\0"; // must not be longer than 9 char // the password string (only the first 5 char checked), (only a-z,0-9,_ characters):

} net_settings;
net_settings netsettings;

unsigned char title[TITLE_LENGTH];

typedef struct {
	uint8_t			logip[4];
	uint16_t		logport;
	uint16_t		loginterval;
	uint8_t			check;
} log_settings;
log_settings logsettings;


typedef struct {
	uint8_t			ip[4];
	uint16_t		port;
	unsigned char	msg[8]; // max length of message is 6 symbols. 2 last bytes for \n\0
	uint8_t			check;
} alarm_line;
alarm_line alarmline;

typedef struct {
	uint8_t			pin;
	uint8_t			cmp;
	int				value;
	uint8_t			todo;
	uint16_t		dalay;
	uint8_t			check;
} event_line;
event_line eventline;

uint16_t event_clock[10];
uint8_t event_state[10];

net_settings	EEMEM EEMEM_NETSETTINGS;
log_settings	EEMEM EEMEM_LOGSETTINGS;

unsigned char	EEMEM EEMEM_IO_TITLE[PIN_COUNT][TITLE_LENGTH];

uint16_t		EEMEM EEMEM_LOGPORT;
uint16_t		EEMEM EEMEM_LOGINTERVAL;

alarm_line		EEMEM EEMEM_ALARMLIST[10];
event_line		EEMEM EEMEM_EVENTLIST[10];


uint8_t UART_GET_ARG(uint8_t* _buffer, uint8_t* RXbyte, uint8_t i, char delim);
void NetInit(void);

uint16_t fill_buf(uint8_t *buf,uint16_t pos, const uint8_t *s, uint8_t len)
{
        while ((len) && (*s != '\0')) {
                buf[pos]=*s;
                pos++;
                s++;
                len--;
        }
        return(pos);
}


//=================================== DS18B20 ==================================

uint8_t search_sensors(void)
{
	uint8_t i;
	uint8_t id[OW_ROMCODE_SIZE];
	uint8_t diff;//, nSensors;
	
	nSensors = 0;
	
	for( diff = OW_SEARCH_FIRST; 
		diff != OW_LAST_DEVICE && nSensors < MAXSENSORS ; )
	{
		DS18X20_find_sensor( &diff, &id[0] );
		
		if( diff == OW_PRESENCE_ERR ) {
			break;
		}
		
		if( diff == OW_DATA_ERR ) {
			break;
		}
		
		for (i=0;i<OW_ROMCODE_SIZE;i++)
			gSensorIDs[nSensors][i]=id[i];
		
		nSensors++;
	}	
	return nSensors;
}


//=================================== ADC ==================================
void adc_init(void){
	ADCSRA = _BV(ADEN) | _BV(ADPS0) | _BV(ADPS1) | _BV(ADPS2); // prescaler = 128
}

uint16_t adc_read(uint8_t ch){	
	ADMUX = _BV(REFS0) | (ch & 0x1F);	// set channel (VREF = VCC)	
	ADCSRA &= ~_BV(ADIF);			// clear hardware "conversion complete" flag	
	ADCSRA |= _BV(ADSC);			// start conversion	

	while(ADCSRA & _BV(ADSC));		// wait until conversion complete	

	return ADC;				// read ADC (full 10 bits);
}


void PIN_SET_OUT(uint8_t Pin){
	switch (Pin)
	{
		case 9: DDRA|=(1<<DDA6); break;
		case 10:DDRA|=(1<<DDA7); break;
	}
}


void PIN_SET_IN(uint8_t Pin){
	switch (Pin)
	{
		case 5: DDRA&=~(1<<DDA2); PORTA|=(1<<PORTA2); break;
		case 6: DDRA&=~(1<<DDA3); PORTA|=(1<<PORTA3); break;
		case 7: DDRA&=~(1<<DDA4); PORTA|=(1<<PORTA4); break;
		case 8: DDRA&=~(1<<DDA5); PORTA|=(1<<PORTA5); break;
	}
}


void PIN_SET_IN_ADC(uint8_t Pin){
	//PIN_SET_IN (Pin);
}


void PIN_SET_ON(uint8_t Pin){
	if (IO_CFG[Pin]==IO_OUT) {
		switch (Pin)
		{
			case 9: PORTA|=(1<<PORTA6); break;
			case 10:PORTA|=(1<<PORTA7); break;
		}
	}
}

void PIN_SET_OFF(uint8_t Pin){
	if (IO_CFG[Pin]==IO_OUT) {
		switch (Pin)
		{
			case 9: PORTA&=~(1<<PORTA6); break;
			case 10:PORTA&=~(1<<PORTA7); break;
		}
	}
}

uint16_t PIN_GET_ADC(uint8_t Pin){
	if (IO_CFG[Pin]==IO_INPUT_ADC) {
		switch (Pin)
		{
			case 3: return adc_read(0); break;
			case 4: return adc_read(1); break;
		}
	}
	return 0;
}

uint16_t PIN_GET_VALUE(uint8_t Pin){
	if (IO_CFG[Pin]==IO_DS18B20) {
		return DS18B20SensorsValues[Pin];
	}
	

	if (IO_CFG[Pin]==IO_INPUT_ADC) {
		switch (Pin)
		{
			case 3: return PIN_GET_ADC(Pin);
			case 4: return PIN_GET_ADC(Pin);

		}
	}

	
	if (IO_CFG[Pin]==IO_INPUT) {
		switch (Pin)
		{
			case 5: return ((PINA & (1<<PINA2))==(1<<PINA2)); break;
			case 6: return ((PINA & (1<<PINA3))==(1<<PINA3)); break;
			case 7: return ((PINA & (1<<PINA4))==(1<<PINA4)); break;
			case 8: return ((PINA & (1<<PINA5))==(1<<PINA5)); break;
		}
	}

	
	if (IO_CFG[Pin]==IO_OUT) {
		switch (Pin)
		{
			case 9: return ((PORTA & (1<<PORTA6))==(1<<PORTA6)); break;
			case 10:return ((PORTA & (1<<PORTA7))==(1<<PORTA7)); break;
		}
	}
	return -1;
}



void PinsInit(void)
{
	uint8_t i;
	for (i=0;i<PIN_COUNT;i++) {
		// Output
		if (IO_CFG[i]==IO_OUT) {
			PIN_SET_OUT(i);

			// set default value
			PIN_SET_OFF(i);
			if (IO_DEFAULT[i]==1) {
				PIN_SET_ON(i);
			}
		}
		
		// Input
		if (IO_CFG[i]==IO_INPUT) {
			PIN_SET_IN(i);
		}

		// ADC Input
		if (IO_CFG[i]==IO_INPUT_ADC) {
			PIN_SET_IN_ADC(i);
		}

	}
}


///////////////////////////////////////////
///////////////////////////////////////////
void clear_RXBuffer(void) {
	for (RXi=0;RXi<RX_BUF_SIZE;RXi++)
		RXBuffer[RXi] = 0;
	RXi = 0;
}

///////////////////////////////////////////
// Int to String
// _buffer - buffer
// _value - (max 65536)
// _n - length (max 5)
///////////////////////////////////////////
void intToStr(uint8_t* _buffer, int _value, uint8_t _n) {
uint8_t i,j, cursor = 0, flag_fill = 0;
int num;
	for (i=0; i<_n; i++) {
			if (/*(i==0) &&*/ (_value != abs(_value))) {
			_value = abs(_value);
			_buffer[i] = 45;
			cursor++;
		} else {
			num = 1;
			for (j=1; j< (_n-i); j++) {
				num = num*10;
			}
			_buffer[cursor] = (_value / num);
			_value -= _buffer[cursor] * num;

			if (_buffer[cursor] > 0) {
				flag_fill = 1;
			}

			if (flag_fill == 1) {
				_buffer[cursor] += 48;
				cursor++;
			}
		}
	}

	if ((cursor == 0) && (_buffer[cursor] == 0)) {
		_buffer[cursor] = '0';
		cursor++;
	}
	_buffer[cursor] = '\0';
}

uint32_t pow_10(uint8_t i)
{
	uint16_t uiData;

	if (i==0) return 1;

	uiData=10;
	i=i-1;
	while(i) {
		uiData *= 10; 
		i--;
	}
	return uiData;
}

int16_t StrToInt (uint8_t* _buffer) {
	uint16_t result;
	uint16_t x10;
	uint8_t pos;

	result = 0;
	pos = 0;

	//go to end
	while (_buffer[pos] != 0) {
		pos++;
	}

	x10 = 0;
	pos--;

	while ((_buffer[pos] > 47) && (_buffer[pos] < 58) && (pos >= 0)) {
		result += (_buffer[pos]-48) * pow_10(x10);
		pos--;
		x10++;
	}

	// if ferst symbol is "-"
	if (_buffer[pos] == 45) {
		result *= -1;
	}
	return result;
}


// STR to IP
int str_to_ip(uint8_t* ip, uint8_t* buffer, uint8_t start_pos) {
uint8_t i;
	if (UART_GET_ARG(Strbuf, buffer, start_pos, '.') == 4) { //if IP address like a normal IP
		for (i=0;i<4;i++) {
			ip[i] = buffer[i];
		}
		return 1;
	}
	return 0;
}


uint16_t print_ip(uint8_t* ip, uint16_t plen) {
uint8_t i;
	for (i=0;i<4;i++) {
		intToStr(Prm, ip[i], 3);
		plen=fill_tcp_data(buf,plen,Prm);
		if (i<3) {
			plen=fill_tcp_data_p(buf,plen,PSTR("."));
		}
	}
	return plen;
}


// 
uint8_t verify_password(char *str)
{
	// the first characters of the received string are
	// a simple password/cookie:
	if (strncmp(netsettings.password,str,strlen(netsettings.password))==0){
		return(1);
	}
	return(0);
}

// analyse the url given
// return values: -1 invalid password
//                -2 no command given but password valid
//                -3 just refresh page
//                -4 main page
//                >=0 get info about PIN number
////                0 switch off
////                1 switch on
////                2 favicon.ico
//
//                The string passed to this function will look like this:
//                /password/?s=1 HTTP/1.....
//                /password/?s=0 HTTP/1.....
//                /password HTTP/1.....
int8_t analyse_get_url(char *str)
{
        uint8_t loop=15;
		uint8_t pg, i, j;
		uint8_t RXbyte[6];

		// the first slash:
        if (*str == '/'){
                str++;
        }else{
                return(-1);
        }

		// http://IP/stat
		// Status page (without password)
		if (strncmp("status",str,6)==0){
			return(STATUS_PAGE);
		}

		// short status page (without password)
		if (strncmp("stat",str,4)==0){
			return(STAT_PAGE);
		}

		// XML (without password)
		if (strncmp("xml",str,3)==0){
			return(XML_PAGE);
		}

        // the password:
        if(verify_password(str)==0){
                return(-1);
        }
        // move forward to the first space or '/'
        while(loop){
                if(*str==' '){
                        // end of url and no slash after password:
                        return(-2);
                }
                if(*str=='/'){
                        // end of password
                        loop=0;
                        continue;
                }
                str++;
                loop--; // do not loop too long
        }
        
		///////////////////////////////////////////////////////////////////////
		// 'pg' - page query
		//
		if (find_key_val(str,Strbuf,5,"pg")) {

			//////////////////////////////////
			pg = (Strbuf[0]-48);
			if (Strbuf[1] > 0) {
				pg = pg*10 + (Strbuf[1]-48);
			}
			//////////////////////////////////


			if (find_key_val(str,Prm,4,"n")) {
				PrmInt = StrToInt(Prm);
			}
			else {
				PrmInt = 0;
			}


			if (find_key_val(str,PrmM,4,"m")) {
				PrmMInt = StrToInt(PrmM);
			}
			else {
				PrmMInt = 0;
			}


			///////////
			// Save settings
			///////////
			if (find_key_val(str,Strbuf,2,"a")) {
				if (Strbuf[0]=='a') {
					///////////
					// Settings
					///////////
					if (pg==2) {
						if (!find_key_val(str,netsettings.myname,TITLE_LENGTH,"name")) {
							netsettings.myname[0]='\0';
						}
						
						// convert URL spase ('+') to normal space ' '
						for (i=0;i<TITLE_LENGTH;i++) {
							if (netsettings.myname[i] == '+') {
								netsettings.myname[i] = ' ';
							}
						}

						if (find_key_val(str,Strbuf,30,"mac")) {
							if (UART_GET_ARG(Strbuf, RXbyte, 0, '-') == 6) {
								for (i=0;i<6;i++) {
									netsettings.mymac[i] = RXbyte[i];
								}
							}

						}

						if (find_key_val(str,Strbuf,30,"ip")) {
							str_to_ip(netsettings.myip, RXbyte, 0);
						}


						if (find_key_val(str,Strbuf,30,"mask")) {
							str_to_ip(netsettings.mask, RXbyte, 0);
						}


						if (find_key_val(str,Strbuf,30,"gateway")) {
							str_to_ip(netsettings.gateway, RXbyte, 0);
						}

						if (find_key_val(str,Strbuf,9,"pwd")) {
							i=0;
							j=0;
							while ((i < RX_BUF_SIZE) && (j<8) && (Strbuf[i] != '\0')) {
								netsettings.password[j] = Strbuf[i];
								j++;
								i++;
							}
							while (j<8) {
								netsettings.password[j] = '\0';
								j++;
							}
						}
						
						eeprom_write_block(&netsettings, &EEMEM_NETSETTINGS, sizeof(netsettings));
						NetInit();
					}
					
					///////////
					// Titles
					///////////
					//if (pg==33) {
					if (pg==3) {
						if (!find_key_val(str,title,TITLE_LENGTH,"t")) {
							title[0]='\0';
						}
						
						// convert URL spase ('+') to normal space ' '
						for (i=0;i<TITLE_LENGTH;i++) {
							if (title[i] == '+') {
								title[i] = ' ';
							}
						}
						eeprom_write_block(&title, &EEMEM_IO_TITLE[PrmInt], sizeof(title));
					}

					/////////////
					// Log-Server
					/////////////
					if (pg==4) {
						if (find_key_val(str,Strbuf,30,"ip")) {
							str_to_ip(logsettings.logip, RXbyte, 0);
						}
						if (find_key_val(str,Strbuf,6,"port")) {
							logsettings.logport=StrToInt(Strbuf);
						}
						if (find_key_val(str,Strbuf,6,"s")) {
							logsettings.loginterval=StrToInt(Strbuf);
							TIMER_LOG = 0;
						}

						if (find_key_val(str,Strbuf,4,"k")) {
							logsettings.check = 1;
						}
						else {
							logsettings.check = 0;
						}

						eeprom_write_block(&logsettings, &EEMEM_LOGSETTINGS, sizeof(logsettings));
					}


					/////////////
					// Alarm-List
					/////////////
					//if (pg==55) {
					if (pg==5) {
						if (find_key_val(str,Strbuf,30,"ip")) {
							if (str_to_ip(alarmline.ip, RXbyte, 0) == 1) {
								if (find_key_val(str,Strbuf,6,"port")) {
									alarmline.port = StrToInt(Strbuf);
								}
								find_key_val(str,alarmline.msg,7,"msg");
								// convert URL spase ('+') to normal space ' '
								for (i=0;i<6;i++) {
									if (alarmline.msg[i] == '+') {
										alarmline.msg[i] = ' ';
									}
								}

								if (find_key_val(str,Strbuf,4,"k")) {
							  		alarmline.check = 1;
								}
								else {
							  		alarmline.check = 0;
								}

								eeprom_write_block(&alarmline, &EEMEM_ALARMLIST[PrmInt], sizeof(alarmline));
							}
						}
					}

					/////////////
					// Event-List
					/////////////
					//if (pg==66) {
					if (pg==6) {
						if (find_key_val(str,Strbuf,4,"p")) {
							eventline.pin = StrToInt(Strbuf);
							
							find_key_val(str,Strbuf,4,"c");
							eventline.cmp = StrToInt(Strbuf);

							find_key_val(str,Strbuf,5,"v");
							eventline.value = StrToInt(Strbuf);

							find_key_val(str,Strbuf,4,"t");
							eventline.todo = StrToInt(Strbuf);

							find_key_val(str,Strbuf,7,"d");
							eventline.dalay = StrToInt(Strbuf);

							if (find_key_val(str,Strbuf,4,"k")) {
							  eventline.check = 1;
							}
							else {
							  eventline.check = 0;
							}
							
							eeprom_write_block(&eventline, &EEMEM_EVENTLIST[PrmInt], sizeof(eventline));
						}
					}
				}
			}
			///////////


			if (pg == 1) {
				if (find_key_val(str,Strbuf,3,"sw")){
                	if (Strbuf[0]=='0'){
						PIN_SET_OFF(PrmInt);
                	}
                	if (Strbuf[0]=='1'){
						PIN_SET_ON(PrmInt);
                	}
				}
			}

			
			return(pg);  // Возвращаем номер ноги по которой нужно вернуть информацию
		}
		///////////////////////////////////////////////////////////////////////
        return(0); // Нужно показать гланую страницу
}

uint16_t http200ok(void)
{
        //return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nPragma: no-cache\r\n\r\n")));
		return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nCache-Control: no-cache\r\n\r\n")));
}

uint16_t xml200ok(void)
{
        //return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\nPragma: no-cache\r\n\r\n")));
		return(fill_tcp_data_p(buf,0,PSTR("HTTP/1.1 200 OK\r\nContent-Type: text/xml\r\nCache-Control: no-cache\r\n\r\n")));
}

// answer HTTP/1.0 301 Moved Permanently\r\nLocation: .....\r\n\r\n
// to redirect
// type =0  : http://tuxgraphics.org/c.ico    favicon.ico file
// type =1  : /password/
uint16_t moved_perm(uint8_t *buf,uint8_t type)
{
        uint16_t plen;
        plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 301 Moved Permanently\r\nLocation: "));
        if (type==1){
                plen=fill_tcp_data_p(buf,plen,PSTR("/"));
                plen=fill_tcp_data(buf,plen,netsettings.password);
                plen=fill_tcp_data_p(buf,plen,PSTR("/"));
        }
        plen=fill_tcp_data_p(buf,plen,PSTR("\r\n\r\nContent-Type: text/html\r\n\r\n"));
        plen=fill_tcp_data_p(buf,plen,PSTR("<h1>301 Moved Permanently</h1>\n"));
        return(plen);
}


void get_pin_title (uint8_t Pin) {
	eeprom_read_block(&title, &EEMEM_IO_TITLE[Pin], sizeof(title));
	if ((title[0]=='\0') || (title[0]==0xFF)) {
		title[0]='\0';
	}
}

void get_pin_name (uint8_t Pin) {
	const char S_INPUT[]		= "IN";
	const char S_INPUT_ADC[]	= "A";
	const char S_OUT[]			= "OUT";
	const char S_DS18B20[]		= "T";

	switch (IO_CFG[Pin])
	{
		case IO_INPUT:		strcpy(title, S_INPUT); break;
		case IO_INPUT_ADC:	strcpy(title, S_INPUT_ADC); break;
		case IO_OUT:		strcpy(title, S_OUT); break;
		case IO_DS18B20:	strcpy(title, S_DS18B20); break;
	}

	intToStr(Prm, Pin, 2);
	strncat(title,Prm,2);
}


void read_settings (void) {
	uint8_t i, result = 0;

	eeprom_read_block(&netsettings, &EEMEM_NETSETTINGS, sizeof(netsettings));
	eeprom_read_block(&logsettings, &EEMEM_LOGSETTINGS, sizeof(logsettings));

	//MyName
	if (netsettings.myname[0]==255)
		netsettings.myname[0] = 0;


	//MyMAC
	result = 0;
	for (i=0; i < 6; i++) {
		if (netsettings.mymac[i] == 0xFF)
			result++;
	}
	if (result == 6) {
		netsettings.mymac[0] = 0x54;
		netsettings.mymac[1] = 0x55;
		netsettings.mymac[2] = 0x58;
		netsettings.mymac[3] = 0x10;
		netsettings.mymac[4] = 0x00;
		netsettings.mymac[5] = 0x30;
	}


	//MyIP
	result = 0;
	for (i=0; i < 4; i++) {
		if (netsettings.myip[i] == 0xFF)
			result++;
	}
	if (result == 4) {
		netsettings.myip[0] = 192;
		netsettings.myip[1] = 168;
		netsettings.myip[2] = 114;
		netsettings.myip[3] = 21;
	}

	//Mask
	result = 0;
	for (i=0; i < 4; i++) {
		if (netsettings.mask[i] == 0xFF)
			result++;
	}
	if (result == 4) {
		netsettings.mask[0] = 255;
		netsettings.mask[1] = 255;
		netsettings.mask[2] = 255;
		netsettings.mask[3] = 0;
	}

	//Gateway
	result = 0;
	for (i=0; i < 4; i++) {
		if (netsettings.gateway[i] == 0xFF)
			result++;
	}
	if (result == 4) {
		netsettings.gateway[0] = 192;
		netsettings.gateway[1] = 168;
		netsettings.gateway[2] = 114;
		netsettings.gateway[3] = 1;
	}

	//Password
	if ((uint8_t)netsettings.password[i] == 0xFF) {
		strncpy (netsettings.password,"password\0",9);
	}

	//LOG IP
	result = 0;
	for (i=0; i < 4; i++) {
		if (logsettings.logip[i] == 0xFF)
			result++;
	}
	if (result == 4) {
		logsettings.logip[0] = 0;
		logsettings.logip[1] = 0;
		logsettings.logip[2] = 0;
		logsettings.logip[3] = 0;
	}
	//LOG Port
	if (logsettings.logport == 0xFFFF) {
		logsettings.logport = 514;
	}
	//Log Interval
	if (logsettings.loginterval == 0xFFFF) {
		logsettings.loginterval = 600;
	}
}


uint16_t print_webpage(uint8_t *buf, int8_t page)
{
	uint8_t i, result;
	uint16_t plen;
	if (page == XML_PAGE) {
		plen=xml200ok();
	}
	else {
		plen=http200ok();
	}
	//////////
	//Main Page
	//////////
	if (page==0) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<html>\
<head><title>NETAlarm "));
plen=fill_tcp_data(buf,plen,netsettings.myname);
plen=fill_tcp_data_p(buf,plen,PSTR("</title></head>\
<body><h1><font color=\"color=\"#008080\"\">NETAlarm "));
plen=fill_tcp_data(buf,plen,netsettings.myname);
plen=fill_tcp_data_p(buf,plen,PSTR("</font></h1>| <a href=\"./?pg=1\" target=\"a\">Main</a> | <a href=\"./?pg=2\" target=\"a\">Settings</a> | <a href=\"./?pg=3\" target=\"a\">Titles</a> | <a href=\"./?pg=4\" target=\"a\">Log-Server</a> | <a href=\"./?pg=5\" target=\"a\">Alarm List</a> | <a href=\"./?pg=6\" target=\"a\">Events</a> |\
<iframe name=\"a\" src=\"./?pg=1\" width=\"100%\" height=\"80%\" frameborder=\"0\"></iframe>\
<p align=\"center\">&copy; 2010-2012 Koryagin Andrey. All rights reserved.</p>\
</body></html>"));

	}

	//////////
	// Info
	//////////
	if (page==1) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<ul>"));
		for (i=0;i<PIN_COUNT;i++) {
			plen=fill_tcp_data_p(buf,plen,PSTR("<li>"));

			get_pin_name(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR(":"));

			get_pin_title(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR(":"));

			
			if (IO_CFG[i]==IO_OUT) {
				plen=fill_tcp_data_p(buf,plen,PSTR("<a href=\"./?pg=1&n="));
				intToStr(Prm, i, 2);
				plen=fill_tcp_data(buf,plen,Prm);
				
				plen=fill_tcp_data_p(buf,plen,PSTR("&sw="));


				if (PIN_GET_VALUE(i)==0) {
					plen=fill_tcp_data_p(buf,plen,PSTR("1"));
				}
				else {
					plen=fill_tcp_data_p(buf,plen,PSTR("0"));
				}

				
				plen=fill_tcp_data_p(buf,plen,PSTR("\">"));
			}

			
			intToStr(Prm, PIN_GET_VALUE(i), 5);
			plen=fill_tcp_data(buf,plen,Prm);


			if (IO_CFG[i]==IO_OUT) {
				plen=fill_tcp_data_p(buf,plen,PSTR("</a>"));
			}


			plen=fill_tcp_data_p(buf,plen,PSTR("</li>"));
		}
		plen=fill_tcp_data_p(buf,plen,PSTR("</ul>"));
	}


	//////////
	// Info Just Text
	//////////
	if (page==STATUS_PAGE) {
		for (i=0;i<PIN_COUNT;i++) {
			get_pin_name(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR(":"));

			get_pin_title(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR(":"));

			intToStr(Prm, PIN_GET_VALUE(i), 5);
			plen=fill_tcp_data(buf,plen,Prm);

			plen=fill_tcp_data_p(buf,plen,PSTR(";"));
		}
	}


	//////////
	// Info Just Text like a log
	//////////
	if (page==STAT_PAGE) {
		for (i=0;i<PIN_COUNT;i++) {
			intToStr(Prm, PIN_GET_VALUE(i), 5);
			plen=fill_tcp_data(buf,plen,Prm);
			plen=fill_tcp_data_p(buf,plen,PSTR(":"));
		}
		plen=fill_tcp_data_p(buf,plen,PSTR("\n"));
	}


	//////////
	// Info XML
	//////////
	if (page==XML_PAGE) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<?xml version=\"1.0\" ?>\r\n<stat>\r\n\t<device>\n"));
		for (i=0;i<PIN_COUNT;i++) {
			get_pin_name(i);
			plen=fill_tcp_data_p(buf,plen,PSTR("\t\t<item>\r\n\t\t\t<id>"));
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR("\t\t\t</id>\r\n\t\t\t<title>"));
			get_pin_title(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR("</title>\r\n\t\t\t<value>"));
			intToStr(Prm, PIN_GET_VALUE(i), 5);
			plen=fill_tcp_data(buf,plen,Prm);
			plen=fill_tcp_data_p(buf,plen,PSTR("</value>\r\n\t\t</item>\r\n"));
		}
		plen=fill_tcp_data_p(buf,plen,PSTR("\t</device>\r\n</stat>\n"));
	}


	//////////
	//Settings
	//////////
	if (page==2) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<h2>Settings</h2>\
<form method=\"GET\"><input name=\"pg\" type=\"hidden\" value=\"2\"><input name=\"a\" type=\"hidden\" value=\"a\"><table border=\"0\">\
<tr><td>Name:</td><td><input name=\"name\" type=\"text\" value=\""));
		plen=fill_tcp_data(buf,plen,netsettings.myname);

		plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>MAC:</td><td><input name=\"mac\" type=\"text\" value=\""));
		for (i=0;i<6;i++) {
			intToStr(Prm, netsettings.mymac[i], 3);
			plen=fill_tcp_data(buf,plen,Prm);
			if (i<5) {
				plen=fill_tcp_data_p(buf,plen,PSTR("-"));
			}
		}
		plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>IP:</td><td><input name=\"ip\" type=\"text\" value=\""));
		
		plen = print_ip(netsettings.myip, plen);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>MASK:</td><td><input name=\"mask\" type=\"text\" value=\""));
		plen = print_ip(netsettings.mask, plen);
plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>Gateway:</td><td><input name=\"gateway\" type=\"text\" value=\""));
		plen = print_ip(netsettings.gateway, plen);
plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>Password:</td><td><input name=\"pwd\" type=\"password\" value=\""));
		plen=fill_tcp_data(buf,plen,netsettings.password);
plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>&nbsp;</td><td><input type=\"submit\" value=\"Save\"></td></tr>\
</table></form>"));

	}


	//Titles
	if (page==3) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<h2>Titles</h2><script>"));
		plen=fill_tcp_data_p(buf,plen,LOADHTML);
		plen=fill_tcp_data_p(buf,plen,PSTR("for(i=0;i<10;i++)document.write(loadHTML('./?pg=33&n='+i));</script>"));
	}

	if (page==33) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<form method=\"GET\">"));
		get_pin_name(PrmInt);
		plen=fill_tcp_data(buf,plen,title);
		plen=fill_tcp_data_p(buf,plen,PSTR(": <input name=\"pg\" type=\"hidden\" value=\"3\"><input name=\"a\" type=\"hidden\" value=\"a\"><input name=\"n\" type=\"hidden\" value=\""));
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"><input name=\"t\" value=\""));
		get_pin_title(PrmInt);
		plen=fill_tcp_data(buf,plen,title);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"> <input type=submit value=\"Save\"></form>"));
	}



	//Log-Server
	if (page==4) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<h2>Log-Server</h2>\
<form method=\"GET\"><input name=\"pg\" type=\"hidden\" value=\"4\"><input name=\"a\" type=\"hidden\" value=\"a\"><table border=\"0\">\
<tr><td>IP:</td><td><input name=\"ip\" type=\"text\" value=\""));
		plen = print_ip(logsettings.logip, plen);
plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>PORT:</td><td><input name=\"port\" type=\"text\" value=\""));
		intToStr(Prm, logsettings.logport, 5);
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>Interval, sec:</td><td><input name=\"s\" type=\"text\" value=\""));
		intToStr(Prm, logsettings.loginterval, 5);
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"></td></tr>\
<tr><td>Enable</td><td><input name=\"k\" type=\"checkbox\" value=\"1\""));
		if (logsettings.check==1)
			plen=fill_tcp_data_p(buf,plen,PSTR(" checked"));
plen=fill_tcp_data_p(buf,plen,PSTR("></td></tr><tr><td>&nbsp;</td><td><input type=\"submit\" value=\"Save\"></td></tr>\
</table></form>"));
	}


	//Alarm List
	if (page==5) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<h2>Alarm List</h2><script>"));
		plen=fill_tcp_data_p(buf,plen,LOADHTML);
		plen=fill_tcp_data_p(buf,plen,PSTR("for(i=0;i<10;i++)document.write(loadHTML('./?pg=55&n='+i));</script>"));
	}


	if (page==55) {
		eeprom_read_block(&alarmline, &EEMEM_ALARMLIST[PrmInt], sizeof(alarmline));
		//IP
		result = 0;
		for (i=0; i < 4; i++) {
			if (alarmline.ip[i] == 0xFF)
				result++;
		}
		if (result == 4) {
			alarmline.ip[0] = 0;
			alarmline.ip[1] = 0;
			alarmline.ip[2] = 0;
			alarmline.ip[3] = 0;
		}
		if (alarmline.port == 0xFFFF) {
			alarmline.port = 1024;
		}
		if (alarmline.msg[0] == 0xFF) {
			alarmline.msg[0] = '\0';
		}

		plen=fill_tcp_data_p(buf,plen,PSTR("<form method=\"GET\"><input name=\"pg\" type=\"hidden\" value=\"5\"><input name=\"a\" type=\"hidden\" value=\"a\"><input name=\"n\" type=\"hidden\" value=\""));
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR("\">"));
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR(" <input name=\"ip\" title=\"IP adress\" value=\""));
		plen = print_ip(alarmline.ip, plen);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"><input name=\"port\" title=\"UDP port\" value=\""));
		intToStr(Prm, alarmline.port, 5);
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"><input name=\"msg\" title=\"Secret string\" value=\""));
		plen=fill_tcp_data(buf,plen,alarmline.msg);
		plen=fill_tcp_data_p(buf,plen,PSTR("\"><input name=\"k\" title=\"Enable/Disable\" type=\"checkbox\" value=\"1\""));
		if (alarmline.check==1)
			plen=fill_tcp_data_p(buf,plen,PSTR(" checked"));
		plen=fill_tcp_data_p(buf,plen,PSTR("><input type=\"submit\" value=\"Save\"></form>"));
	}



	//Events
	if (page==6) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<h2>Events</h2><script>"));
		plen=fill_tcp_data_p(buf,plen,LOADHTML);
		plen=fill_tcp_data_p(buf,plen,PSTR("for(i=0;i<10;i++)document.write(loadHTML('./?pg=66&n='+i));</script>"));
	}

	if (page==66) {
		eeprom_read_block(&eventline, &EEMEM_EVENTLIST[PrmInt], sizeof(eventline));
		if (eventline.dalay == 0xFFFF) {
			eventline.dalay = 0;
		}

plen=fill_tcp_data_p(buf,plen,PSTR("<script>"));
plen=fill_tcp_data_p(buf,plen,LOADHTML);
		plen=fill_tcp_data_p(buf,plen,PSTR("</script>\
<form method=\"GET\"><input name=\"pg\" type=\"hidden\" value=\"6\"><input name=\"a\" type=\"hidden\" value=\"a\"><input name=\"n\" type=\"hidden\" value=\""));
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("\">"));
		plen=fill_tcp_data(buf,plen,Prm);
		plen=fill_tcp_data_p(buf,plen,PSTR(" <select size=\"1\" name=\"p\" title=\"Input or Output\"><script>document.write(loadHTML('./?pg=67&m="));
		intToStr(Prm, eventline.pin, 3);
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("'));</script></select>\
<select size=\"1\" title=\"Compare\" name=\"c\"><script>document.write(loadHTML('./?pg=68&m="));
		intToStr(Prm, eventline.cmp, 3);
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("'));</script></select>\
<input name=\"v\" title=\"Value\" value=\""));
		intToStr(Prm, eventline.value, 5);
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("\">\
<select size=\"1\" name=\"t\" title=\"What to do\"><script>document.write(loadHTML('./?pg=69&m="));
		intToStr(Prm, eventline.todo, 3);
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("'));</script></select>\
<input name=\"d\" title=\"Delay time, s\" value=\""));
		intToStr(Prm, eventline.dalay, 5);
		plen=fill_tcp_data(buf,plen,Prm);
plen=fill_tcp_data_p(buf,plen,PSTR("\">\
<input name=\"k\" type=\"checkbox\" title=\"Enable/Disable\" value=\"1\""));
		if (eventline.check==1)
			plen=fill_tcp_data_p(buf,plen,PSTR(" checked"));
plen=fill_tcp_data_p(buf,plen,PSTR(">\
<input type=\"submit\" value=\"Save\"></form>"));
	}


	if (page==67) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\"255\"> </option>"));

		for (i=0;i<PIN_COUNT;i++) {
			plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\""));
			intToStr(Prm, i, 3);
			plen=fill_tcp_data(buf,plen,Prm);
			plen=fill_tcp_data_p(buf,plen,PSTR("\""));

			if (i == PrmMInt) {
				plen=fill_tcp_data_p(buf,plen,PSTR(" selected"));
			}

			plen=fill_tcp_data_p(buf,plen,PSTR(">"));
			get_pin_name(i);
			plen=fill_tcp_data(buf,plen,title);
			plen=fill_tcp_data_p(buf,plen,PSTR("</option>"));
		}
	}

	if (page==68) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\"255\"></option>"));
		for (i=0;i<3;i++) {
			plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\""));
			intToStr(Prm, i, 3);
			plen=fill_tcp_data(buf,plen,Prm);
			plen=fill_tcp_data_p(buf,plen,PSTR("\""));

			if (i == PrmMInt) {
				plen=fill_tcp_data_p(buf,plen,PSTR(" selected"));
			}
			plen=fill_tcp_data_p(buf,plen,PSTR(">"));
			plen=fill_tcp_data_p(buf,plen,select_c[i]);
			plen=fill_tcp_data_p(buf,plen,PSTR("</option>"));
		}
	}

	if (page==69) {
		plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\"255\"></option>"));
		for (i=0;i<26;i++) {
			plen=fill_tcp_data_p(buf,plen,PSTR("<option value=\""));
			intToStr(Prm, i, 3);
			plen=fill_tcp_data(buf,plen,Prm);
			plen=fill_tcp_data_p(buf,plen,PSTR("\""));

			if (i == PrmMInt) {
				plen=fill_tcp_data_p(buf,plen,PSTR(" selected"));
			}
			plen=fill_tcp_data_p(buf,plen,PSTR(">"));
			plen=fill_tcp_data_p(buf,plen,select_t[i]);
			plen=fill_tcp_data_p(buf,plen,PSTR("</option>"));
		}
	}

	return(plen);
}


uint8_t UART_GET_ARG(uint8_t* _buffer, uint8_t* RXbyte, uint8_t i, char delim) {
	uint8_t j = 0;
	uint8_t n = 0;
	while ((i < RX_BUF_SIZE) && (j < 5) && (n < 8)) { // (j < 5)
		if ((_buffer[i] == delim) || (_buffer[i] == 0)) {
			Prm[j] = '\0';
			RXbyte[n] = StrToInt(Prm);
		    n++;
			j = 0;
			if (_buffer[i] == '\0')
				break;
		}
		else {
			Prm[j] = _buffer[i];
			j++;
		}
		i++;
	}
	return n;
}


uint8_t UART_COMAND (uint8_t *Ucmd, uint8_t Ulen) {
	strncpy (Strbuf,RXBuffer,Ulen);
	Strbuf[Ulen]='\0';
	strupr(Strbuf);
	return (strcmp(Strbuf,Ucmd) == 0);
}


void UART_Command(void) {
	uint8_t i,j;//, n=0;
	uint8_t RXbyte[6];
	
	uart_puts_p(FS_RN);

	// AT
	if (UART_COMAND("AT", 2)) {
		uart_puts_p(FS_OK);
	}

	//CONFIG
	if (UART_COMAND("CONFIG", 6)) {
		uart_puts_p(PSTR("MAC:"));
		for (i=0;i<6;i++) {
			intToStr(Strbuf, netsettings.mymac[i], 3);
			uart_puts(Strbuf);
			if (i<5) {
				uart_putc('-');
			}
		}
		uart_puts_p(FS_RN);

		uart_puts_p(PSTR("IP:"));
		for (i=0;i<4;i++) {
			intToStr(Strbuf, netsettings.myip[i], 3);
			uart_puts(Strbuf);
			if (i<3) {
				uart_putc('.');
			}
		}
		uart_puts_p(FS_RN);

		uart_puts_p(PSTR("PASSWORD:"));
		uart_puts(netsettings.password);					
		uart_puts_p(PSTR("\r\n\r\n"));
	}

	// SETMAC
	if (UART_COMAND("SETMAC ", 7)) {
		if (UART_GET_ARG(RXBuffer, RXbyte, 7, '-') == 6) {
			for (i=0;i<6;i++) {
				netsettings.mymac[i] = RXbyte[i];
			}
			eeprom_write_block(&netsettings, &EEMEM_NETSETTINGS, sizeof(netsettings));
			NetInit();
			uart_puts_p(FS_OK);
		}
		else {
			uart_puts_p(FS_BadComand);
			uart_puts_p(PSTR("SETMAC 88-255-114-17-50-117"));
		}
	}

	// SETIP
	if (UART_COMAND("SETIP ", 6)) {
		if (UART_GET_ARG(RXBuffer, RXbyte, 6, '.') == 4) {
			for (i=0;i<4;i++) {
				netsettings.myip[i] = RXbyte[i];
			}
			eeprom_write_block(&netsettings, &EEMEM_NETSETTINGS, sizeof(netsettings));
			NetInit();
		  	uart_puts_p(FS_OK);
		}
		else {
			uart_puts_p(FS_BadComand);
			uart_puts_p(PSTR("SETIP 192.168.0.1"));
		}
	}

	// SETPWD
	if (UART_COMAND("SETPWD ", 7)) {
		i=7;
		j=0;
		while ((i < RX_BUF_SIZE) && (j<8) && (RXBuffer[i] != '\0')) {
			netsettings.password[j] = RXBuffer[i];
			j++;
			i++;
		}
		while (j<8) {
			netsettings.password[j] = '\0';
			j++;
		}
		eeprom_write_block(&netsettings, &EEMEM_NETSETTINGS, sizeof(netsettings));
		uart_puts_p(FS_OK);
	}

	// HELP
	if (UART_COMAND("HELP", 4)) {
		uart_puts_p(PSTR("CONFIG\t\t\t\tPrint config\r\n"));
		uart_puts_p(PSTR("SETMAC [d-d-d-d-d-d]\t\tSet mac\r\n"));
		uart_puts_p(PSTR("SETIP [d.d.d.d]\t\t\tSet IP\r\n"));
		uart_puts_p(PSTR("SETPWD [new password]\t\tSet new password\r\n"));
	}

	uart_puts_p(FS_RN);
	FLAG_COMMAND = 0;
	clear_RXBuffer();
}


void NetInit(void) {

        /*initialize enc28j60*/
        enc28j60Init(netsettings.mymac);
        enc28j60clkout(2); // change clkout from 6.25MHz to 12.5MHz
        _delay_loop_1(0); // 60us
        
        /* Magjack leds configuration, see enc28j60 datasheet, page 11 */
        // LEDB=yellow LEDA=green
        //
        // 0x476 is PHLCON LEDA=links status, LEDB=receive/transmit
        // enc28j60PhyWrite(PHLCON,0b0000 0100 0111 01 10);
        enc28j60PhyWrite(PHLCON,0x476);
        
        //init the web server ethernet/ip layer:
        init_ip_arp_udp_tcp(netsettings.mymac,netsettings.myip,MYWWWPORT);
		
		// set gateway
		client_set_gwip(netsettings.gateway);
}


void send_log() {
	uint8_t i;
	uint16_t plen;

	if (logsettings.check == 1) {
		if ((logsettings.logip[0]>0) && (logsettings.logip[0]<255)) {
			plen = 0;

			plen = fill_buf(Strbuf,plen,"<134> status:", 13);
			for (i=0;i<PIN_COUNT;i++) {
				intToStr(Prm, PIN_GET_VALUE(i), 5);
				plen = fill_buf(Strbuf,plen,Prm,5);
				Strbuf[plen]=':';
				plen++;
			}
			send_udp(buf, Strbuf, plen, 514, logsettings.logip, logsettings.logport);
		}
	}
}

// Send UDP message
void send_alarm_n(uint8_t i) {
uint16_t plen;
uint8_t j;

	eeprom_read_block(&alarmline, &EEMEM_ALARMLIST[i], sizeof(alarmline));
	if (alarmline.check == 1) {
		if ((alarmline.ip[0]>0) && (alarmline.ip[0]<255)) {
			
			for (j=0;j<7;j++) {
				if (alarmline.msg[j] == '\0') {
					alarmline.msg[j] = '\n';
					alarmline.msg[j+1] = '\0';
					break;
				}
			}
			
			plen = 0;
			plen = fill_buf(Strbuf,plen,alarmline.msg,sizeof(alarmline.msg));
			//client_set_gwip(alarmline.ip);
			send_udp(buf, Strbuf, plen, 1048, alarmline.ip, alarmline.port);
		}
	}
}

void send_alarm() {
	uint8_t i;

	if (FLAG_ALARM == 100) {
		for (i=0;i<10;i++) {
			send_alarm_n(i);
		}
	}
	else {
		if ((FLAG_ALARM > 9) && (FLAG_ALARM < 20)) {
			send_alarm_n(FLAG_ALARM-10);
		}
	}
}


void check_event_n(uint8_t event_number, uint8_t checkit, uint8_t state) {
	event_line event;

	// fix recursion
	if (FLAG_Recursion > 8) {
		return;
	}
	FLAG_Recursion++;
	
	//read string from EEPROM
	eeprom_read_block(&event, &EEMEM_EVENTLIST[event_number], sizeof(event));


	// if activ or recursion is present (checkit==0)
	if (event.check >= checkit) {
			// timeout is done
			if (event_clock[event_number] > event.dalay*10) {
				// DO
				state = state & event_state[event_number]; // if one of states == 0. (state has changed to False, and  then has changed to True, but any action yet not done). It is very difficult to understand. but the problem is solved.
				if (event.todo < 16) {
					if (state == 0) {
						switch (event.todo)
						{
							case 0: PIN_SET_ON(9); 		break;
							case 1: PIN_SET_ON(10);		break;
							case 2: PIN_SET_OFF(9);		break;
							case 3: PIN_SET_OFF(10);	break;
							case 4: FLAG_LOG=1; 		break;
							case 5: FLAG_ALARM=100;		break;
							case 6: FLAG_ALARM=10; 		break;
							case 7: FLAG_ALARM=11; 		break;
							case 8: FLAG_ALARM=12; 		break;
							case 9: FLAG_ALARM=13; 		break;
							case 10: FLAG_ALARM=14;		break;
							case 11: FLAG_ALARM=15;		break;
							case 12: FLAG_ALARM=16;		break;
							case 13: FLAG_ALARM=17;		break;
							case 14: FLAG_ALARM=18;		break;
							case 15: FLAG_ALARM=19; 	break;
						}
						event_state[event_number] = 1;
					}
				}
				else {								
					switch (event.todo)
					{
						case 16: check_event_n(0,0,state); break;
						case 17: check_event_n(1,0,state); break;
						case 18: check_event_n(2,0,state); break;
						case 19: check_event_n(3,0,state); break;
						case 20:check_event_n(4,0,state); break;
						case 21:check_event_n(5,0,state); break;
						case 22:check_event_n(6,0,state); break;
						case 23:check_event_n(7,0,state); break;
						case 24:check_event_n(8,0,state); break;
						case 25:check_event_n(9,0,state); break;
					}
					event_state[event_number] = 1;
				}
			}
	}

	FLAG_Recursion--;
}


void check_event() {	
	int value;
	int true_false = 0;
	uint8_t i;
	event_line event;


	//
	for (i=0; i<10; i++) {
		
		eeprom_read_block(&event, &EEMEM_EVENTLIST[i], sizeof(event));

		value = PIN_GET_VALUE(event.pin);
		switch (event.cmp)
		{
			case 0: true_false = (value > event.value);	break;
			case 1: true_false = (value == event.value);break;
			case 2: true_false = (value < event.value);	break;
		}

		if (true_false) {
			if (event_clock[i] < 0xFFFF) {
				event_clock[i]++;
			}
		}
		else {
			event_clock[i] = 0;
			event_state[i] = 0;
		}
	}

	FLAG_Recursion = 0;
	for (i=0; i<10; i++) {
		check_event_n(i,1,event_state[i]);
	}
}


///////////////////////////////////////////
// Timer
///////////////////////////////////////////
ISR(TIMER1_OVF_vect) { // 100 Hz
	TCNT1 = 0x10000 - (F_CPU/1024/100);
    
	// Time correction
	TIMER_CORRECT++;
	if (TIMER_CORRECT > 13) {
		TIMER_CORRECT = 0;
		TCNT1--;
	}
	//

	TIMER_ONESEC++;
	if (TIMER_ONESEC > 99) {
		TIMER_ONESEC = 0;
		TIMER_LOG++;
		
		// timer for DS18B20
		TIMER_DS18B20++;
		if (TIMER_DS18B20 > 5) {
			FLAG_DS18B20 = 1;
			TIMER_DS18B20 = 0;
		}

		// Timer for MAC of gateway refresh
		TIMER_MAC_LIFE++;
		if (TIMER_MAC_LIFE > 59) {
			TIMER_MAC_LIFE = 0;
			client_gw_arp_refresh();
		}
		
		// Timer for LOG
		if ((logsettings.loginterval > 0) && (TIMER_LOG > logsettings.loginterval)) {
			FLAG_LOG = 1;
			TIMER_LOG = 1;
		}
	}

	TIMER_EVENTS++;
	// Check Events
	if (TIMER_EVENTS > 10) {
		cli();
		check_event();
		sei();
		TIMER_EVENTS = 0;
	}
}



int main(void){
        uint8_t i;
		uint16_t plen;
        uint16_t dat_p;
        int8_t cmd;

		uint8_t subzero, cel=0, cel_frac_bits;
      

        // Read settings from EEPROM
		read_settings();
		
		PinsInit();

		DDRB|=(1<<DDB7);

		adc_init();

		NetInit();

		clear_RXBuffer();
		uart_init(RXUBRR);

		TIMSK = (1<<TOIE1);
		TCCR1B = ((1<<CS10) | (1<<CS12));
		TCNT1 = 0x10000 - (F_CPU/1024/100); 

		//DS18B20
		nSensors = search_sensors();
		// reset event_state
		for (i=0;i<nSensors;i++) {
			event_state[i] = 0;
		}

		sei();
		
		// Watchdog
		wdt_enable(WDTO_1S);

		while(1){
			// reset timer of Watchdog
			wdt_reset();

			// read from UART
			RXc = uart_getc();
			
			if (((uint8_t)RXc != 0xFF) && ((uint8_t)RXc != 0) && ((uint8_t)RXc != 10) && (FLAG_COMMAND == 0)) {
 				uart_putc(RXc);
 				if (RXc != 13) {  // not end of line
					RXBuffer[RXi] = RXc;
					RXi++;
				}
				else {
					FLAG_COMMAND = 1;
				}
			}

			if (RXi > RX_BUF_SIZE-1) {
				clear_RXBuffer();
			}

			// ------------------------------------
			// parse command from command line
			// ------------------------------------
			if (FLAG_COMMAND == 1) {
				UART_Command();
			}

				// Time to read temperature
				if (FLAG_DS18B20==1) {
					if (nSensors > 0) {
						if ( DS18X20_start_meas( DS18X20_POWER_PARASITE, &gSensorIDs[curSensors][0] ) == DS18X20_OK ) {
							delay_ms(DS18B20_TCONV_12BIT);
							if ( DS18X20_read_meas( &gSensorIDs[curSensors][0], &subzero, &cel, &cel_frac_bits) == DS18X20_OK ) {
   								DS18B20SensorsValues[curSensors] = (int)cel;
								if (subzero == 1)
									DS18B20SensorsValues[curSensors] = -1*DS18B20SensorsValues[curSensors];
							}
						}

						curSensors++;
						if (curSensors >= nSensors)
							curSensors = 0;					
					}

					FLAG_DS18B20=0;
				}


				// Time to send LOG
				if (FLAG_LOG == 1) {
					send_log();
					FLAG_LOG = 0;
				}
				////

				// Send ALLARM
				if (FLAG_ALARM != 0) {
					send_alarm();
					FLAG_ALARM = 0;
				}


                // handle ping and wait for a tcp packet
                plen=enc28j60PacketReceive(BUFFER_SIZE, buf);
                buf[BUFFER_SIZE]='\0';
                dat_p=packetloop_icmp_tcp(buf,plen);


                if(dat_p==0){
                //        // check if udp otherwise continue
                        goto UDP;
                }

                if (strncmp("GET ",(char *)&(buf[dat_p]),4)!=0){
                        // head, post and other methods:
                        //
                        // for possible status codes see:
                        // http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
                        plen=http200ok();
                        plen=fill_tcp_data_p(buf,plen,PSTR("<h1>200 OK</h1>"));
                        goto SENDTCP;
                }
                if (strncmp("/ ",(char *)&(buf[dat_p+4]),2)==0){
                        plen=http200ok();
						plen=fill_tcp_data_p(buf,plen,PSTR("<html><head><title>NETAlarm "));
						plen=fill_tcp_data(buf,plen,netsettings.myname);
						plen=fill_tcp_data_p(buf,plen,PSTR("</title></head><body><h1><font color=\"color=\"#008080\"\">NETAlarm "));
						plen=fill_tcp_data(buf,plen,netsettings.myname);
						plen=fill_tcp_data_p(buf,plen,PSTR("</font></h1><form method=\"get\" onsubmit=\"document.location.href=pwd.value;return false;\">Password: <input name=\"pwd\" type=\"password\" value=\"\"> <input type=\"button\" value=\"Log In\" onclick=\"document.location.href=pwd.value;\"></form><a href=\"/stat\">Stat</a> <a href=\"/status\">Status</a> <a href=\"/xml\">XML</a><p align=\"center\">&copy; 2010-2012 Koryagin Andrey. All rights reserved.</p></body></html>\n"));
                        goto SENDTCP;
                }
                cmd=analyse_get_url((char *)&(buf[dat_p+4]));
                // for possible status codes see:
                // http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
                if (cmd==-1){
                        plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 401 Unauthorized\r\nContent-Type: text/html\r\n\r\n<h1>401 Unauthorized</h1>"));
                        goto SENDTCP;
                }

                if (cmd==-2){
                        // redirect to the right base url (e.g add a trailing slash):
                        plen=moved_perm(buf,1);
                        goto SENDTCP;
                }
				plen=print_webpage(buf, cmd);
SENDTCP:
                www_server_reply(buf,plen); // send data
                continue;

                // tcp port www end
                // -------------------------------
                // udp start, we listen on udp port 1200=0x4B0
UDP: ;


        }
        return (0);
}
