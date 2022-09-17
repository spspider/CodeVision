interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
Timer_1++;
if ((PIND.2==1)&&(u1==1)){
roll=31115/Timer_1;
    
printf("%d,",roll);
Timer_1=u1=0;
}
if (PIND.2==0){u1=1;}
}
