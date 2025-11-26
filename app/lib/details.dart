import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/question.dart';

import 'dataClass.dart';
import 'functionList.dart';
import 'home.dart';

class detailsPage extends StatefulWidget {
  const detailsPage({super.key, required this.questionID});

  final int questionID;

  @override
  State<detailsPage> createState() => _detailsPageState(questionID: questionID);
}

class _detailsPageState extends State<detailsPage> {

  _detailsPageState({required this.questionID});
  final int questionID; //傳入的問題ID(非JSON資料中的ID)

  var answerList = ["英國的搖滾樂團","美國的 Hip-Hop 歌手","蒙古的民歌團","阿根廷的探戈舞團"]; //問題的選項清單
  var answer = 1; // 問題位於清單中的位置
  var question = "下列譜例選自披頭四(The Beatles)的歌曲 Hello, Goodbye 曲首的片段,請問披頭四是"; //問題
  var details = "這是一份詳解"; //詳解內容
  var currentQuestion = 0; // 現在的問題ID(稍後將修改為傳入的問題ID)
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
    // 設定傳入ID做為顯示題目資料用
    currentQuestion = questionID;
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
    parseData();
    // 呼叫解析題庫問題資料的函式
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>homePage()));
                },
                icon: Icon(Icons.arrow_back)
            ),
            Text("HePai - 問題詳解")
          ],
        ),
      ),
      body:SingleChildScrollView(
        child: Column(
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
                Text("題目：",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(question,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
            ),
            Visibility(
                visible: dataList[currentQuestion].haveImage,
                child: Image.asset(
                    dataList[currentQuestion].image
                )
            ),
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
              height: 20,
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
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>questionPage(questionID: -1)));
                setState(() {});
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(149, 153, 242, 1),
                  ),
                  child: Center(
                    child: Text(
                      "繼續作答->",
                      style:TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  )
              ),
            ),
            Container(
              width: 50,
              height: 50,
            )
          ],
        ),
      )
    );
  }
}
