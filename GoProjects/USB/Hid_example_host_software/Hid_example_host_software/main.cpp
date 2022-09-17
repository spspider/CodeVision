//---------------------------------------------------------------------------
#define  uchar  unsigned char

#include <vcl.h>
#pragma hdrstop
#include "main.h"

#include "hidlibrary.h" // Библиотека для работы с Hid устройствами


#include "../Hid_example_firmware/usbconfig.h"  // Здесь пишем путь к usbconfig.h
char  vendorName[]  = {USB_CFG_VENDOR_NAME, 0}; // для того что бы знать как
char  productName[] = {USB_CFG_DEVICE_NAME, 0}; // называется наше устройство


struct dataexchange_t		// Описание структуры для передачи данных
{
   uchar b1;        // Я решил для примера написать структуру на 3 байта.
   uchar b2;        // На каждый байт подцепим ногу из PORTB. Конечно это
   uchar b3;        // не рационально (всего то 3 бита нужно).
};                  // Но в целях демонстрации в самый раз.
                    // Для наглядности прикрутить по светодиоду и созерцать :)

struct dataexchange_t pdata = {0, 0, 0};

HIDLibrary <dataexchange_t> hid; // создаем экземпляр класса с типом нашей структуры

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
   : TForm(Owner)
{
}
//---------------------------------------------------------------------------

int connect()  // этой функцией будем подключаться к устройству
{
   int i, n, res=0;
   string exampleDeviceName = "";

   exampleDeviceName += vendorName;
   exampleDeviceName += " ";
   exampleDeviceName += productName;

   n = hid.EnumerateHIDDevices(); // узнаем все Hid устройства vid_16c0&pid_05df
                                  // vid и pid указаны в hidlibrary.h константой idstring

   for (i=0; i<n; i++)            // ищем среди них наше
   {
      hid.Connect(i);

      // GetConnectedDeviceName() возвращает string,
      // где через пробел указаны vendor и product Name.
      // Сравниваем, если совпало - значить устройство наше
      if ( hid.GetConnectedDeviceName() == exampleDeviceName )
      {
         res = 1;
         break;
      }
   }
   return res;
}
//---------------------------------------------------------------------------

// Кнопка "Принять данные"
void __fastcall TForm1::Button1Click(TObject *Sender)
{
   if ( 1 == connect() )
   {
      hid.ReceiveData(&pdata);

      if (pdata.b1)
         CheckBox1->Checked = true;
      else
         CheckBox1->Checked = false;

      if (pdata.b2)
         CheckBox2->Checked = true;
      else
         CheckBox2->Checked = false;

      if (pdata.b3)
         CheckBox3->Checked = true;
      else
         CheckBox3->Checked = false;
   }
   else
   {
      AnsiString s = "";
      s += vendorName;
      s += " ";
      s += productName;
      s += " не подключено.";
      ShowMessage(s);
   }
}
//---------------------------------------------------------------------------

// Кнопка "Отправить данные"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
   if ( 1 == connect() )
   {
      if (CheckBox1->Checked)
         pdata.b1 = 1;
      else
         pdata.b1 = 0;

      if (CheckBox2->Checked)
         pdata.b2 = 1;
      else
         pdata.b2 = 0;

      if (CheckBox3->Checked)
         pdata.b3 = 1;
      else
         pdata.b3 = 0;

      hid.SendData(&pdata);
   }
   else
   {
      AnsiString s = "";
      s += vendorName;
      s += " ";
      s += productName;
      s += " не подключено.";
      ShowMessage(s);
   }
}
//---------------------------------------------------------------------------

