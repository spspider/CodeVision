//buzzer=1;Freq_buzz=600;
if (buzz_cont>0){
PORTB.2^=1;
}
else{
PORTB.2=0;

}
TCNT2=buzz_freg;
//TCNT2=1;
//expalpe:
//buzz_cont=50;buzz_freg=178;

//TCNT2=6;//250
//TCNT2=48;//300
//TCNT2=100;//400
//TCNT2=131;//500
//TCNT2=152;//600
//TCNT2=167;//700
//TCNT2=178;//800

