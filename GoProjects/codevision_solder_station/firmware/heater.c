//if (Bheater==1){



//PWM_setted[0]=5;//������� �������� �����������, ������ �����������
//PWM_setted[1]=4;//������� �������� �����������, ������� �����������
//heat_sec_on[0]=5;
//heat_sec_off[0]=5;
//heat_sec_on[1]=5;
//heat_sec_off[1]=5;

for (port=0;port<2;port++){
    if (heater_on[port]==1){ //heater_on[0]=PORTD. PORTD.2 PORTD.3
        if (PWM_setted[port]<PWM_step[port]){PORTD&= ~1<<(3-port);} //��������� ����, ���� step ������ 10
        if (PWM_setted[port]>=PWM_step[port]){PORTD|=1<<(3-port);}//��������
        if (PWM_step[port]>=PWM_width){PWM_step[port]=0;}
        PWM_step[port]++;                   //������ 0 - 3 ������ 1 - 2
    }

    if (heater_on[port]==0){
    PORTD&= ~(1<<(3-port));}
}
//�������, �������������� ��-���������� ������
//heater_history[200];

