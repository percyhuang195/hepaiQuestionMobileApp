import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/questionDetails.dart';

import 'dataClass.dart';
import 'functionList.dart';

class questionListPage extends StatefulWidget {
  const questionListPage({super.key});

  @override
  State<questionListPage> createState() => _questionListPageState();
}

class _questionListPageState extends State<questionListPage> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("HePai - 題庫")
      ),
      body: Column(
        children: [
          Container(
            width: 30,
            height: 30,
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
              ),
              IconButton(onPressed: (){

              }, icon: Icon(Icons.arrow_back,color: Colors.grey)),
              Spacer(),
              Text("112年",style: TextStyle(
                fontSize: 18
              ),),
              Spacer(),
              IconButton(onPressed: (){

              }, icon: Icon(Icons.arrow_forward,color: Colors.grey)),
              Container(
                width: 20,
                height: 20,
              ),
            ],
          ),
          Container(
            width: 20,
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: (dataList.length / 4).toInt() + 1,
              itemBuilder: (context,index){
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child:ListView.builder(
                      itemCount: dataList.length - index * 4 > 4 ? 4 : (dataList.length - index * 4) % 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index2){
                        var targetID = index * 4 + index2;
                        return GestureDetector(
                          onTap: (){
                            if (isQuestionAnswerList[targetID]){
                              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>questionDetailsPage(questionID: targetID)));
                            }else{
                              var message = SnackBar(content: Text("題目" + (targetID + 1).toString() + "還沒解鎖"));
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(message);
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Center(
                              child:Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(5),
                                    color: isQuestionAnswerList[targetID] ? Color.fromRGBO(149, 153, 242, 1) : Color.fromRGBO(200, 200, 200, 1)
                                ),
                                child: Center(
                                  child: Text((targetID + 1).toString(),style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                  ),),
                                ),
                              ),
                            ),
                          ),
                        );
                  }),
                );
            }),
          )
        ],
      ),
    );
  }
}
