import 'dart:convert';

import 'package:dalgeurak_widget_package/services/shared_preference.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';

class DalgeurakStudentListAPI {
  DalgeurakService _dalgeurakService = DalgeurakService();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();
  DateTime nowTime = DateTime.now();

  getStudentList(bool isMust) async {
    String? stringData = SharedPreference().getStudentList();
    int weekFirstDay = (nowTime.day - (nowTime.weekday - 1));

    getStudentListInDimigoin() async {
      Map data = await _dalgeurakService.getAllStudentListInDimigoin();

      if (data['success']) {
        SharedPreference().saveStudentList({"studentList": data['content'], "weekFirstDay":  _dalgeurakService.getCorrectDate(weekFirstDay)['day']});
        return data['content'];
      } else {
        _dalgeurakToast.show(data['content']);
      }
    }


    if (isMust || stringData == null || (json.decode(stringData))["weekFirstDay"] != _dalgeurakService.getCorrectDate(weekFirstDay)['day']) {
      return (await getStudentListInDimigoin());
    } else {
      List originalData = (json.decode(stringData))['studentList'];
      List formattingData = [];
      originalData.forEach((element) => formattingData.add(DimigoinUser.fromJson(element)));

      //2.0.2 버전에서 학생 데이터가 3중 중첩되었던 적이 있어, 중첩된 데이터가 캐시로 등록되었을 경우에는 새 데이터로 인터넷에서 불러오는 코드입니다.
      if (formattingData.length > 1000) { return (await getStudentListInDimigoin()); }

      return formattingData;
    }
  }
}