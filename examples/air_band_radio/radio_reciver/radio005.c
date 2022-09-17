// ��������� ��� �������� PIC ����������� P16F84A ��� ����������� C2C
//
// ������������� ���� �������� ������������ ��������� ��������� ��������� 
// FM �������� �� 88 ��� �� 107.975 ���, 
// � ����� ����������� AM �������� �� 108 ��� �� 136 ���. 
// ������������� ��������������� �� AM � FM ��� �������� �� 
// ��������������� ��������. ������� ���� �������� ��������� ��������� 
// ����������� � ����������� �������� ���������� ATIS � ������������ ���������� 
// � ������������� ��������� � ������ � ����� ����������� ������������ 
// ������ �� ��� �� ������������� ������������ �������������� ���������� 
// ������� � ����������� �������� ��������� � ����� ������.
// �������� ����� ����� �������������� � ���������� ��� �������� �����������. 
// ��� ���������� ������������� ������������ ����������� �������� ����� 
// ������������ FM �������� � ������������ ������� (��� ������ ������� � ������).
// � ��������� ���� FM �������� �� "���������" � ��� ������� "�������" ��� 
// ��������� ����������� ������ �� ��� ����������� ���������.

// �������� �������� ����������� ����� ��� ��������� �������, 
// ��������� ��������� � ��������� ��������������. 
// ��� ��������� ������� ������������� �� ������� 
// ����� ����� ����������� = 108 ���.

// ��� ���������� ������ �������������� ������� ���������� � ��������� 
// ��� ������� �������� � ����������� ��������� ���������� ���� � 
// �������� �������.

// ������� �������������� ������ ���������: - ����������
// �����   ��������� �������
// e-mail  shapovalov@windows.ru 
// WEB     http://www.windows.ru/velocity
// ������  1.005 �� 12/11/2004
// ��������� � ������:
// ������� ������� ��������� �������


#define START_FREQ 4320  // 108.0 ���  ��������� �������

#define TIMER_DIV        255 
#define TIMER_PRESCALER  1
#define T0IF_BIT         2

char LOAD_FREQ;      // 1 - ��������� ������� � ����������
char SET_DISPLAY;    // 1 - ��������� ������� �� �������
char LOAD_STEP;      // ��� ��������� �������� ������� �����������
char LOAD_DISPLAY;   // ��� ��������� �������� ������� LCD �������
char OUT_PORT_A;     // ���������� ��� ������ � ���� A
char OUT_PORT_B;     // ���������� ��� ������ � ���� B
long FREQ_FULL;      // ������� ���������
long FREQ_LO;        // ���������� ������� ��� ��������� �����������
long FREQ_DISPLAY;   // ���������� ������� ��� ����������� �� LCD �������
char FREQ_XX;        // ��������� ��������� ���� ����������� � ��� ����������
char NUM_BIT;        // ������� �����
char SW001;          // ���� 1/0
char SIGN;           // ��������� ������� �������� ��� ������ �� ������� LCD
char BITS;           // �������
char SWKEY_UP;       // ������ ������
char SWKEY_MH;       // ������ ������
long WSX;            // ������� �������� ���������� LCD �������
char WS3;            // ����
char D[11];          // ������ ������ �������� ��� LCD �������

char MH_KH;          // ������������� ��� - ���
char PREV;
char CURR;

asm{ __config _CP_ON & _WDT_OFF & _RC_OSC }

void process(void)
{
//############ �������� ������� ##############################################

  if(LOAD_FREQ == 1) {  // = 1 ��������� ������� � ����������

   switch(LOAD_STEP)
   {
     case 0:        // ��������� ������ � �������� ����������� � ������� ������
       OUT_PORT_A=(OUT_PORT_A&0xF8)+0x2;
       NUM_BIT=0;
       SW001=0;
       FREQ_LO = FREQ_FULL+0x1AC;
       if (FREQ_FULL>=4320) {FREQ_XX = 0xA4;} else {FREQ_XX = 0xA1;}
       LOAD_STEP++;
     break;

     case 1:        // ��������� ������� ��������� ����������� 16 ���
       if(NUM_BIT<16) {
        if(SW001==0) {

         SW001=1;
        } else {
         FREQ_LO=FREQ_LO>>1;
         SW001=0;
         NUM_BIT++;
        }
        OUT_PORT_A=(OUT_PORT_A&0xFA)+SW001+((FREQ_LO&0x1)<<2);
       } else {
         NUM_BIT=0;
         LOAD_STEP++;

       }
     break;         //-------------------------------------

     case 2:        // ��������� ������ ��������� ����������� 8 ���
       if(NUM_BIT<8) {
        if(SW001==0) {

         SW001=1;
        } else {
         FREQ_XX=FREQ_XX>>1;
         SW001=0;
         NUM_BIT++;
        }
        OUT_PORT_A=(OUT_PORT_A&0xFA)+SW001+((FREQ_XX&0x1)<<2);
       } else {
         NUM_BIT=0;
         LOAD_STEP++;

       }
     break;         //-------------------------------------

     case 3:        // ��������� ������ � �������� �����������
       OUT_PORT_A=OUT_PORT_A&0xF8;
       LOAD_FREQ = 0;   // ������ �������� �������
       LOAD_STEP = 0;
     break;

   }   // ����� case LOAD_STEP

  }  // ����� �������� ���������� ������ ������� 

//############ ������� #######################################################

  if(SET_DISPLAY==1) {
  if(WS3>0) {
    OUT_PORT_B=(OUT_PORT_B&0xDF);        // ������ ������ (���������� 0)
    WS3--;
    if(WS3==0) {
      OUT_PORT_B=(OUT_PORT_B&0xDF)+0x20; // ������ ������ (���������� 1)
    }
  } else {
   switch(LOAD_DISPLAY)
   {
     case 0:   // ���������� ������� � �������������� ������ ������
       FREQ_DISPLAY  =FREQ_FULL;
       if(FREQ_DISPLAY>=4000) {D[2]=1; FREQ_DISPLAY=FREQ_DISPLAY-4000;} else {D[2]=0;}
       if(FREQ_DISPLAY>=400) {  // ������� ���
         D[3]=0;
         while (FREQ_DISPLAY>=400) {
          FREQ_DISPLAY=FREQ_DISPLAY-400;
          D[3]=D[3]+1;
         }
       } else {D[3]=0xA;}
       if(FREQ_DISPLAY>=40) {   // ������� ���
         D[4]=0;
         while (FREQ_DISPLAY>=40) {
          FREQ_DISPLAY=FREQ_DISPLAY-40;
          D[4]=D[4]+1;
         }
       } else {D[4]=0xA;}
       if(FREQ_DISPLAY>=4) {    // ����� ���
         D[6]=0;
         while (FREQ_DISPLAY>=4) {
          FREQ_DISPLAY=FREQ_DISPLAY-4;
          D[6]=D[6]+1;
         }
       } else {D[6]=0xA;}
       if(FREQ_DISPLAY==0) {D[7]=0xA;D[8]=0xA;} // ������� � ������� ���
       if(FREQ_DISPLAY==1) {D[7]=2;D[8]=5;}
       if(FREQ_DISPLAY==2) {D[7]=5;D[8]=0xA;}
       if(FREQ_DISPLAY==3) {D[7]=7;D[8]=5;}
       D[5]=0xF; // ����� ����� ��� � ���
       if(MH_KH==0) {D[1]=0;D[10]=12;} else {D[1]=13;D[10]=0;}
       SIGN=1;
       BITS=0;
       OUT_PORT_B=(OUT_PORT_B&0xDF)+0x20;
       LOAD_DISPLAY++;
     break;

     case 1:   // �������� ������� �� �������
       if(SIGN<=10) {
        if (BITS<4) {
          D[0]=((D[SIGN]>>3)&1);
          D[SIGN]=D[SIGN]<<1;
          BITS++;
          OUT_PORT_B=(OUT_PORT_B&0x9F)+(D[0]<<6)+0x20;
          WS3=2;
        } else {
          BITS=0;
          SIGN++;
        }
       } else {
         LOAD_DISPLAY++;
       }
     break;
     case 2:   // �������� ������� �� �������
       LOAD_DISPLAY=0;
       SET_DISPLAY=0;
     break;
   }
  }
  }

//############ AM / FM #######################################################

    if(FREQ_FULL>=4320) {                 // �������������� ������������� AM/FM
      OUT_PORT_A=(OUT_PORT_A&0xEF);       // AM
    } else {
      OUT_PORT_A=(OUT_PORT_A&0xEF)+0x10;  // FM
    }

//############ ������ ########################################################

//    if((input_port_b()&0x1)!=0) {                        // ������� �����
//      if(SWKEY_UP<5) SWKEY_UP++;
//    } else {
//      if(SWKEY_UP==5) { // ������� �������
//        if (MH_KH==0) {
//         if (FREQ_FULL<5440) { FREQ_FULL++;}             // ������� ����� 25 ���
//        } else {
//         if (FREQ_FULL<=5400) { FREQ_FULL=FREQ_FULL+40;} // ������� �����  1 ���
//        }
//        LOAD_FREQ = 1;   // ��������� �������
//        SET_DISPLAY= 1;
//      }
//      SWKEY_UP=0;
//    }

//    if((input_port_b()&0x2)!=0) {                        // ������� ����
//      if(SWKEY_UP<5) SWKEY_UP++;
//    } else {
//      if(SWKEY_UP==5) { // �������� �������
//        if (MH_KH==0) {
//         if (FREQ_FULL>3520) { FREQ_FULL--;}             // ������� ���� 25 ���
//        } else {
//         if (FREQ_FULL>=3560) { FREQ_FULL=FREQ_FULL-40;} // ������� ����  1 ���
//        }
//        LOAD_FREQ = 1;   // ��������� �������
//        SET_DISPLAY= 1;
//      }
//      SWKEY_UP=0;
//    }



//----
     CURR=(input_port_b()&0x3);
     if(PREV==3) {
      if (CURR==2) {
        if (MH_KH==0) {
         if (FREQ_FULL<5440) { FREQ_FULL++;}             // ������� ����� 25 ���
        } else {
         if (FREQ_FULL<=5400) { FREQ_FULL=FREQ_FULL+40;} // ������� �����  1 ���
        }
        LOAD_FREQ = 1;   // ��������� �������
        SET_DISPLAY= 1;
        PREV=4;
      }
      if (CURR==1) {
        if (MH_KH==0) {
         if (FREQ_FULL>3520) { FREQ_FULL--;}             // ������� ���� 25 ���
        } else {
         if (FREQ_FULL>=3560) { FREQ_FULL=FREQ_FULL-40;} // ������� ����  1 ���
        }
        LOAD_FREQ = 1;   // ��������� �������
        SET_DISPLAY= 1;
        PREV=4;
      }
     }
     if(CURR==3) {
      if(SWKEY_UP<10) SWKEY_UP++;
     } else {
      if(SWKEY_UP>0) SWKEY_UP--;
     }
     if(SWKEY_UP== 10) PREV=3;
     if(SWKEY_UP==  0) PREV=4;

//----
    if((input_port_b()&0x4)==0) {  // ������������ ���� ��������� ������
      if(SWKEY_MH<10) SWKEY_MH++;
    } else {
      if(SWKEY_MH==10) { // ������� �������
       if (MH_KH==0) {MH_KH=1;} else {MH_KH=0;} // ������������ ������ ��� - ���
        SET_DISPLAY= 1;
      }
      SWKEY_MH=0;
    }


}

//############ ���������� �� ������� #########################################

void interrupt( void )
{
   if(INTCON & (1<<T0IF_BIT)){
     TMR0= TIMER_DIV;
     clear_bit(INTCON,T0IF_BIT); 
     process();                  // ����� ��������� ���������
     output_port_a(OUT_PORT_A);  // ����� � ���� A
     output_port_b(OUT_PORT_B);  // ����� � ���� B
     if (WSX>0) {WSX--;} else { WSX=35000; SET_DISPLAY =1; } // �������� ����� ������� �� LCD
   }
}

//############ ��������� ������������� � ������ ��������� ####################

void main( void )
{
  INTCON= 0;
  set_bit(STATUS,RP0);
  set_option(TIMER_PRESCALER); 
  clear_bit(STATUS,RP0);
  output_port_a(0); 
  output_port_b(0x20); 
  set_bit(STATUS,RP0);
  set_tris_b(0x1F); 
  set_tris_a(0); 
  clear_bit(STATUS,RP0);
  TMR0= TIMER_DIV;

  SWKEY_UP=0;             // ������ ������ �� ��������
  OUT_PORT_A = 0;         // ������������� ������ ����� A
  OUT_PORT_B = 0x20;      // ������������� ������ ����� B
  FREQ_FULL=START_FREQ;   // ������������������� ��������� �������
  LOAD_DISPLAY = 0;       // ��������� �������� ������� � ������
  LOAD_STEP    = 0;       // ��������� �������� ������� � ������
  SET_DISPLAY  = 1;       // ��������� �������
  LOAD_FREQ    = 1;       // ��������� �������
  WSX=4000;               // ��������� �������� ����� ������� �� LCD
  MH_KH=0;

  enable_interrupt(T0IE); // ��������� ���������� �� �������
  enable_interrupt(GIE);
  for(;;){ }
}
