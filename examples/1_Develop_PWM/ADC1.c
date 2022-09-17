#define ADC_VREF_TYPE 0x00
#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 5
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
static unsigned char input_index=0;

/*
unsigned char read_adc(unsigned char adc_input)
{
//ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Start the AD conversion
//delay_us(20);
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
//adc0 = ADCH-57;
}
*/
/*
interrupt [ADC_INT] void adc_isr(void){

ADMUX= port | ADC_VREF_TYPE;
//ADMUX=287+1; //287 - стандартное выражение, 1 - номер порта

delay_us(20); //для стабилизации
ADCSRA|=0b1100000;// включение непрерывного определения
while ((ADCSRA & 0b1100000)==0);//ждем пока идет подсчет
ADCSRA|=0x10;
adc[port] = ADCW;//заносим данные в f1
delay_us(20);
}
*/





// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
adc[input_index]=ADCW;
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT)){input_index=0;}
   //input_index=0;
//if(Timer_3>9000){ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;}
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;



// Read the AD conversion result
 ///H - если 8 бит, W - если 10 бит.
//adc[port]=ADCW; ///H - если 8 бит, W - если 10 бит.
// Select next ADC input

//ADMUX=port | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
//delay_us(200);
// Start the AD conversion
//ADCSRA|=0x40;
//while ((ADCSRA & 0b1100000)==0);//ждем пока идет подсчет

//
//
}
