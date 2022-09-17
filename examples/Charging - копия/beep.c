if((a1==1)&&(aStop==1)){
Timer6++;
if (Timer6>=1000)
{
Timer5++;
if(Timer5==10){
PORTD^=0b00000100;
Timer5=0;
}
}
if(Timer6>=1500)
{PORTD&=~0b00000100;
Timer6=0;Timer7++;}
}
if(Timer7>=5){
a1=0;aStop=0;Timer6=Timer5=Timer7=0;
}


if((a1==2)&&(aStop==1)){
Timer6++;
if (Timer6>=800)
{
Timer5++;
if(Timer5==5){
PORTD^=0b00000100;
Timer5=0;
}
}
if(Timer6>=1000)
{PORTD&=~0b00000100;
Timer6=0;Timer7++;}
}
if(Timer7>=2){
a1=0;aStop=0;Timer6=Timer5=Timer7=0;
}