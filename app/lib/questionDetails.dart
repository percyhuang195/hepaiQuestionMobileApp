import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/functionList.dart';
import 'package:hepai/home.dart';

import 'dataClass.dart';
import 'details.dart';

class questionDetailsPage extends StatefulWidget {
  const questionDetailsPage({super.key, required this.questionID});
  final int questionID;

  @override
  State<questionDetailsPage> createState() => _questionDetailsPageState(questionID: questionID);
}

class _questionDetailsPageState extends State<questionDetailsPage> {
  _questionDetailsPageState({required this.questionID});
  final int questionID; //傳入的問題ID(非JSON資料中的ID)

  var answerList = ["英國的搖滾樂團","美國的 Hip-Hop 歌手","蒙古的民歌團","阿根廷的探戈舞團"]; //問題的選項清單
  var answer = 1; // 問題位於清單中的位置
  var question = "下列譜例選自披頭四(The Beatles)的歌曲 Hello, Goodbye 曲首的片段,請問披頭四是"; //問題
  var currentQuestion = 0; // 現在的問題ID(稍後將修改為傳入的問題ID)
  var details = "這是一份詳解"; //詳解內容
  List<questionRecordData> questionRecordDataList = []; // 從PF(本地存儲空間)中抓到的問題回答紀錄
  var todayDate = DateTime.now().toString().substring(0,10); //今日日期(YYYY-MM-dd)
  List<questionData> dataList = [ // 題庫中的所有問題(先放假資料避免Range Error)
    questionData(
        id: "",
        haveImage: false,
        image: "",
        question: "",
        selection1: "",
        selection2: "",
        selection3: "",
        selection4: "",
        answer: 0,
        keypoint: "",
        details: ""
    )
  ];

  // 解析題庫問題資料，並整理畫面資訊
  Future<void> parseData() async{
    // 解析JSON題目資料
    dataList = await parseJsonQuestion();
    // 判斷是否傳入問題ID，若無則隨機選題
    if (questionID != -1){
      currentQuestion = questionID;
    }else{
      currentQuestion = Random().nextInt(dataList.length - 1);
    }
    // 設置題目資料(答案、選項、問題和詳解)
    answerList = [
      dataList[currentQuestion].selection1,
      dataList[currentQuestion].selection2,
      dataList[currentQuestion].selection3,
      dataList[currentQuestion].selection4,
    ];
    answer = dataList[currentQuestion].answer - 1;
    question = dataList[currentQuestion].question;
    details = dataList[currentQuestion].details;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 原生溝通通道訊息接收
    MethodChannel(channel).setMethodCallHandler((call) async{
      if (call.method == "questionRecordData"){
        questionRecordDataList = decodeQuestionRecordData(jsonDecode(call.arguments));
      }
      setState(() {});
    });
    // 向Android端sharedPreferences請求獲取本地存儲資料
    MethodChannel(channel).invokeMethod("fetchQuestionRecordData");
    // 呼叫解析題庫問題資料的函式
    parseData();
    setState(() {});
  }

  // APP 畫面UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("HePai - 題庫")
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 50,
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
                child:Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(dataList[currentQuestion].id,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(question,
                        style: TextStyle(
                            fontSize: 20
                        ),),
                    ),
                    Visibility(
                        visible: dataList[currentQuestion].haveImage,
                        child: Image.asset(
                            dataList[currentQuestion].image
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 320,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: answerList.length,
                    itemBuilder: (context,index){
                      return Column(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(149, 153, 242, 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: SizedBox(
                                      width: 37,
                                      height: 37,
                                      child: CircleAvatar(
                                        backgroundColor: Color.fromRGBO(149, 153, 242, 1),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9 - 120,
                                  child: Text(
                                    answerList[index],
                                    style:TextStyle(
                                        color: Colors.white,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 5,
                            height: 5,
                          ),
                        ],
                      );
                    }),
              ),
              Container(
                width: 20,
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Text("正確答案：",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Text(answerList[answer],
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ],
              ),
              Container(
                width: 20,
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                  ),
                  Text("詳解：",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(details,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
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
