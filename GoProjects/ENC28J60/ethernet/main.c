/*********************************************
 * To use the above modeline in vim you must have "set modeline" in your .vimrc
 * Author: Guido Socher
 * Copyright: GPL V2
 * See http://www.gnu.org/licenses/gpl.html
 *********************************************/
#include <avr/io.h>
#include <stdlib.h>
#include <string.h>
//#include <avr/pgmspace.h>
#include "ip_arp_udp_tcp.h"
#include "enc28j60.h"
#include "timeout.h"
#include "avr_compat.h"
#include "net.h"
#include "1w.h"
#include <avr/eeprom.h>
#include "http.h"
#include <util/delay.h>
#include <avr/signal.h> 
 
// сдесь можно задать желаемый ip 
//  и MAC АДРЕСА
// 
 /*инициализация enc28j60*/
#define EEPROM __attribute__ ((section (".eeprom")))

EEPROM uint8_t myip [4] = {10,4,18,100}; // сдесь сохраняем новый ip
EEPROM uint8_t myip_reserve [4] = {10,4,18,100}; // ip по умолчанию
EEPROM uint8_t searash_mac[6]; // найденый mac шлюза сдесь храним адрес шлюза
//EEPROM uint8_t searash_mac_reserve[6]; // резеввный  mac шлюза сдесь храним адрес шлюза по умолчанию
EEPROM uint8_t subnet_mask[4]={255,255,255,0};// маска подсети сдесь сохраняем маску подсети
EEPROM uint8_t searash_reserve_maska[4]={255,255,255,0} ; // маска подсети загружаемая после сброса
EEPROM uint8_t searash_ip[4];
EEPROM uint8_t ip_gw[4];// сдесь храним ip шлюза 
EEPROM uint8_t ip_gw_reserve[4]={0,0,0,0};// сдесь храним ip шлюза 4

uint8_t pw_status;// стаус для пароля
static uint8_t mymac[6] = {0x54,0x55,0x58,0x10,0x05,0x24};// наш mac
static  uint8_t searash_gw[4] ; // промежуточный буфер для шлюза сюда пишем ip шлюза считанный с поля gw
static  uint8_t searash_subnet [4]; // промежуточный буфер сдесь храним ip маски подсети введеный с поля подсеть 
uint8_t myip_new[4];  // промежуточный буфер ip
static uint8_t searash_mac_[6]; // найденый mac шлюза сдесь храним адрес шлюза введеный пользователем
//uint8_t mac_screen[6];
uint8_t ip_screen[4];
static uint8_t IP_SRC[4];// буфер для хранения ip источника
static uint8_t IP_GENERAL[4];//буфер общего назначения
char IP_SCR_CHAR[4];
char IP_GENERAL_CHAR[4];
//uint8_t macaddr_gwi[6]={0x00,0x0f,0x90,0xb9,0x22,0x45};
#define MYWWWPORT 80
#define BUFFER_SIZE 550                // размер приемного буфера
#define PORT_reset		PORTC	
#define DDR_reset		DDRC	
#define PIN_reset		PINC    
#define reset           3
static  uint8_t buf[BUFFER_SIZE+1];     // приамный буфер
#define STR_BUFFER_SIZE 50              // размер буфера строк
static char gStrbuf[STR_BUFFER_SIZE+1];// буфер строк
#define RECEIVE_BUFFER_SIZE 70         // размер буфера приема
#define ARP_BUFFER_SIZE 45
char buf_ARP[ARP_BUFFER_SIZE];                      // arp буфер
char buf_receive[ RECEIVE_BUFFER_SIZE+1];      // приемный буфер  байт
volatile uint8_t i;
uint8_t buf_ware[9];                   // буфер для хранения данныйх от датчика температуры
uint8_t 	temp,tt,y;
uint16_t *tmp = (void*)buf_ware;       // указатель на температуру, принятую из датчика
uint16_t termus;
static uint8_t flag ;
uint8_t result;				        // результат опроса датчика
int t;						            // вспомогательные переменные
char rr[9];
volatile uint8_t time=0; 
// прерывание по таймеру	
 ISR(TIMER1_OVF_vect)
 {
 time++; //  увеличиваем счетчик
 } 
uint8_t temperature(int *temp) {
  
	ow_reset();							// сброс 1-wire
	ow_write_byte(OW_SKIP_ROM_CMD);		// команда "пропустить адрес"
	ow_write_byte(CMD_START_CONV);		// команда "начать измерение"
    _delay_ms(100);
	ow_reset();                        // сброс 1-wire
	//каков бы ни был результат опроса датчика, делаем повторный запуск измерения
	ow_write_byte(OW_SKIP_ROM_CMD);		// команда "пропустить адрес"
	 ow_write_byte(CMD_RD_SCRPAD);		// команда "считать регистры датчика"
    //чтение данных из датчика
	for( i=0;i<9;i++){                 // читаем до тех пор пока не получим все 9 байтов
		buf_ware[i]=ow_read_byte();	// читаем байт в буфер
	   tt = (*tmp>>1);			  
		//t = tt ;	                    
		//*temp = tt;					    
	} 
    tt = (*tmp>>4);                        // выкидываем доли температуры
	t=tt & 0x00ff;                          // выкидываеи ст байт 
	if(tt>127){                             // если температуоа отрицательная
	t=tt-256;                             
	}else{
	}                      
	ow_reset();	
	
					// сброс 1-wire
	// возвращаем результат опроса датчика
	return result;
}
// проверка пароля
// возврашаем 1 если пароль сошелся если нет 0
uint8_t verify_password(char *str)
{
         
          if(*str==0){
		return(2);
}  
         if (strncmp("admin",str,5)==0){
                return(1);
        }
        return(0);
} 
 // ищем ключи если нашли копируем содержимое полей в буфер
 // добавляем в конце NULL
 // если поле заполнено возврвщаем 1
 // возвращаем количество проинятых символов
uint8_t find_key_val(char *str,char *strbuf, uint8_t maxlen,char *key)   // ищем ключевые слова
{
    uint8_t found=0;
        uint8_t i=0;
        char *kp;
        kp=key;
        while(*str &&  *str!=' ' && *str!='\n' && found==0){
                if (*str == *kp){
                        kp++;
                        if (*kp == '\0'){
                                str++;
                                kp=key;
                                if (*str == '='){
                                        found=1;
                                }
                        }
                }else{
                        kp=key;
                }
                str++;
        }
        if (found==1 && *str!='&'){
                 while(*str  &&  *str!=' ' && *str!='\n' && *str!='&'  && maxlen-1){
                        *strbuf=*str;
                        i++;
                        str++;
                        strbuf++;
						}
                *strbuf='\0';
				return(1);    // ЕСЛИ ПОЛЕ ЗАПОЛНЕНО ВОЗВРАЩАЕМ 1
        }
         return(i);
}
// преобразуем принятый ip в цифры и копируем в буфер
uint8_t parse_ip(uint8_t *bytestr,char *str)
{
        char *sptr;
        uint8_t i=0;
        sptr=NULL;
        while(i<4){
                bytestr[i]=0;
                i++;
        }
        i=0;
        while(*str && i<4){
                if (sptr==NULL && isdigit(*str)){
                        sptr=str;
                }
                if (*str == '.'){
                        *str ='\0';
                        bytestr[i]=(atoi(sptr)&0xff);
                        i++;
                        sptr=NULL;
                }
                str++;
        }
        *str ='\0';
        if (i==3){
                bytestr[i]=(atoi(sptr)&0xff);
                return(0);
        }
return(10);		
       }
// анализируем принятый URL	   на предмет наличия ключевых слов 
// возвращаем номер принятого ключа
uint8_t analyse_get_url(char *str)
{      
        pw_status=0;
		 if (str[0] == '/' && str[1] == ' '){
                // если начальная страница
                return(2);
        }
        if (strncmp("/config",str,7)==0){    // если это конфиг
                return(3); 
		}		
        if (strncmp("/form?",str,6)==0){         // это form
		if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"pw")){
		  pw_status=verify_password(gStrbuf); 
            if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ip"));
                                       parse_ip(myip_new,gStrbuf);
									  // return(1);
			if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ms")){ // если это поле маски подсети
		                              parse_ip(searash_subnet,gStrbuf); // копируем в буфер
									   //return(5);    
									   } 						    // return(1);    
		    if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"gw")){        // если это поле шлюза
                                      parse_ip(searash_gw,gStrbuf);     // копируем в буфер
									   return(4);    
									   } 									
		    return(0);  		// 	если другое	   
									   }
									   }
									   }
									   
//Сдесь выводим нашу страничку
uint16_t print_webpage(uint8_t *buf)
{
     uint16_t plen=0;
	 result=ow_reset();
     plen=fill_tcp_data_p(buf,plen,PSTR("<head><META HTTP-EQUIV=REFRESH CONTENT=3><title>Термосервер</title></head><body><div ALIGN=CENTER><i><pre><h1>ТЕРМОСЕРВЕР</pre></h1><br>"));
	 if (result!=1){
     plen=fill_tcp_data_p(buf,plen,PSTR(" Датчик не найден <br><br><br>  </i></body>"));
     }else{
	 temperature(&t);
	 termus=t; 
     itoa(termus,rr,10);
	 plen=fill_tcp_data_p(buf,plen,PSTR("<div ALIGN=CENTER><br>Температура : "));
	 plen=fill_tcp_data(buf,plen,rr);
	 }
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br><br><br><br><br><form action=/config method=get><div ALIGN=CENTER>Переход на страницу конфигурации &nbsp &nbsp<input type=submit value=Перейти ></form>\n"));
	 
	// if (flag==1){ 
    // plen=fill_tcp_data_p(buf,plen,PSTR("узел находится в нашей подсети<br></i></body>"));
	//// }else{
	// plen=fill_tcp_data_p(buf,plen,PSTR("узел находится не в нашей  подсети<br></i></body>"));
	// }
	  plen=fill_tcp_data_p(buf,plen,PSTR("<br></i></body>"));
	
        return(plen);
}
 // страница конфигурации 
uint16_t print_webpage_config(uint8_t *buf)
{
     uint16_t plen=0;
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br><br><br><br><br><form action=/form method=get><div ALIGN=CENTER> Новый IP &nbsp <input type=text name=ip value="));
	 mk_net_str(ip_screen,myip_new,4,'.',10);
     plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br>IP Шлюза  &nbsp<input type=text name=gw value="));
	 mk_net_str(ip_screen,searash_gw,4,'.',10);
     plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br> Маска подсети &nbsp<input type=text name=ms value="));
	 mk_net_str(ip_screen,searash_subnet,4,'.',10);
	 plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br> Mac Шлюза &nbsp<input type=text  value="));
	 mk_net_str(ip_screen,searash_mac_,6,':',16);
	 plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br>Пароль &nbsp<input type=password name=pw>\n &nbsp &nbsp<input type=submit value=отправить ></form>\n"));
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br></i></body>"));
	 return(plen);
}
// преобразуем цифровое значение поля в acsi код
void mk_net_str(char *resultstr,uint8_t *bytestr,uint8_t len,char separator,uint8_t base)
{
        uint8_t i=0;
        uint8_t j=0;
        while(i<len){
                itoa((int)bytestr[i],&resultstr[j],base);
                // search end of str:
                while(resultstr[j]){j++;}
                resultstr[j]=separator;
                j++;
                i++;
        }
        j--;
        resultstr[j]='\0';
} 	
//  главный цикл							
int main(void){
        int8_t  cmd;
        uint16_t plen;
        uint16_t dat_p;
        WDTCR = (1<<WDCE) | (1<<WDE);
       /* Выкл. сторожевого таймера */
        WDTCR = 0x00; 
		PORT_reset|=BV(3);		// настраиваем порт для сброса
        DDR_reset|=~BV(3);
		// настроим таймкр для отсылки arp
		TCCR1A&=0x00; // нормальный режим
		TCCR1B|=0b00000101;// установим предделитель
		TIMSK|=_BV(TOIE1); // РАЗРЕШИМ ПРЕРЫВАНИЯ
		sei();// глобально
		 for( i=0;i<=4;i++){                 // читаем ip до тех пор пока не получим все 4 байт
		myip_new[i]= eeprom_read_byte(&(myip[i]));	// читаем байт в буфер  
		}
		 for( i=0;i<=4;i++){                // читаем маску подсети до тех пор пока не получим все 4 байт
		searash_subnet[i]= eeprom_read_byte(&(subnet_mask[i])); // читаем байт в буфер  
		}
		for( i=0;i<=4;i++){                 // читаем ip шлюза подсети до тех пор пока не получим все 4 байт
		searash_gw[i]= eeprom_read_byte(&(ip_gw[i]));	// читаем байт в буфер  
		}
		//for( i=0;i<=6;i++){                 // читаем mac шлюза подсети до тех пор пока не получим все 4 байт
		//searash_mac_[i]= eeprom_read_byte(&(searash_mac[i]));	// читаем байт в буфер  
		//}
		
		while(y<4){
	    IP_GENERAL[y]=myip_new[y];
			y++;
			}
		 enc28j60Init(mymac);
		 enc28j60clkout(2); // change clkout from 6.25MHz to 12.5MHz
        _delay_loop_1(50); // 12ms
	    enc28j60PhyWrite(PHLCON,0x476);
        _delay_loop_1(50); // 12ms
        init_ip_arp_udp_tcp(mymac,myip_new,MYWWWPORT);
		//result=ow_reset();      // ЩУПАЕМ ДАТЧИК
	    //if(result) {ow_write_byte(OW_SKIP_ROM_CMD)	;	// если он есить  команда "пропустить адрес"
	   // }	
       

 while(1){
       if(time==1){   // примерно раз в минуту шлем arp для поиска шлюза
	   while(y<ARP_BUFFER_SIZE ){
       buf_ARP[y]=0;
       y++;
       } 				
      client_arp_whohas(buf_receive,searash_gw);  // шлем ARP ЗАПРОС
	 _delay_ms(1); // 1ms
	  enc28j60PacketReceive(ARP_BUFFER_SIZE,buf_ARP);   // принимаем пакет содержащий arp ответ
	  if(buf_ARP[ETH_ARP_OPCODE_L_P]=ETH_ARP_OPCODE_REPLY_L_V ){   // если в поле ответ
	   y=0;
	  while(y<6){
       searash_mac_[y]=buf_ARP[ ETH_ARP_SRC_MAC_P+y];  // копируем содержимое ответа в буфер
      y++;
	  }
      while(y<ARP_BUFFER_SIZE ){
      buf_ARP[y]=0;
      y++;
      } 
	  }
      //eeprom_write_block(searash_mac_,searash_mac,6);   //пишем mac шлюза адрем в eeprom	 
	  time=0;
      }
		   // flag=1;
		        data_receive(flag,searash_mac_);
                
                         if (!(PIN_reset & (1 <<  reset ))){    //  если кнопка нажата 
			//возвратим настройки по умолчанию 
				for( i=0;i<=4;i++){                 // читаем до тех пор пока не получим все 4 байт
		        myip_new[i]= eeprom_read_byte(&(myip_reserve[i]));	// читаем байт в буфер 
                }
				for( i=0;i<=4;i++){                 // читаем до тех пор пока не получим все 4 байт
		        searash_subnet[i]= eeprom_read_byte(&(searash_reserve_maska[i]));	// читаем байт в буфер  
				}
				for( i=0;i<=4;i++){                 // читаем до тех пор пока не получим все 4 байт
		        searash_gw[i]= eeprom_read_byte(&(ip_gw_reserve[i]));	// читаем байт в буфер  
				}
				eeprom_write_block(searash_gw,ip_gw,4);
				eeprom_write_block(searash_subnet,subnet_mask,4);
				eeprom_write_block(myip_new,myip,4);              //пишем новый IP адрем в eeprom\
				
				WDTCR = (1<<WDE);                                 // ЗАВОДИМ СОБАКУ
                while(1);                                         // и ждем
			     
				}
				
                plen= enc28j60PacketReceive(BUFFER_SIZE, buf);// приеимаем пакет
  			
              
                if(plen==0){       // если длина равна 0 то вызодим
                        continue;
                }
				 y=0;// пишем в буфер ip адрес источника 
				while(y<4){
                IP_SCR_CHAR[y]=buf[IP_SRC_P+y];
                   y++;
                } 
              	//data_receive(flag,searash_mac_);
			   parse_ip(IP_SRC,IP_SCR_CHAR); 
				y=0;
				while(y<4){                        // Делаем & с маской подсети
				IP_SRC[y]&=searash_subnet[y];
				y++;
				}
				parse_ip(IP_GENERAL,IP_GENERAL_CHAR);
                 y=0;
				while(y<4){                         // Делаем & с маской подсети
				IP_GENERAL[y]&=searash_subnet[y];
				y++;
				} 
				 
                 flag=1;                           // сравниваем 
               if(*IP_GENERAL!=*IP_SRC){
				flag=0;
				}
                       
               // иначе анализируем принятый пакет
                if(eth_type_is_arp_and_my_ip(buf,plen)){ // если  это arp то 
                        make_arp_answer_from_request(buf);// шлем arp отклик
                        continue;
                }

                if(eth_type_is_ip_and_my_ip(buf,plen)==0){ // если принятый ip равен нашему 
                        continue;
                }
				
			
                

                // анализируем остальные поля
                if(buf[IP_PROTO_P]==IP_PROTO_ICMP_V && buf[ICMP_TYPE_P]==ICMP_TYPE_ECHOREQUEST_V){
                        // если это ping то делаем ответ
                        make_echo_reply_from_request(buf,plen);
                        continue;
                }
				// смотрим флаги пакета
                if (buf[IP_PROTO_P]==IP_PROTO_TCP_V&&buf[TCP_DST_PORT_H_P]==0&&buf[TCP_DST_PORT_L_P]==MYWWWPORT){
                        if (buf[TCP_FLAGS_P] & TCP_FLAGS_SYN_V){
						// если пришел флаг TCP_FLAGS_SYN_V шлем  asc
                                make_tcp_synack_from_syn(buf);
                          continue;
                        }
                        if (buf[TCP_FLAGS_P] & TCP_FLAGS_ACK_V){   // если получили TCP_FLAGS_ACK_V
                                init_len_info(buf); // инициализиреум буфер
                               dat_p=get_tcp_data_pointer();
								for (i=0;i<RECEIVE_BUFFER_SIZE;i++){  // заполняем buf_receive
								buf_receive[i]=buf[dat_p++];
								 }
								dat_p=get_tcp_data_pointer();
                                if (dat_p==0){     // если данных нет шлем TCP_FLAGS_FIN_V
                                if (buf[TCP_FLAGS_P] & TCP_FLAGS_FIN_V){
                                  make_tcp_ack_from_any(buf);
                                        }
										 continue;
                                }
						
                 	
				     if (strncmp("GET ",(char *)&(buf[dat_p]),4)==0){   // на предмет присутствия GET 
					 plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")); 
					 
					 // если все нормально шлем это
					 //plen=print_webpage(buf); 
                    }
					 // сдесь анализируем url
				    dat_p=0;
				    cmd=analyse_get_url((char *)&(buf_receive[dat_p+4])); 
                    if(cmd==2){
					plen=print_webpage(buf);
				    }
					if( cmd==4 && pw_status==1){   // если введен адрес шлюза 
                    //while(y<ARP_BUFFER_SIZE ){
                  //  buf_ARP[y]=0;
                   // y++;
                   // } 
					//client_arp_whohas(buf_receive,searash_gw);  // шлем ARP ЗАПРОС
					//_delay_ms(1); // 1ms
					//enc28j60PacketReceive(ARP_BUFFER_SIZE,buf_ARP);   // принимаем пакет содержащий arp ответ
					//if(buf_ARP[ETH_ARP_OPCODE_L_P]=ETH_ARP_OPCODE_REPLY_L_V ){   // если в поле ответ
					// y=0;
					// while(y<6){
                  // searash_mac_[y]=buf_ARP[ ETH_ARP_SRC_MAC_P+y];  // копируем содержимое ответа в буфер
                  //  y++;
					//}
					//y=0;
					// while(y<ARP_BUFFER_SIZE){
                   //  buf_ARP[y]=0;
                    //  y++;
				   // пишем все в eeprom
					//eeprom_write_block(searash_mac_,searash_mac,6);   //пишем mac шлюза адрем в eeprom
					eeprom_write_block(searash_gw,ip_gw,4);           //пишем IP шлюза адрем в eeprom
					eeprom_write_block(searash_subnet,subnet_mask,4); // пишем маску подсети в eeprom
				    eeprom_write_block(myip_new,myip,4);              //пишем новый IP адрем в eeprom
				    plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<div ALIGN=CENTER> Все ОК"));
					make_tcp_ack_from_any(buf); 
                    make_tcp_ack_with_data(buf,plen); 
	                WDTCR = (1<<WDE);                                 // ЗАВОДИМ СОБАКУ
                    while(1);                                         // и ждем
					//} 
					//}
					}
					if(cmd==3){
					plen=print_webpage_config(buf);
					}
					if( cmd==4 && pw_status==0){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>Вы ввели неверный пароль"));
					}
					if( cmd==4 && pw_status==0){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>Вы ввели неверный пароль"));
					}
					if( cmd==4 && pw_status==2){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>Вы не ввели пароль"));
					}
					
					goto SENDTCP;
SENDTCP:
                    make_tcp_ack_from_any(buf);                        // отправляем ack 
                    make_tcp_ack_with_data(buf,plen);                  // передаем наши данные
                    continue;
					}
                    }
			        }
			        }
			   
				
				
				
				
				
