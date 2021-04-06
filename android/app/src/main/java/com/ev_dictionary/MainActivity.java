package com.ev_dictionary;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.annotation.TargetApi;
import android.os.Build;
import android.text.Html;
import android.text.Spanned;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.flutter.dev/html";

  @TargetApi(Build.VERSION_CODES.N)
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
      super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
              (call, result) -> {
                if (call.method.equals("getHtml")) {
                    String text = call.argument("text");

                    Spanned html = Html.fromHtml(text, Html.FROM_HTML_MODE_LEGACY);
                    result.success(html.toString());
                }
              }
            );
  }
}