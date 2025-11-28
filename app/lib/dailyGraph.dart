import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/dataClass.dart';

import 'functionList.dart';

class dailyGraphPage extends StatefulWidget {
  const dailyGraphPage({super.key});

  @override
  State<dailyGraphPage> createState() => _dailyGraphPageState();
}

class _dailyGraphPageState extends State<dailyGraphPage> {
  
  List<dateRecordData> displayDataList = [];
  List<questionRecordData> questionRecordDataList = []; // 從PF(本地存儲空間)中抓到的問題回答紀錄
  var totalAnswers = 0;   // 所有已經回答的問題(可重複)
  var todayAnswers = 0;   // 今日回答的問題(可重複)
  var times = 0.0;
  var todayDate = DateTime.now().toString().substring(0,10); //今日日期(YYYY-MM-dd)

  // 整理畫面資訊(顯示圖表)
  Future<void> parseData() async{
    for (int x = 0; x < questionRecordDataList.length; x++){
      // 計算當天/總計回答過的題目數量(可重複)
      if (questionRecordDataList[x].answerTime.substring(0,10) == todayDate){
        todayAnswers += 1;
      }
      if (displayDataList.isEmpty){
        displayDataList.add(dateRecordData(date: questionRecordDataList[x].answerTime.substring(0,10), answerCount: 1));
      }else{
        for (int a = 0; a < displayDataList.length; a++){
          if (questionRecordDataList[x].answerTime.substring(0,10) == displayDataList[a].date){
            displayDataList[a].answerCount += 1;
          }else {
            displayDataList.add(dateRecordData(date: questionRecordDataList[x].answerTime.substring(0,10), answerCount: 1));
          }
        }
      }
      totalAnswers += 1;
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
    Future.delayed(Duration(milliseconds: 500),(){
      var maxValue = 0;
      for (int x = 0; x < displayDataList.length; x++){
        if (maxValue < displayDataList[x].answerCount){
          maxValue = displayDataList[x].answerCount;
        }
      }
      times = 350 / maxValue;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("HePai - 統計圖表"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 50,
              height: 20,
            ),
            Container(
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
            Container(
              width: 20,
              height: 20,
            ),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child:SizedBox(
                    child: Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                        ),
                        Text("每日刷題記錄"),
                        Container(
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 420,
                          child: ListView.builder(
                              itemCount: displayDataList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context,index){
                                return Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 10,
                                        ),
                                        Spacer(),
                                        Text(displayDataList[index].answerCount.toString()),
                                        Container(
                                          width: 20,
                                          height: 5,
                                        ),
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 1000),
                                          curve: Curves.linear,
                                          width: 40,
                                          height: displayDataList[index].answerCount * times,
                                          color: Color.fromRGBO(149, 153, 242, 1),
                                        ),
                                        Container(
                                          width: 10,
                                          height: 10,
                                        ),
                                        Text(displayDataList[index].date.substring(5,10))
                                      ],
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  )
              ),
            ),
            Container(
              width: 50,
              height: 50,
            ),
          ],
        ),
      )
    );
  }
}
