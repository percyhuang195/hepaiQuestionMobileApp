package com.example.hepai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        var channel = "com.example.hepai/channel";
        var sharedPreferences = getSharedPreferences("appData", MODE_PRIVATE)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler { call, result ->
            if (call.method == "fetchMainData"){
                var dateRecordData = sharedPreferences.getString("dateRecordData","")
                var questionRecordData = sharedPreferences.getString("questionRecordData","")
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).invokeMethod("dateRcordData",dateRecordData)
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
