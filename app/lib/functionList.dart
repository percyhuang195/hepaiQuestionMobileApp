import 'dart:convert';

import 'package:flutter/services.dart';

import 'dataClass.dart';

// 解析JSON題目資料，並回傳
Future<List<questionData>> parseJsonQuestion() async{
  List<questionData> dataList = [];
  final String jsonString = await rootBundle.loadString("assets/hepai.json");
  List tempList = jsonDecode(jsonString)["questionList"];
  for (int x = 0; x < tempList.length; x++){
    questionData tempQuestion = questionData(
        id: tempList[x]["id"],
        haveImage: tempList[x]["haveImage"],
        image: tempList[x]["image"],
        question: tempList[x]["question"],
        selection1: tempList[x]["selection1"],
        selection2: tempList[x]["selection2"],
        selection3: tempList[x]["selection3"],
        selection4: tempList[x]["selection4"],
        answer: tempList[x]["answer"],
        keypoint: tempList[x]["keypoint"],
        details: tempList[x]["details"]
    );
    dataList.add(tempQuestion);
  }
  return dataList;
}
