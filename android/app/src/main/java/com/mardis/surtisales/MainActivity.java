package com.mardis.surtisales;

import android.widget.Toast;
import java.util.*;

import android.content.Intent;
import android.os.Bundle;

import java.nio.ByteBuffer;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String sharedText;
  private String sharedTextTest;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    Map<String,String> resultMap = new HashMap<String,String>();
    resultMap.put("ptindice",getIntent().getStringExtra("ptindice"));
    resultMap.put("Email ",getIntent().getStringExtra("Email "));
    resultMap.put("FirstName",getIntent().getStringExtra("FirstName"));
    resultMap.put("LastName",getIntent().getStringExtra("LastName"));
    resultMap.put("BusinessName",getIntent().getStringExtra("BusinessName"));
    resultMap.put("RUC",getIntent().getStringExtra("RUC"));
    resultMap.put("PhoneNumber",getIntent().getStringExtra("PhoneNumber"));
    resultMap.put("Referencia",getIntent().getStringExtra("Referencia"));
    resultMap.put("ProvinceId ",getIntent().getStringExtra("ProvinceId "));
    resultMap.put("City ",getIntent().getStringExtra("City "));
    resultMap.put("Address1 ",getIntent().getStringExtra("Address1 "));
    resultMap.put("Latitud ",getIntent().getStringExtra("Latitud "));
    resultMap.put("Longitud ",getIntent().getStringExtra("Longitud "));


    Toast.makeText(getApplication(),
            resultMap.get("ptindice"), Toast.LENGTH_SHORT).show();

    new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, MethodChannel.Result result) {

            result.success(resultMap);
            sharedText = null;
          }
        });
  }

  void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  }
}
