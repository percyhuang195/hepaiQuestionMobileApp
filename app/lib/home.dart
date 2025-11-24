import 'package:flutter/material.dart';
import 'package:hepai/question.dart';
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var todayAnswers = 0;
  var totalAnswers = 0;
  var answerQuestion = 0;
  var totalQuestion = 18;

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
          Container(
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
          Container(
            width: 40,
            height: 40,
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>questionPage(questionID: -1)));
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
