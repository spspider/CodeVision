#define ADC_VREF_TYPE 1


unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
adc1 = ADCH;
}

/*
interrupt [ADC_INT] void adc_isr(void){
//if (U8==3){
ADMUX=287+1; //287 - ����������� ���������, 1 - ����� �����
delay_us(20); //��� ������������
ADCSRA|=0b1100000;// ��������� ������������ �����������
while ((ADCSRA & 0b1100000)==0);//���� ���� ���� �������
adc1 = ADCH;//������� ������ � f1
//}
}
*/