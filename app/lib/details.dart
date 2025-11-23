import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/main.dart';

import 'dataClass.dart';

class detailsPage extends StatefulWidget {
  const detailsPage({super.key, required this.data});

  final int data;

  @override
  State<detailsPage> createState() => _detailsPageState(data: data);
}

class _detailsPageState extends State<detailsPage> {

  _detailsPageState({required this.data});
  final int data;

  var answerList = ["英國的搖滾樂團","美國的 Hip-Hop 歌手","蒙古的民歌團","阿根廷的探戈舞團"];
  var answer = 0;
  var question = "下列譜例選自披頭四(The Beatles)的歌曲 Hello, Goodbye 曲首的片段,請問披頭四是";
  var details = "這是一份詳解";
  List<questionData> dataList = [];
  get currentQuestion => data;

  Future<void> dataParse() async {
    final String jsonString = await rootBundle.loadString("assets/hepai.json");
    List tempList = jsonDecode(jsonString)["questionList"];
    for (int x = 0; x < tempList.length; x++) {
      questionData tempQuestion = questionData(
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
    dataParse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("HePai-作答區"),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>MyHomePage()));
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
