import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hepai/details.dart';

import 'dataClass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var answerList = ["英國的搖滾樂團","美國的 Hip-Hop 歌手","蒙古的民歌團","阿根廷的探戈舞團"];
  var answer = 0;
  var question = "下列譜例選自披頭四(The Beatles)的歌曲 Hello, Goodbye 曲首的片段,請問披頭四是";
  var answerStatus = false;
  var currect = false;
  List<questionData> dataList = [];
  var currentQuestion = 0;

  Future<void> dataParse() async{
    final String jsonString = await rootBundle.loadString("assets/hepai.json");
    List tempList = jsonDecode(jsonString)["questionList"];
    for (int x = 0; x < tempList.length; x++){
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
    currentQuestion = Random().nextInt(dataList.length);
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
        title: Text("HePai-作答區"),
      ),
      body: Column(
        children: [
          Container(
            width: 50,
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 120,
            child: Text(question,
            style: TextStyle(
              fontSize: 20
            ),),
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
                              Text(
                                answerList[index],
                                style:TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),
                              )
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
                      Text(
                        answerList[answer],
                        style:TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                      )
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=>detailsPage(data: currentQuestion,)));
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
