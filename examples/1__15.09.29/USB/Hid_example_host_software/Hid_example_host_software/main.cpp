//---------------------------------------------------------------------------
#define  uchar  unsigned char

#include <vcl.h>
#pragma hdrstop
#include "main.h"

#include "hidlibrary.h" // ���������� ��� ������ � Hid ������������


#include "../Hid_example_firmware/usbconfig.h"  // ����� ����� ���� � usbconfig.h
char  vendorName[]  = {USB_CFG_VENDOR_NAME, 0}; // ��� ���� ��� �� ����� ���
char  productName[] = {USB_CFG_DEVICE_NAME, 0}; // ���������� ���� ����������


struct dataexchange_t		// �������� ��������� ��� �������� ������
{
   uchar b1;        // � ����� ��� ������� �������� ��������� �� 3 �����.
   uchar b2;        // �� ������ ���� �������� ���� �� PORTB. ������� ���
   uchar b3;        // �� ����������� (����� �� 3 ���� �����).
};                  // �� � ����� ������������ � ����� ���.
                    // ��� ����������� ���������� �� ���������� � ��������� :)

struct dataexchange_t pdata = {0, 0, 0};

HIDLibrary <dataexchange_t> hid; // ������� ��������� ������ � ����� ����� ���������

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

int connect()  // ���� �������� ����� ������������ � ����������
{
   int i, n, res=0;
   string exampleDeviceName = "";

   exampleDeviceName += vendorName;
   exampleDeviceName += " ";
   exampleDeviceName += productName;

   n = hid.EnumerateHIDDevices(); // ������ ��� Hid ���������� vid_16c0&pid_05df
                                  // vid � pid ������� � hidlibrary.h ���������� idstring

   for (i=0; i<n; i++)            // ���� ����� ��� ����
   {
      hid.Connect(i);

      // GetConnectedDeviceName() ���������� string,
      // ��� ����� ������ ������� vendor � product Name.
      // ����������, ���� ������� - ������� ���������� ����
      if ( hid.GetConnectedDeviceName() == exampleDeviceName )
      {
         res = 1;
         break;
      }
   }
   return res;
}
//---------------------------------------------------------------------------

// ������ "������� ������"
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
      s += " �� ����������.";
      ShowMessage(s);
   }
}
//---------------------------------------------------------------------------

// ������ "��������� ������"
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
      s += " �� ����������.";
      ShowMessage(s);
   }
}
//---------------------------------------------------------------------------

