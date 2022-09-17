level=read_adc(0);


to[1]=level/100;

//to[1]=1; 

if(i==0){
    PORTC&=~0b0000010;

}
if(i==to[1]){
    PORTC|=0b0000010;
}
i++;

if(i>10){
i=0;}      