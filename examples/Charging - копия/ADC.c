#define ADC_VREF_TYPE 0


unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|(ADC_VREF_TYPE & 0xff);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
