var channel = "com.example.hepai/channel";

class questionData {
  String id = "";
  bool haveImage = false;
  String image = "";
  String question = "";
  String selection1 = "";
  String selection2 = "";
  String selection3 = "";
  String selection4 = "";
  int answer = 0;
  String keypoint = "";
  String details = "";

  questionData({
    required this.id,
    required this.haveImage,
    required this.image,
    required this.question,
    required this.selection1,
    required this.selection2,
    required this.selection3,
    required this.selection4,
    required this.answer,
    required this.keypoint,
    required this.details,
  });
}

class dateRecordData{
  String date = "";
  int answerCount = 0;

  dateRecordData({
    required this.date,
    required this.answerCount,
  });
}

List<dateRecordData> parseDateRecordData(List tempList){
  List<dateRecordData> resultList = [];
  for (int x = 0; x < tempList.length; x++){
    resultList.add(
      dateRecordData(date: tempList[x]["date"], answerCount: tempList[x]["answerCount"])
    );
  }
  return resultList;
}


class questionRecordData{
  String answerTime = "";
  String questionID = "";
  int selection = 0;

  questionRecordData({
    required this.answerTime,
    required this.questionID,
    required this.selection,
  });
}
