package com.example.hepai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 原生溝通頻道
        var channel = "com.example.hepai/channel";
        // 本地存儲
        var sharedPreferences = getSharedPreferences("appData", MODE_PRIVATE)
        // 原生溝通訊息接收
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler { call, result ->
            if (call.method == "fetchDateRecordData"){
                var dateRecordData = sharedPreferences.getString("dateRecordData","")
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).invokeMethod("dateRecordData",dateRecordData)
                result.success("")
            }else if (call.method == "fetchQuestionRecordData"){
                var questionRecordData = sharedPreferences.getString("questionRecordData","")
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).invokeMethod("questionRecordData",questionRecordData)
                result.success("")
            }else if (call.method == "saveDateRecordData"){
                sharedPreferences.edit().putString("dateRecordData",call.arguments.toString()).apply()
                result.success("")
            }else if (call.method == "saveQuestionRecordData"){
                sharedPreferences.edit().putString("questionRecordData",call.arguments.toString()).apply()
                result.success("")
            }
        }
    }
}
