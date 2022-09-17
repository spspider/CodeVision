#include <mega8.h>
#include <delay.h>
#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 0
unsigned char adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x20
interrupt [ADC_INT] void adc_isr(void)                      //����������� ���������� �� ADC �� CVAVR
{
static unsigned char input_index=0;
// Read the 8 most significant bits
// of the AD conversion result
adc_data[input_index]=ADCH;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}
void main(void)
{
PORTD=0x00;
DDRD=0xFF;

ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCC;
#asm("sei")
while (1)
      {
       if(adc_data[0]>10) PORTD.0=1;            //���� �������� ADC>10 (~0.2V)
       else PORTD.0=0;
       if(adc_data[0]>70) PORTD.1=1;            //ADC>70 (~1.4)
       else PORTD.1=0;
       if(adc_data[0]>130) PORTD.2=1;           //~2.5
       else PORTD.2=0;
       if(adc_data[0]>190) PORTD.3=1;           //~3.7
       else PORTD.3=0;
       if(adc_data[0]>250) PORTD.4=1;          //~ 4.9
       else PORTD.4=0;
      };
}
