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
 
// ����� ����� ������ �������� ip 
//  � MAC ������
// 
 /*������������� enc28j60*/
#define EEPROM __attribute__ ((section (".eeprom")))

EEPROM uint8_t myip [4] = {10,4,18,100}; // ����� ��������� ����� ip
EEPROM uint8_t myip_reserve [4] = {10,4,18,100}; // ip �� ���������
EEPROM uint8_t searash_mac[6]; // �������� mac ����� ����� ������ ����� �����
//EEPROM uint8_t searash_mac_reserve[6]; // ���������  mac ����� ����� ������ ����� ����� �� ���������
EEPROM uint8_t subnet_mask[4]={255,255,255,0};// ����� ������� ����� ��������� ����� �������
EEPROM uint8_t searash_reserve_maska[4]={255,255,255,0} ; // ����� ������� ����������� ����� ������
EEPROM uint8_t searash_ip[4];
EEPROM uint8_t ip_gw[4];// ����� ������ ip ����� 
EEPROM uint8_t ip_gw_reserve[4]={0,0,0,0};// ����� ������ ip ����� 4

uint8_t pw_status;// ����� ��� ������
static uint8_t mymac[6] = {0x54,0x55,0x58,0x10,0x05,0x24};// ��� mac
static  uint8_t searash_gw[4] ; // ������������� ����� ��� ����� ���� ����� ip ����� ��������� � ���� gw
static  uint8_t searash_subnet [4]; // ������������� ����� ����� ������ ip ����� ������� �������� � ���� ������� 
uint8_t myip_new[4];  // ������������� ����� ip
static uint8_t searash_mac_[6]; // �������� mac ����� ����� ������ ����� ����� �������� �������������
//uint8_t mac_screen[6];
uint8_t ip_screen[4];
static uint8_t IP_SRC[4];// ����� ��� �������� ip ���������
static uint8_t IP_GENERAL[4];//����� ������ ����������
char IP_SCR_CHAR[4];
char IP_GENERAL_CHAR[4];
//uint8_t macaddr_gwi[6]={0x00,0x0f,0x90,0xb9,0x22,0x45};
#define MYWWWPORT 80
#define BUFFER_SIZE 550                // ������ ��������� ������
#define PORT_reset		PORTC	
#define DDR_reset		DDRC	
#define PIN_reset		PINC    
#define reset           3
static  uint8_t buf[BUFFER_SIZE+1];     // �������� �����
#define STR_BUFFER_SIZE 50              // ������ ������ �����
static char gStrbuf[STR_BUFFER_SIZE+1];// ����� �����
#define RECEIVE_BUFFER_SIZE 70         // ������ ������ ������
#define ARP_BUFFER_SIZE 45
char buf_ARP[ARP_BUFFER_SIZE];                      // arp �����
char buf_receive[ RECEIVE_BUFFER_SIZE+1];      // �������� �����  ����
volatile uint8_t i;
uint8_t buf_ware[9];                   // ����� ��� �������� ������� �� ������� �����������
uint8_t 	temp,tt,y;
uint16_t *tmp = (void*)buf_ware;       // ��������� �� �����������, �������� �� �������
uint16_t termus;
static uint8_t flag ;
uint8_t result;				        // ��������� ������ �������
int t;						            // ��������������� ����������
char rr[9];
volatile uint8_t time=0; 
// ���������� �� �������	
 ISR(TIMER1_OVF_vect)
 {
 time++; //  ����������� �������
 } 
uint8_t temperature(int *temp) {
  
	ow_reset();							// ����� 1-wire
	ow_write_byte(OW_SKIP_ROM_CMD);		// ������� "���������� �����"
	ow_write_byte(CMD_START_CONV);		// ������� "������ ���������"
    _delay_ms(100);
	ow_reset();                        // ����� 1-wire
	//����� �� �� ��� ��������� ������ �������, ������ ��������� ������ ���������
	ow_write_byte(OW_SKIP_ROM_CMD);		// ������� "���������� �����"
	 ow_write_byte(CMD_RD_SCRPAD);		// ������� "������� �������� �������"
    //������ ������ �� �������
	for( i=0;i<9;i++){                 // ������ �� ��� ��� ���� �� ������� ��� 9 ������
		buf_ware[i]=ow_read_byte();	// ������ ���� � �����
	   tt = (*tmp>>1);			  
		//t = tt ;	                    
		//*temp = tt;					    
	} 
    tt = (*tmp>>4);                        // ���������� ���� �����������
	t=tt & 0x00ff;                          // ���������� �� ���� 
	if(tt>127){                             // ���� ����������� �������������
	t=tt-256;                             
	}else{
	}                      
	ow_reset();	
	
					// ����� 1-wire
	// ���������� ��������� ������ �������
	return result;
}
// �������� ������
// ���������� 1 ���� ������ ������� ���� ��� 0
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
 // ���� ����� ���� ����� �������� ���������� ����� � �����
 // ��������� � ����� NULL
 // ���� ���� ��������� ���������� 1
 // ���������� ���������� ��������� ��������
uint8_t find_key_val(char *str,char *strbuf, uint8_t maxlen,char *key)   // ���� �������� �����
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
				return(1);    // ���� ���� ��������� ���������� 1
        }
         return(i);
}
// ����������� �������� ip � ����� � �������� � �����
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
// ����������� �������� URL	   �� ������� ������� �������� ���� 
// ���������� ����� ��������� �����
uint8_t analyse_get_url(char *str)
{      
        pw_status=0;
		 if (str[0] == '/' && str[1] == ' '){
                // ���� ��������� ��������
                return(2);
        }
        if (strncmp("/config",str,7)==0){    // ���� ��� ������
                return(3); 
		}		
        if (strncmp("/form?",str,6)==0){         // ��� form
		if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"pw")){
		  pw_status=verify_password(gStrbuf); 
            if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ip"));
                                       parse_ip(myip_new,gStrbuf);
									  // return(1);
			if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"ms")){ // ���� ��� ���� ����� �������
		                              parse_ip(searash_subnet,gStrbuf); // �������� � �����
									   //return(5);    
									   } 						    // return(1);    
		    if(find_key_val(str,gStrbuf,STR_BUFFER_SIZE,"gw")){        // ���� ��� ���� �����
                                      parse_ip(searash_gw,gStrbuf);     // �������� � �����
									   return(4);    
									   } 									
		    return(0);  		// 	���� ������	   
									   }
									   }
									   }
									   
//����� ������� ���� ���������
uint16_t print_webpage(uint8_t *buf)
{
     uint16_t plen=0;
	 result=ow_reset();
     plen=fill_tcp_data_p(buf,plen,PSTR("<head><META HTTP-EQUIV=REFRESH CONTENT=3><title>�����������</title></head><body><div ALIGN=CENTER><i><pre><h1>�����������</pre></h1><br>"));
	 if (result!=1){
     plen=fill_tcp_data_p(buf,plen,PSTR(" ������ �� ������ <br><br><br>  </i></body>"));
     }else{
	 temperature(&t);
	 termus=t; 
     itoa(termus,rr,10);
	 plen=fill_tcp_data_p(buf,plen,PSTR("<div ALIGN=CENTER><br>����������� : "));
	 plen=fill_tcp_data(buf,plen,rr);
	 }
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br><br><br><br><br><form action=/config method=get><div ALIGN=CENTER>������� �� �������� ������������ &nbsp &nbsp<input type=submit value=������� ></form>\n"));
	 
	// if (flag==1){ 
    // plen=fill_tcp_data_p(buf,plen,PSTR("���� ��������� � ����� �������<br></i></body>"));
	//// }else{
	// plen=fill_tcp_data_p(buf,plen,PSTR("���� ��������� �� � �����  �������<br></i></body>"));
	// }
	  plen=fill_tcp_data_p(buf,plen,PSTR("<br></i></body>"));
	
        return(plen);
}
 // �������� ������������ 
uint16_t print_webpage_config(uint8_t *buf)
{
     uint16_t plen=0;
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br><br><br><br><br><form action=/form method=get><div ALIGN=CENTER> ����� IP &nbsp <input type=text name=ip value="));
	 mk_net_str(ip_screen,myip_new,4,'.',10);
     plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br>IP �����  &nbsp<input type=text name=gw value="));
	 mk_net_str(ip_screen,searash_gw,4,'.',10);
     plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br> ����� ������� &nbsp<input type=text name=ms value="));
	 mk_net_str(ip_screen,searash_subnet,4,'.',10);
	 plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br> Mac ����� &nbsp<input type=text  value="));
	 mk_net_str(ip_screen,searash_mac_,6,':',16);
	 plen=fill_tcp_data(buf,plen,ip_screen);
	 plen=fill_tcp_data_p(buf,plen,PSTR("><br><br>������ &nbsp<input type=password name=pw>\n &nbsp &nbsp<input type=submit value=��������� ></form>\n"));
	 plen=fill_tcp_data_p(buf,plen,PSTR("<br></i></body>"));
	 return(plen);
}
// ����������� �������� �������� ���� � acsi ���
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
//  ������� ����							
int main(void){
        int8_t  cmd;
        uint16_t plen;
        uint16_t dat_p;
        WDTCR = (1<<WDCE) | (1<<WDE);
       /* ����. ����������� ������� */
        WDTCR = 0x00; 
		PORT_reset|=BV(3);		// ����������� ���� ��� ������
        DDR_reset|=~BV(3);
		// �������� ������ ��� ������� arp
		TCCR1A&=0x00; // ���������� �����
		TCCR1B|=0b00000101;// ��������� ������������
		TIMSK|=_BV(TOIE1); // �������� ����������
		sei();// ���������
		 for( i=0;i<=4;i++){                 // ������ ip �� ��� ��� ���� �� ������� ��� 4 ����
		myip_new[i]= eeprom_read_byte(&(myip[i]));	// ������ ���� � �����  
		}
		 for( i=0;i<=4;i++){                // ������ ����� ������� �� ��� ��� ���� �� ������� ��� 4 ����
		searash_subnet[i]= eeprom_read_byte(&(subnet_mask[i])); // ������ ���� � �����  
		}
		for( i=0;i<=4;i++){                 // ������ ip ����� ������� �� ��� ��� ���� �� ������� ��� 4 ����
		searash_gw[i]= eeprom_read_byte(&(ip_gw[i]));	// ������ ���� � �����  
		}
		//for( i=0;i<=6;i++){                 // ������ mac ����� ������� �� ��� ��� ���� �� ������� ��� 4 ����
		//searash_mac_[i]= eeprom_read_byte(&(searash_mac[i]));	// ������ ���� � �����  
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
		//result=ow_reset();      // ������ ������
	    //if(result) {ow_write_byte(OW_SKIP_ROM_CMD)	;	// ���� �� �����  ������� "���������� �����"
	   // }	
       

 while(1){
       if(time==1){   // �������� ��� � ������ ���� arp ��� ������ �����
	   while(y<ARP_BUFFER_SIZE ){
       buf_ARP[y]=0;
       y++;
       } 				
      client_arp_whohas(buf_receive,searash_gw);  // ���� ARP ������
	 _delay_ms(1); // 1ms
	  enc28j60PacketReceive(ARP_BUFFER_SIZE,buf_ARP);   // ��������� ����� ���������� arp �����
	  if(buf_ARP[ETH_ARP_OPCODE_L_P]=ETH_ARP_OPCODE_REPLY_L_V ){   // ���� � ���� �����
	   y=0;
	  while(y<6){
       searash_mac_[y]=buf_ARP[ ETH_ARP_SRC_MAC_P+y];  // �������� ���������� ������ � �����
      y++;
	  }
      while(y<ARP_BUFFER_SIZE ){
      buf_ARP[y]=0;
      y++;
      } 
	  }
      //eeprom_write_block(searash_mac_,searash_mac,6);   //����� mac ����� ����� � eeprom	 
	  time=0;
      }
		   // flag=1;
		        data_receive(flag,searash_mac_);
                
                         if (!(PIN_reset & (1 <<  reset ))){    //  ���� ������ ������ 
			//��������� ��������� �� ��������� 
				for( i=0;i<=4;i++){                 // ������ �� ��� ��� ���� �� ������� ��� 4 ����
		        myip_new[i]= eeprom_read_byte(&(myip_reserve[i]));	// ������ ���� � ����� 
                }
				for( i=0;i<=4;i++){                 // ������ �� ��� ��� ���� �� ������� ��� 4 ����
		        searash_subnet[i]= eeprom_read_byte(&(searash_reserve_maska[i]));	// ������ ���� � �����  
				}
				for( i=0;i<=4;i++){                 // ������ �� ��� ��� ���� �� ������� ��� 4 ����
		        searash_gw[i]= eeprom_read_byte(&(ip_gw_reserve[i]));	// ������ ���� � �����  
				}
				eeprom_write_block(searash_gw,ip_gw,4);
				eeprom_write_block(searash_subnet,subnet_mask,4);
				eeprom_write_block(myip_new,myip,4);              //����� ����� IP ����� � eeprom\
				
				WDTCR = (1<<WDE);                                 // ������� ������
                while(1);                                         // � ����
			     
				}
				
                plen= enc28j60PacketReceive(BUFFER_SIZE, buf);// ��������� �����
  			
              
                if(plen==0){       // ���� ����� ����� 0 �� �������
                        continue;
                }
				 y=0;// ����� � ����� ip ����� ��������� 
				while(y<4){
                IP_SCR_CHAR[y]=buf[IP_SRC_P+y];
                   y++;
                } 
              	//data_receive(flag,searash_mac_);
			   parse_ip(IP_SRC,IP_SCR_CHAR); 
				y=0;
				while(y<4){                        // ������ & � ������ �������
				IP_SRC[y]&=searash_subnet[y];
				y++;
				}
				parse_ip(IP_GENERAL,IP_GENERAL_CHAR);
                 y=0;
				while(y<4){                         // ������ & � ������ �������
				IP_GENERAL[y]&=searash_subnet[y];
				y++;
				} 
				 
                 flag=1;                           // ���������� 
               if(*IP_GENERAL!=*IP_SRC){
				flag=0;
				}
                       
               // ����� ����������� �������� �����
                if(eth_type_is_arp_and_my_ip(buf,plen)){ // ����  ��� arp �� 
                        make_arp_answer_from_request(buf);// ���� arp ������
                        continue;
                }

                if(eth_type_is_ip_and_my_ip(buf,plen)==0){ // ���� �������� ip ����� ������ 
                        continue;
                }
				
			
                

                // ����������� ��������� ����
                if(buf[IP_PROTO_P]==IP_PROTO_ICMP_V && buf[ICMP_TYPE_P]==ICMP_TYPE_ECHOREQUEST_V){
                        // ���� ��� ping �� ������ �����
                        make_echo_reply_from_request(buf,plen);
                        continue;
                }
				// ������� ����� ������
                if (buf[IP_PROTO_P]==IP_PROTO_TCP_V&&buf[TCP_DST_PORT_H_P]==0&&buf[TCP_DST_PORT_L_P]==MYWWWPORT){
                        if (buf[TCP_FLAGS_P] & TCP_FLAGS_SYN_V){
						// ���� ������ ���� TCP_FLAGS_SYN_V ����  asc
                                make_tcp_synack_from_syn(buf);
                          continue;
                        }
                        if (buf[TCP_FLAGS_P] & TCP_FLAGS_ACK_V){   // ���� �������� TCP_FLAGS_ACK_V
                                init_len_info(buf); // �������������� �����
                               dat_p=get_tcp_data_pointer();
								for (i=0;i<RECEIVE_BUFFER_SIZE;i++){  // ��������� buf_receive
								buf_receive[i]=buf[dat_p++];
								 }
								dat_p=get_tcp_data_pointer();
                                if (dat_p==0){     // ���� ������ ��� ���� TCP_FLAGS_FIN_V
                                if (buf[TCP_FLAGS_P] & TCP_FLAGS_FIN_V){
                                  make_tcp_ack_from_any(buf);
                                        }
										 continue;
                                }
						
                 	
				     if (strncmp("GET ",(char *)&(buf[dat_p]),4)==0){   // �� ������� ����������� GET 
					 plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n")); 
					 
					 // ���� ��� ��������� ���� ���
					 //plen=print_webpage(buf); 
                    }
					 // ����� ����������� url
				    dat_p=0;
				    cmd=analyse_get_url((char *)&(buf_receive[dat_p+4])); 
                    if(cmd==2){
					plen=print_webpage(buf);
				    }
					if( cmd==4 && pw_status==1){   // ���� ������ ����� ����� 
                    //while(y<ARP_BUFFER_SIZE ){
                  //  buf_ARP[y]=0;
                   // y++;
                   // } 
					//client_arp_whohas(buf_receive,searash_gw);  // ���� ARP ������
					//_delay_ms(1); // 1ms
					//enc28j60PacketReceive(ARP_BUFFER_SIZE,buf_ARP);   // ��������� ����� ���������� arp �����
					//if(buf_ARP[ETH_ARP_OPCODE_L_P]=ETH_ARP_OPCODE_REPLY_L_V ){   // ���� � ���� �����
					// y=0;
					// while(y<6){
                  // searash_mac_[y]=buf_ARP[ ETH_ARP_SRC_MAC_P+y];  // �������� ���������� ������ � �����
                  //  y++;
					//}
					//y=0;
					// while(y<ARP_BUFFER_SIZE){
                   //  buf_ARP[y]=0;
                    //  y++;
				   // ����� ��� � eeprom
					//eeprom_write_block(searash_mac_,searash_mac,6);   //����� mac ����� ����� � eeprom
					eeprom_write_block(searash_gw,ip_gw,4);           //����� IP ����� ����� � eeprom
					eeprom_write_block(searash_subnet,subnet_mask,4); // ����� ����� ������� � eeprom
				    eeprom_write_block(myip_new,myip,4);              //����� ����� IP ����� � eeprom
				    plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<div ALIGN=CENTER> ��� ��"));
					make_tcp_ack_from_any(buf); 
                    make_tcp_ack_with_data(buf,plen); 
	                WDTCR = (1<<WDE);                                 // ������� ������
                    while(1);                                         // � ����
					//} 
					//}
					}
					if(cmd==3){
					plen=print_webpage_config(buf);
					}
					if( cmd==4 && pw_status==0){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>�� ����� �������� ������"));
					}
					if( cmd==4 && pw_status==0){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>�� ����� �������� ������"));
					}
					if( cmd==4 && pw_status==2){
					plen=fill_tcp_data_p(buf,0,PSTR("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n <div ALIGN=CENTER>�� �� ����� ������"));
					}
					
					goto SENDTCP;
SENDTCP:
                    make_tcp_ack_from_any(buf);                        // ���������� ack 
                    make_tcp_ack_with_data(buf,plen);                  // �������� ���� ������
                    continue;
					}
                    }
			        }
			        }
			   
				
				
				
				
				
