//interrupt [TIM2_OVF] void timer2_ovf_isr(void){

void IR(){
PORTD&=~0b00010000;
if (IR_2==1){                 
Timer1++;
if (PINC.0==0) {bit1++;}// подсчет всех принятых бит
if (PINC.0==1) {n++;n1[n]=bit1;Timer1=bit1=0;IR_2=0;} // как только сигнал пропадает, выводит результат подсчета.
//if (PINC.0==1) {printf("Timer=%d bit1=%d#",Timer1,bit1);Timer1=IR_2=bit1=0;IR_Tr=0;} // как только сигнал пропадает, выводит результат подсчета.
if (n==2){//если проходит двойную проверку
   if (n1[1]==n1[2]){//если значение равно следующему
   //FreqT=Timer1;IR_Tr=n=0;
//   printf("bit1=%d#",n1[1]);IR_2=n=0;
    }
   else{
   IR_2=0;IR_Tr=n=0;
   ;}}
   
   }


                                    
if (IR_1==1){

// Place your code here
//PORTB^=0b00000100;
Timer1++;
if (PINC.0==0) {bit1++;}
if (PINC.0==1) {bit0++;}
if (Timer1==FreqT){
Timer1=0;
if (bit1>bit0){// если все (25) битов были положительные, то добавляем 1
//if(bit1+1<FreqT){FreqT=bit1;IR_1=bit1=bit0=Timer1=0;IR_Tr=1;}else{IR_Tr=0;}// если было принято более 2-х нулей в еденицах
//if(bit1==FreqT){FreqT++;}
bit1=bit0=0;
//bit01=0;
//bit10++;
d=d<<1; //сдвигаем переменную для битов
d|=1;//добавляем в конец строки положительный бит
//putchar('1');
}
if (bit0>bit1){
//if(bit0+1<FreqT){FreqT=bit0;IR_1=bit1=bit0=Timer1=0;IR_Tr=1;}else{IR_Tr=0;}// если был принят 0 в еденицах
bit0=bit1=0;
//bit01++;
//bit10=0;
d=d<<1; //сдвигаем переменную для битов
d&=~1;//добавляем в конец строки нулевой бит
//putchar('0');
}
shiftd++;
////////////////////////////
//if ((bit01>=5)||(bit10>=5)){d=d1=d2=d3=shiftd=0;bit10=bit01=0;putchar('n');IR_1=0;bitEr1=bitEr0=0;IR_Tr=1;};//FreqT--;если принято 4-е нуля подряд то таймер останавливается.
if ((shiftd==adress2)){d = 0;}       //9
if ((shiftd==adress3)){d1 = d;d=0;}//15
if ((shiftd==adress4)){d = 0;}//16
//if ((shiftd==adress5)){d2 = d;d=0;}//20
//if ((shiftd==adress6)){d = 0;}     //21
if ((shiftd>=adress7)){d3=d1+d2+d;   //26

//putchar('#');
//printf("#d1=%d d2=%d d3=%d#FreqT=%d IR_Tr=%d#",d1,d2,d3,FreqT,IR_Tr);
//printf("#d=%d#",d3);

IR_1=0;
//printf("#d3=%d FreqT=%d",FreqT);
//putchar('#');

//if (((d3==-19095)||(d3==23188))&&(Timer2==0)){PORTD^=0b00000100;putchar('A');} 
//if (((d3==-19098)||(d3==23187))&&(Timer2==0)){PORTD^=0b00001000;putchar('B');} 



#include <IR_Driver.c>


d=d1=d2=d3=shiftd=bitEr0=bitEr1=0;
//TCCR2&=~0x01;
PORTD|=0b00010000;
//TCCR0|=0x01;
IR_S=1;
}
}
}
}
