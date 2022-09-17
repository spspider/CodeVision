
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

void _lcd_write_data(unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_write_byte(unsigned char addr, unsigned char data);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

void lcd_putse(char eeprom *str);

void lcd_init(unsigned char lcd_columns);

#pragma library alcd.lib

void eeprom_read_block(void *dst,eeprom void *src,unsigned short n);
void eeprom_write_block(void *src,eeprom void *dst,unsigned short n);
#pragma library eeprom.lib

char lcd_buffer[33],lcd_stateU,lcd_stateB,choose[13];
unsigned char Timer_1,Timer_2;
bit BTN3_pressed;

eeprom unsigned char PWM_setted_eeprom[2]={1,1};
unsigned char PWM_setted[2]={1,1};
unsigned char PWM_width=10;

int now_tempU=0,now_tempB=0;

unsigned char show_lcd=3,t_sec=0,t_min=0,t_hour=0,port,PWM_step[2],heater_on[2],sec_heat[2],lcd_switcher=1,BTN1_pressed,lcd_freeze,heater_swither=3,start=0,start_BT=0;
unsigned int sec_profile[2],sec_profile_off[2];
int now_tempB_prev=0,now_tempU_prev=0;

unsigned char k=0;

unsigned char buzz_freg=0,buzz_cont=0;

unsigned char BTN_pressed=0,Timer_BTN_Pressed=0;
unsigned char Timer_1sec=0;

unsigned char heat_approved[2]={0,0};
unsigned char  Heat_time_timer_enabler=0,Heat_time[4],Heat_rule[4],Heat_time_timer=0;
unsigned char  count_rules=0,now_rule=0,rule_engadged=0,rule_end=0,set_now_rule=0;
unsigned int Heat_temp_U[4],Heat_temp_B[4];
unsigned char Heat_speed[4],Heat_speed_B;
eeprom unsigned int Heat_temp_U_eeprom[4],Heat_temp_B_eeprom[4];
eeprom unsigned char Heat_speed_eeprom[4],Heat_speed_B_eeprom;
unsigned char i;
unsigned int sec_start_heat[2];

unsigned char freq=111;
bit compliteU=0;
bit compliteB=0;
int  now_tempB_calc,now_tempU_calc;

float heat_koeff_B =-0.01,heat_koeff_U=-0.01,PWM_koeff[2]={1.0,1.0};

int forecast_temp_U=0,forecast_temp_B=0;

unsigned int t_sec_least=0.0;
unsigned char t_min_least=0,t_hour_least;
unsigned char t_power_change_up[2],t_power_change_down[2];

unsigned int koeff_b_int,koeff_u_int;

int heat_k_B_int;
int heat_k_U_int;
void choose_v(char i){

for (k=0;k<13;k++){
choose[k]=*" ";
}
choose[i]=*">";
}

interrupt [10] void timer0_ovf_isr(void)
{
TCNT0=0x00;

for (port=0;port<2;port++){
if (heater_on[port]==1){ 
if (PWM_setted[port]<PWM_step[port]){PORTD&= ~1<<(3-port);} 
if (PWM_setted[port]>=PWM_step[port]){PORTD|=1<<(3-port);}
if (PWM_step[port]>=PWM_width){PWM_step[port]=0;}
PWM_step[port]++;                   
}

if (heater_on[port]==0){
PORTD&= ~(1<<(3-port));}
}

}

interrupt [9] void timer1_ovf_isr(void)
{

TCNT1H=0xD8F0 >> 8;
TCNT1L=0xD8F0 & 0xff;

Timer_1++;

if (buzz_cont>0){
buzz_cont--;
}
if (BTN_pressed==1){
Timer_BTN_Pressed++;
if (Timer_BTN_Pressed>20){
Timer_BTN_Pressed=0;
BTN_pressed=0;
} 
}

Timer_1sec++;
if (Timer_1sec>100){

if (t_sec==59){

if (Heat_time_timer_enabler==1){
Heat_time_timer++;
}
else{
Heat_time_timer=0;
}

t_min++;t_sec=0;}
if (t_min>60){t_hour++;t_min=0;}
Timer_1sec=0;

if (start==0){
lcd_stateU=*"_";heater_on[0]=0;now_rule=0;
now_tempU_prev=now_tempU;

sec_profile[0]=t_sec=0;
rule_end=0;
sec_profile_off[0]=0;

now_tempU_prev=now_tempU;
now_tempU_calc=now_tempU;

}
PWM_setted_eeprom[0]=PWM_setted[0];
PWM_setted_eeprom[1]=PWM_setted[1];

if (start==1){

if (heat_approved[0]==0){now_tempU_calc=now_tempU;sec_start_heat[0]=0;}
if (heat_approved[0]==1){sec_start_heat[0]++;}

heat_koeff_U=((now_tempU-now_tempU_calc)*1.00)/(sec_start_heat[0]*1.00);
PWM_koeff[0]=heat_koeff_U*1.00/(Heat_speed[now_rule]*1.0/10.0);
if (sec_start_heat[0]>2){
if (PWM_koeff[0]<0.5){ if (PWM_setted[0]<10){PWM_setted[0]++;};}}
if (PWM_koeff[0]>1.5){ if (PWM_setted[0]>0) {PWM_setted[0]--;};}

if (forecast_temp_U<=(now_tempU+30)){
if (forecast_temp_U<Heat_temp_U[now_rule]){
if (now_tempU<Heat_temp_U[now_rule]){
sec_profile[0]++;
}
}
}
if (forecast_temp_U>=(now_tempU+30)){

sec_profile[0]=(now_tempU*1.0/(Heat_speed[now_rule]*1.00/10.00))-now_tempU_prev;
now_tempU_prev=now_tempU;
now_tempU_calc=now_tempU;
}

if (forecast_temp_U<Heat_temp_U[now_rule]){
forecast_temp_U=now_tempU_prev+sec_profile[0]*(Heat_speed[now_rule]*1.00/10.00);;
}
else{

forecast_temp_U=Heat_temp_U[now_rule];
}

if ((now_tempU==Heat_temp_U[now_rule])&&compliteU==0){compliteU=1;buzz_freg=50;buzz_cont=10;now_tempU_calc=now_tempU;}  

if (forecast_temp_U<=now_tempU){

heat_approved[0]=0;
t_power_change_up[0]=0;
t_power_change_down[0]++;
lcd_stateU=*"|";
heater_on[0]=0;
sec_heat[0]=0;

;}
if (forecast_temp_U>now_tempU){
if (Heat_temp_U[now_rule]>now_tempU){ 
heat_approved[0]=1;
heater_on[0]=1;lcd_stateU=*"H";
t_power_change_up[0]++;
t_power_change_down[0]=0;
if (PWM_setted[0]<1){PWM_setted[0]=1;}
;}
;}

}
if (start_BT==0){
now_tempB_prev=now_tempB;
lcd_stateB=*"_";heater_on[1]=0;
now_tempB_prev=now_tempB;
sec_profile[1]=0;sec_profile_off[1]=0;
PORTB.1=0;
sec_profile[1]=0;
now_tempB_prev=now_tempB;
now_tempB_calc=now_tempB;

}
if (start_BT==1){

if (heat_approved[1]==0){now_tempB_calc=now_tempB;sec_start_heat[1]=0;}
if (heat_approved[1]==1){sec_start_heat[1]++;}

heat_koeff_B=(now_tempB-now_tempB_calc)/sec_start_heat[1];
PWM_koeff[1]=heat_koeff_B*1.00/(Heat_speed_B*1.0/10.0);
if (sec_start_heat[1]>2){
if (PWM_koeff[1]<0.5){ if (PWM_setted[1]<10){PWM_setted[1]++;};}}
if (PWM_koeff[1]>1.5){ if (PWM_setted[1]>0) {PWM_setted[1]--;};}

if (forecast_temp_B<Heat_temp_B[now_rule]){
forecast_temp_B=now_tempB_prev+sec_profile[1]*Heat_speed_B*1.00/10.0;
}
else{

forecast_temp_B=Heat_temp_B[now_rule];
}

if (forecast_temp_B<=(now_tempB+30)){
if (forecast_temp_B<=Heat_temp_B[now_rule]){
if (now_tempB<=Heat_temp_B[now_rule]){
sec_profile[1]++ 
;}
;}
;} 
if (forecast_temp_B>=(now_tempB+30)){

sec_profile[1]=(now_tempB*1.0/(Heat_speed_B*1.00/10.00))-now_tempB_prev;
now_tempB_prev=now_tempB;
now_tempB_calc=now_tempB;
}

if ((now_tempB==Heat_temp_B[now_rule])&&compliteB==0){compliteB=1;buzz_freg=50;buzz_cont=10;}

if (forecast_temp_B>now_tempB){  
if (Heat_temp_B[now_rule]>now_tempB){  
heat_approved[1]=1;
heater_on[1]=1;lcd_stateB=*"H";
t_power_change_up[1]++;
t_power_change_down[1]=0;
if (PWM_setted[1]<1){PWM_setted[1]=1;}

}
}
if (forecast_temp_B<now_tempB){       

heat_approved[1]=0;
lcd_stateB=*"|";
heater_on[1]=0;
sec_heat[1]=0;
t_power_change_up[1]=0;
t_power_change_down[1]++;

}

}

}

}
interrupt [5] void timer2_ovf_isr(void)
{

TCNT2=0x06;

if (buzz_cont>0){
PORTB.2^=1;
}
else{
PORTB.2=0;

}
TCNT2=buzz_freg;

}

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ((0<<7       ) | (0<<6       ) | (0<<5       ));

delay_us(100);

ADCSRA|=(1<<6       );

while ((ADCSRA & (1<<4       ))==0);
ADCSRA|=(1<<4       );
return ADCW;
}

void main(void)
{

lcd_gotoxy(0,0);
lcd_putsf("Loading");
buzz_freg=178;buzz_cont=20;

lcd_stateU=*" ";
lcd_stateB=*" ";

for (k=0;k<13;k++){
choose[k]=*" ";
}
for (k=0;k<5;k++){

}
choose_v(0);

Heat_rule[0]=3;
Heat_time[0]=2;
Heat_temp_U[0]=240;
Heat_temp_B[0]=160;
Heat_speed[0]=10;
Heat_speed_B=10;
sec_profile[0]=10;

Heat_rule[1]=0;
Heat_time[1]=1;
Heat_temp_U[1]=150;
Heat_temp_B[1]=150;
Heat_speed[1]=10;

Heat_rule[2]=0;
Heat_temp_U[2]=230;
Heat_temp_B[2]=150;
Heat_speed[2]=10;

Heat_rule[3]=0;
Heat_temp_U[3]=230;
Heat_temp_B[3]=150;
Heat_speed[3]=8;

if ((PWM_setted_eeprom[0]>0)&&(PWM_setted_eeprom[0]<11)){PWM_setted[0]=PWM_setted_eeprom[0];}
if ((PWM_setted_eeprom[1]>0)&&(PWM_setted_eeprom[1]<11)){PWM_setted[1]=PWM_setted_eeprom[1];}
if ((Heat_speed_B_eeprom>0)&&(Heat_speed_B_eeprom<50)){Heat_speed_B=Heat_speed_B_eeprom;}
for (i=0;i<4;i++){
if ((Heat_temp_U_eeprom[i]>0)&&(Heat_temp_U_eeprom[i]<255)){Heat_temp_U[i]=Heat_temp_U_eeprom[i];}
if ((Heat_temp_B_eeprom[i]>0)&&(Heat_temp_B_eeprom[i]<255)){Heat_temp_B[i]=Heat_temp_B_eeprom[i];}
if ((Heat_speed_eeprom[i]>0)&&(Heat_speed_eeprom[i]<255)){Heat_speed[i]=Heat_speed_eeprom[i];}

}
count_rules=2;

DDRB=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (1<<2       ) | (1<<1       ) | (0<<0       );

PORTB=(0<<7       ) | (0<<6       ) | (1<<5       ) | (1<<4       ) | (1<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

DDRC=(0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

PORTC=(0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

DDRD=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (1<<3       ) | (1<<2       ) | (0<<1       ) | (0<<0       );

PORTD=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

TCCR0=(1<<2       ) | (0<<1       ) | (1<<0       );
TCNT0=0x70;

TCCR1A=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<1       ) | (0<<0       );
TCCR1B=(0<<7       ) | (0<<6       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (1<<1       ) | (0<<0       );
TCNT1H=0xD8;
TCNT1L=0xF0;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0<<3       ;
TCCR2=(0<<6          ) | (0<<5       ) | (0<<4       ) | (0<<3          ) | (1<<2       ) | (0<<1       ) | (0<<0       );
TCNT2=0xAD;
OCR2=0x00;

TIMSK=(0<<7       ) | (1<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (1<<2       ) | (1<<0       );

MCUCR=(0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

UCSRB=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

ACSR=(1<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

ADMUX=((0<<7       ) | (0<<6       ) | (0<<5       ));
ADCSRA=(1<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (1<<1       ) | (1<<0       );
SFIOR=(0<<3       );

SPCR=(0<<7       ) | (0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<3       ) | (0<<2       ) | (0<<1       ) | (0<<0       );

TWCR=(0<<6       ) | (0<<5       ) | (0<<4       ) | (0<<2       ) | (0<<0       );

lcd_init(16);

#asm("sei")

while (1)
{
if (Timer_2==5){  
now_tempU=512-read_adc(0)/2;
now_tempB=512-read_adc(1)/2;
Timer_2=0;
}
if (Timer_1==20){

lcd_clear(); 
if (show_lcd!=5){

sprintf(lcd_buffer,"%c%3d%c%3dT%3d-%3d",lcd_stateU,now_tempU,lcd_stateB,now_tempB,forecast_temp_U,forecast_temp_B);

lcd_gotoxy(0,0);        
lcd_puts(lcd_buffer);

}
if (lcd_freeze==0){
if(lcd_switcher==0){show_lcd=0;}
if(lcd_switcher==4){show_lcd=2;}
if(lcd_switcher==6){show_lcd=4;}
if(lcd_switcher>8){lcd_switcher=0;}
}

if ((show_lcd==0)||(show_lcd==1)){

lcd_gotoxy(0,1);
heat_k_B_int= (int)(PWM_koeff[1]*10.0);
heat_k_U_int= (int)(PWM_koeff[0]*10.0);
if (heat_k_U_int>99){heat_k_U_int=99;}
if (heat_k_U_int<-99){heat_k_U_int=-9;}
if (heat_k_B_int>99){heat_k_B_int=99;}
if (heat_k_B_int<-99){heat_k_B_int=-9;}

sprintf(lcd_buffer,"%2dU%2dR%1dP%d-%d",heat_k_B_int,heat_k_U_int,now_rule,PWM_setted[0],PWM_setted[1]);
lcd_puts(lcd_buffer);

}
if (show_lcd==2){ 
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cPmU:%d%cPmB:%d",choose[1],PWM_setted[0],choose[2],PWM_setted[1]);
lcd_puts(lcd_buffer);
}
if (show_lcd==3){
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cst_U:%d%cst_B:%d",choose[0],start,choose[12],start_BT);
lcd_puts(lcd_buffer);
}
if (show_lcd==5){
lcd_gotoxy(0,0);

sprintf(lcd_buffer,"%cSb%d",choose[9],Heat_speed_B);

lcd_puts(lcd_buffer);
lcd_gotoxy(0,1);
sprintf(lcd_buffer,"%cSp%d%cU%d%cB%d",choose[8],Heat_speed[set_now_rule],choose[10],Heat_temp_U[set_now_rule],choose[11],Heat_temp_B[set_now_rule]);
lcd_puts(lcd_buffer);
}

if (show_lcd==6){
lcd_gotoxy(0,1);

koeff_b_int=(int)(heat_koeff_B*100.0);
koeff_u_int=(int)(heat_koeff_U*100.0);
sprintf(lcd_buffer,"kB:%dkU:%d",koeff_b_int,koeff_u_int);
lcd_puts(lcd_buffer);

}
Timer_1=0;
Timer_2++;
}

if (start==1){

if (rule_engadged==0){
if (Heat_rule[now_rule]==1){
rule_engadged=1;
Heat_time_timer_enabler=1;
}
if (Heat_rule[now_rule]==2){
rule_engadged=1;

}
if (Heat_rule[now_rule]==3){
rule_engadged=1;

}
}

if (now_tempB<Heat_temp_B[now_rule]){

}
else{ 
heat_approved[1]=0;
} 
if (now_tempU<Heat_temp_U[now_rule]){

}else{ 
heat_approved[0]=0;
}

if (rule_engadged==1){
if (Heat_rule[now_rule]==2){

if (now_tempU>=Heat_temp_U[now_rule]){rule_end=1;} 

}
if (Heat_rule[now_rule]==1){        
if (Heat_time_timer<Heat_time[now_rule]){

}
else{
rule_end=1;
}
}
if (rule_end==1){

sec_profile[0]=0;

buzz_cont=50;buzz_freg=178;
now_rule++;
rule_end=0;
t_sec=t_min=t_hour=0;
rule_engadged=0;
Heat_time_timer=0;
Heat_time_timer_enabler=0;
heat_approved[0]=0;
sec_profile_off[0]=0;
}
}    

}

if ((PINB.5==0)&&(BTN_pressed==0)){  
if(heater_swither==1){if (PWM_setted[0]<10){PWM_setted[0]++;};show_lcd=2;}
if(heater_swither==2){if (PWM_setted[1]<10){PWM_setted[1]++;};show_lcd=2;}
if(heater_swither==3){start=1;buzz_freg=131;buzz_cont=50;}; 
if (heater_swither==4){start_BT=1;buzz_freg=131;buzz_cont=50;}

if (heater_swither==8){show_lcd=5;if (set_now_rule<10){set_now_rule++;};}
if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]<2){Heat_rule[set_now_rule]++;};}

if (heater_swither==10){show_lcd=5;if (Heat_speed_B<100){Heat_speed_B++;};}
if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]++;}
if (heater_swither==12){show_lcd=5;heater_swither=13;}
if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]<450){Heat_temp_U[set_now_rule]++;};}
if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]<450){Heat_temp_B[set_now_rule]++;};}

if (heater_swither==15){show_lcd=6;;}

lcd_freeze=5;
BTN1_pressed=1;
BTN_pressed=1;
}

if ((PINB.3==0)&&(BTN_pressed==0)){
if(heater_swither==1){if (PWM_setted[0]>0){PWM_setted[0]--;};show_lcd=2;}
if(heater_swither==2){if (PWM_setted[1]>0){PWM_setted[1]--;};show_lcd=2;}
if(heater_swither==3){start=0;buzz_freg=6;buzz_cont=100;};
if (heater_swither==4){start_BT=0;buzz_freg=131;buzz_cont=50;}

if (heater_swither==8){show_lcd=5;if (set_now_rule>0){set_now_rule--;};}
if (heater_swither==9){show_lcd=5;if(Heat_rule[set_now_rule]>0){Heat_rule[set_now_rule]--;}else{Heat_rule[set_now_rule]=0;};}

if (heater_swither==10){show_lcd=5;if (Heat_speed_B>1){Heat_speed_B--;};}
if (heater_swither==11){show_lcd=5;Heat_speed[set_now_rule]--;}
if (heater_swither==12){heater_swither=13;}
if (heater_swither==13){show_lcd=5;if (Heat_temp_U[set_now_rule]>0){Heat_temp_U[set_now_rule]--;};}
if (heater_swither==14){show_lcd=5;if (Heat_temp_B[set_now_rule]>0){Heat_temp_B[set_now_rule]--;};}

if (heater_swither==15){show_lcd=6;;}

BTN_pressed=1;
lcd_freeze=5;

}

if ((PINB.4==0)&&(BTN3_pressed==0)&&(BTN_pressed==0)){

heater_swither++;
if (heater_swither>15){heater_swither=1;}

if (heater_swither==1){choose_v(1);show_lcd=2;} 
if (heater_swither==2){choose_v(2);show_lcd=2;} 
if (heater_swither==3){show_lcd=3;choose_v(0);} 
if (heater_swither==4){show_lcd=3;choose_v(12);} 
if (heater_swither==5){heater_swither=6;};
if (heater_swither==6){show_lcd=1;}
if (heater_swither==7){heater_swither=8;}
if (heater_swither==8){show_lcd=5;choose_v(5);if (start==1){set_now_rule=now_rule;};}

if (heater_swither==8){heater_swither=10;}
if (heater_swither==10){show_lcd=5;choose_v(9);}
if (heater_swither==11){show_lcd=5;choose_v(8);}
if (heater_swither==12){heater_swither=13;}
if (heater_swither==13){show_lcd=5;choose_v(10);}
if (heater_swither==14){show_lcd=5;choose_v(11);}
if (heater_swither==15){show_lcd=6;}

for (i=0;i<4;i++){
Heat_temp_U_eeprom[i]=Heat_temp_U[i];
Heat_temp_B_eeprom[i]=Heat_temp_B[i];
Heat_speed_eeprom[i]=Heat_speed[i];
}
Heat_speed_B_eeprom = Heat_speed_B;

BTN3_pressed=1;
BTN_pressed=1;
lcd_freeze=5;

buzz_freg=131;buzz_cont=10;

}

if((PINB.4==1)&&(BTN3_pressed==1)){
BTN3_pressed=0;

}

}
}
