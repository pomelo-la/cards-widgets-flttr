package com.example.my_app_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class MainActivity: FlutterActivity() {

    private val channel = "com.example.app/message"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            //Call on the main thread
            call, result ->
            result(getKotlinMessage())
        }
    }

    private fun getKotlinMessage(): String {
        return "Coming from android side"
    }
}
