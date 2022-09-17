
if (start==1){

//now_rule=0;
if (rule_engadged==0){
if (Heat_rule[now_rule]==1){//по достижению времени
    rule_engadged=1;
    Heat_time_timer_enabler=1;//включаем счетчик секунд
    }
if (Heat_rule[now_rule]==2){//по достижению температуры
    rule_engadged=1;
//    Heat_time_timer_enabler=1;//включаем счетчик секунд
}
if (Heat_rule[now_rule]==3){//конец правил
    rule_engadged=1;
//    Heat_time_timer_enabler=1;//включаем счетчик секунд
}
}

 
        if (now_tempB<Heat_temp_B[now_rule]){
        //heat_approved[1]=1;
        }
        else{ 
        heat_approved[1]=0;
        } 
        if (now_tempU<Heat_temp_U[now_rule]){
        //heat_approved[0]=1;
        }else{ 
        heat_approved[0]=0;
        }



if (rule_engadged==1){
    if (Heat_rule[now_rule]==2){

    if (now_tempU>=Heat_temp_U[now_rule]){rule_end=1;} 
   
    }
if (Heat_rule[now_rule]==1){        
  if (Heat_time_timer<Heat_time[now_rule]){//если таймер нагрева меньше

  }
    else{
    rule_end=1;
    }
  }
if (rule_end==1){





    sec_profile[0]=0;
  
    buzz_cont=50;buzz_freg=178;
    now_rule++;
    rule_end=0;
    t_sec=t_min=t_hour=0;
    rule_engadged=0;
    Heat_time_timer=0;
    Heat_time_timer_enabler=0;
    heat_approved[0]=0;
    sec_profile_off[0]=0;
}
}    



}









    

