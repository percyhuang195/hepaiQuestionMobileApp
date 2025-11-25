// 原生溝通通道，寫在這裡讓所有檔案都可以讀取，就不用每個檔案都宣告一次變數
var channel = "com.example.hepai/channel";

// 問題資料Data Class
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

// 依據日期分割的答題資料Data Class
class dateRecordData{
  String date = "";
  int answerCount = 0;

  dateRecordData({
    required this.date,
    required this.answerCount,
  });
}
//
// List<dateRecordData> decodeDateRecordData(List dataList){
//   List<dateRecordData> resultList = [];
//   for (int x = 0; x < dataList.length; x++){
//     resultList.add(
//       dateRecordData(date: dataList[x]["date"], answerCount: dataList[x]["answerCount"])
//     );
//   }
//   return resultList;
// }
//
// List encodeDateRecordData(List<dateRecordData> dataList){
//   List resultList = [];
//   for (int x = 0; x < dataList.length; x++){
//     var map = Map();
//     map["date"] = dataList[x].date;
//     map["answerCount"] = dataList[x].answerCount;
//     resultList.add(map);
//   }
//   return resultList;
// }

// 每個問題的答題記錄Data Class
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

// 對答題記錄進行JSON編碼
List<questionRecordData> decodeQuestionRecordData(List dataList){
  List<questionRecordData> resultList = [];
  for (int x = 0; x < dataList.length; x++){
    resultList.add(
        questionRecordData(
          answerTime: dataList[x]["answerTime"],
          questionID: dataList[x]["questionID"],
          selection: dataList[x]["selection"]
        )
    );
  }
  return resultList;
}

// 對答題記錄進行JSON解碼
List encodeQuestionRecordData(List<questionRecordData> dataList){
  List resultList = [];
  for (int x = 0; x < dataList.length; x++){
    var map = Map();
    map["answerTime"] = dataList[x].answerTime;
    map["questionID"] = dataList[x].questionID;
    map["selection"] = dataList[x].selection;
    resultList.add(map);
  }
  return resultList;
}
