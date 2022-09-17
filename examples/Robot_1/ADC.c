

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
adc1 = ADCH;
}