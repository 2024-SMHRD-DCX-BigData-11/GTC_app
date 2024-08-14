import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:jiffy/jiffy.dart';
import 'package:html/parser.dart' as htmlParser;

class MealInfo {
  final Dio _dio = Get.find<Dio>();
  DimigoinMeal _dimigoinMeal = DimigoinMeal();
  DalgeurakService _dalgeurakService = DalgeurakService();

  final String apiUrl = "https://scjeil.hs.jne.kr/scjeil_hs/ad/fm/foodmenu/selectFoodMenuView.do?mi=132931";
  DateTime nowTime = DateTime.now();

  getMealPlannerFromDimigoin() async => await _dimigoinMeal.getWeeklyMeal();

  Future<Map> getMealPlannerFromDimigoHomepage() async {
    preprocessingText(MealType mealType, String mealInfo) {
      if (mealInfo.contains("<")) {
        mealInfo = mealInfo.substring(0, mealInfo.indexOf("<"));
      }
      if (mealType == MealType.lunch && mealInfo.contains("석식")) {
        mealInfo = "급식 정보가 없습니다.";
      }

      return mealInfo
          .replaceAll("/", ", ")
          .replaceAll("&amp;amp;", ", ")
          .replaceAll("&amp;", ", ")
          .replaceAll("&lt;", "<")
          .replaceAll("&gt;", ">");
    }

    Map<String, Map<String, String>> result = {};

    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    for (int i = weekFirstDay; i < weekFirstDay + 7; i++) {
      int tempWeekDay = (i - weekFirstDay) + 1;
      Map correctDate = _dalgeurakService.getCorrectDate(i);

      try {
        Response response = await _dio.get(apiUrl, queryParameters: {
          "document_srl": await getMealPostNum(correctDate["month"], correctDate["day"])
        });

        var document = htmlParser.parse(response.data);

        // 조식, 중식, 석식 정보를 selector로 추출
        String breakfast = document.querySelector("#detailForm > div > table > tbody > tr:nth-child(1) > td:nth-child(${tempWeekDay + 1}) > div > p:nth-child(3)")?.text ?? "급식 정보가 없습니다.";
        String lunch = document.querySelector("#detailForm > div > table > tbody > tr:nth-child(2) > td:nth-child(${tempWeekDay + 1}) > div > p:nth-child(3)")?.text ?? "급식 정보가 없습니다.";
        String dinner = document.querySelector("#detailForm > div > table > tbody > tr:nth-child(3) > td:nth-child(${tempWeekDay + 1}) > div > p:nth-child(3)")?.text ?? "급식 정보가 없습니다.";

        result["$tempWeekDay"] = {
          "breakfast": preprocessingText(MealType.breakfast, breakfast),
          "lunch": preprocessingText(MealType.lunch, lunch),
          "dinner": preprocessingText(MealType.dinner, dinner),
        };
      } catch (e) {
        result["$tempWeekDay"] = {
          "breakfast": "급식 정보가 없습니다.",
          "lunch": "급식 정보가 없습니다.",
          "dinner": "급식 정보가 없습니다.",
        };
      }
    }

    result["weekFirstDay"] = _dalgeurakService.getCorrectDate(weekFirstDay)['day'];

    return result;
  }

  Future<String> getMealPostNum(int month, int day) async {
    Response response = await _dio.get(apiUrl, queryParameters: {"page": 1});

    String data = response.data.toString();
    int strIndex = data.indexOf("$month월 $day일 식단입니다");

    String postUrl = response.data.toString().substring(data.indexOf('https', strIndex - 125), strIndex - 2);

    return postUrl.substring(postUrl.indexOf("&document_srl=") + 14);
  }
}
