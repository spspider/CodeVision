interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
Timer1++;
Timer2++;
if (Timer2==1500){Timer2=0;a=1;}
if (Timer1==10000){
U2=0;
}
if (Timer1==20000){
U2=1;Timer1=0;
}
Timer_2++;
if (Timer_2==20){Timer_2=1;Timer_3++;} //�������� ���������� PWM �������������, �������� �������� � ��������

if (Timer_2<sig1){U1=1;}else{U1=0;} // sig1 + �������� ������� ��� ����� 0 - �������� 1� ����������
if (U1==1){PORTD|=0b00000100;} //x3,y4
if (U1==0){PORTD&=~0b00000100;}

if (Timer_3>=20){ //�������� ���������



if (U2==1) {if(sig1<20){sig1=sig1+1;}}
if (U2==0) {if(sig1>1){sig1=sig1-1;}else{sig1=0;}}



Timer_3=0;}




}

