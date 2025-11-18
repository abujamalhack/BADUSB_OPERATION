@echo off
echo Building Android APK...
echo.

cd /d "C:\BADUSB_ANDROID_OPERATION\02_ANDROID_APP"

echo Make sure you have Android Studio installed!
echo This batch file assumes you have the project in Android Studio
echo.

echo Steps to build APK manually:
echo 1. Open Android Studio
echo 2. Open project: C:\BADUSB_ANDROID_OPERATION\02_ANDROID_APP
echo 3. Click: Build -> Build Bundle(s) / APK(s) -> Build APK(s)
echo 4. The APK will be in: app\build\outputs\apk\debug\app-debug.apk
echo 5. Rename it to: update_service.apk and upload to your server
echo.

pause
