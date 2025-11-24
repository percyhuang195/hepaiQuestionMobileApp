import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dataClass.dart';
import 'details.dart';

class questionPage extends StatefulWidget {
  const questionPage({super.key, required this.questionID});
  final int questionID;

  @override
  State<questionPage> createState() => _questionPageState(questionID: questionID);
}

class _questionPageState extends State<questionPage> {
  _questionPageState({required this.questionID});
  final int questionID;

  var answerList = ["英國的搖滾樂團","美國的 Hip-Hop 歌手","蒙古的民歌團","阿根廷的探戈舞團"];
  var answer = 1;
  var question = "下列譜例選自披頭四(The Beatles)的歌曲 Hello, Goodbye 曲首的片段,請問披頭四是";
  var answerStatus = false;
  var currect = false;
  var currentQuestion = 0;
  List<questionData> dataList = [
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

  Future<void> dataParse() async{
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
    if (questionID != -1){
      currentQuestion = questionID;
    }else{
      currentQuestion = Random().nextInt(dataList.length - 1) + 1;
    }
    answerList = [
      dataList[currentQuestion].selection1,
      dataList[currentQuestion].selection2,
      dataList[currentQuestion].selection3,
      dataList[currentQuestion].selection4,
    ];
    answer = dataList[currentQuestion].answer - 1;
    question = dataList[currentQuestion].question;
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
          title: Text("HePai - 題庫整合系統"),
        ),
        body: Column(
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
            Visibility(
                visible: !answerStatus,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  child: ListView.builder(
                      itemCount: answerList.length,
                      itemBuilder: (context,index){
                        return Column(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: (){
                                if (index == answer){
                                  currect = true;
                                }
                                answerStatus = true;
                                setState(() {});
                              },
                              child: Container(
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
                                      width: MediaQuery.of(context).size.width * 0.9 - 100,
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
                            ),
                            Container(
                              width: 5,
                              height: 5,
                            ),
                          ],
                        );
                      }),
                )
            ),
            Visibility(
                visible: answerStatus,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
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
                                    (answer + 1).toString(),
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
                              width: MediaQuery.of(context).size.width * 0.9 - 100,
                              child: Text(
                                answerList[answer],
                                style:TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 50,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>detailsPage(questionID: currentQuestion,)));
                            setState(() {});
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(149, 153, 242, 1),
                              ),
                              child:Center(
                                child: Text(
                                  "查看詳解",
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                              )
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>questionPage(questionID :-1)));
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
                          width: MediaQuery.of(context).size.width * 0.05,
                          height: 20,
                        ),
                      ],
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}
