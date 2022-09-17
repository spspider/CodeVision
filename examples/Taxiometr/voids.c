char q;
void clear(char cl_now)
{        
    for(q=0;q<5;q++){
    if(cl_now==q){cl[q]=1;}
    if(cl_now!=q){cl[q]=0;}
    
    //else{cl[q]=1;}
    }
}