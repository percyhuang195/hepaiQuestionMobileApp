import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/dailyGraph.dart';
import 'package:hepai/dataClass.dart';
import 'package:hepai/question.dart';
import 'package:hepai/questionList.dart';

import 'functionList.dart';
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var todayAnswers = 0;   // 今日回答的問題(可重複)
  var totalAnswers = 0;   // 所有已經回答的問題(可重複)
  var answerQuestion = 0;   // 所有已經回答的問題(不重複)
  var totalQuestion = 18;   // 題庫中的所有問題數量(不重複)
  List<questionRecordData> questionRecordDataList = []; // 從PF(本地存儲空間)中抓到的問題回答紀錄
  var todayDate = DateTime.now().toString().substring(0,10); //今日日期(YYYY-MM-dd)
  List<questionData> dataList = []; // 題庫中的所有問題
  List isQuestionAnswerList = []; // 題庫中所有問題的回答狀態

  // 解析題庫問題資料，並整理畫面資訊
  Future<void> parseData() async{
    dataList = await parseJsonQuestion();
    // 初始化已答題的題數資料
    for (int x = 0; x < dataList.length; x++){
      isQuestionAnswerList.add(false);
    }
    for (int x = 0; x < questionRecordDataList.length; x++){
      // 計算當天/總計回答過的題目數量(可重複)
      if (questionRecordDataList[x].answerTime.substring(0,10) == todayDate){
        todayAnswers += 1;
      }
      totalAnswers += 1;
      // 計算答題記錄中，不重複且已回答的題目
      for (int y = 0; y < dataList.length; y++){
        if (questionRecordDataList[x].questionID == dataList[y].id){
          isQuestionAnswerList[y] = true;
        }
      }
    }
    // 依據剛才的結果，統計所有已回答的題目數量
    for (int x = 0; x < isQuestionAnswerList.length;x++){
      if (isQuestionAnswerList[x] == true){
        answerQuestion += 1;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 原生溝通通道訊息接收
    MethodChannel(channel).setMethodCallHandler((call) async{
      if (call.method == "questionRecordData"){ // 當Android端回傳答題紀錄資料
        List tempList = await jsonDecode(call.arguments);
        questionRecordDataList = decodeQuestionRecordData(tempList);
        parseData();
      }
    });
    // 向Android端sharedPreferences請求獲取本地存儲資料
    MethodChannel(channel).invokeMethod("fetchQuestionRecordData");
  }

  // APP 畫面UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("HePai - 題庫整合系統"),
      ),
      body: Column(
        children: [
          Container(
            width: 20,
            height: 20,
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
              ),
              Text("使用者 您好"),
            ],
          ),
          Container(
            width: 20,
            height: 20,
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>dailyGraphPage()));
              setState(() {});
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                      ),
                      Text("今日作答題數",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                      ),
                      Text(todayAnswers.toString(),
                        style: TextStyle(
                            fontSize: 40
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                      ),
                      Text("總計作答題數",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                      ),
                      Text(totalAnswers.toString(),
                        style: TextStyle(
                            fontSize: 40
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>questionListPage()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Text("題庫解鎖進度",
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 15,
                        color: Color.fromRGBO(200, 200, 200, 1),
                      ),
                      Positioned(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6 * (answerQuestion / totalQuestion),
                            height: 15,
                            color: Color.fromRGBO(149, 153, 242, 1),
                          )
                      )
                    ],
                  ),
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Text(answerQuestion.toString() + " / " + totalQuestion.toString(),
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>questionPage(questionID: -1)));
              setState(() {});
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(149, 153, 242, 1),
                ),
                child: Center(
                  child: Text(
                    "開始刷題 ->",
                    style:TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
