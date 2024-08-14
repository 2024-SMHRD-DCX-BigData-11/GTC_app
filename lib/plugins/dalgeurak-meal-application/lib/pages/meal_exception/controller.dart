import 'package:dalgeurak_meal_application/models/meal_exception_kind.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

extension WeekDayEnumExtension on int {
  String get convertWeekDayKorStr {
    switch (this) {
      case 1: return "월";
      case 2: return "화";
      case 3: return "수";
      case 4: return "목";
      case 5: return "금";
      case 6: return "토";
      case 7: return "일";
      default: return "";
    }
  }

  String get convertWeekDayEngStr {
    switch (this) {
      case 1: return "mon";
      case 2: return "tue";
      case 3: return "wed";
      case 4: return "thr";
      case 5: return "fri";
      case 6: return "sat";
      case 7: return "sun";
      default: return "";
    }
  }
}


class MealExceptionPageController extends GetxController with StateMixin {
  TextEditingController reasonTextController = TextEditingController();

  RxList<DimigoinUser> selectUserList = [].cast<DimigoinUser>().obs;
  RxList<MealExceptionKind> selectExceptionKindList = [].cast<MealExceptionKind>().obs;

  RxInt remainStudentAmount = (-1).obs;

  DalgeurakService _dalgeurakService = DalgeurakService();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();


  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  getSelectExceptionList() async {
    try {
      List<MealExceptionKind> selectExceptionList = await Get.toNamed(DalgeurakMealApplicationRoutes.MEALEXCEPTIONTYPESELECT);

      selectExceptionKindList.value = selectExceptionList;
    } catch (e) {} //선후밥 종류 선택 화면에서 뒤로가기를 눌렀을 경우
  }

  applicationMealException() async {
    if (selectExceptionKindList.isEmpty || reasonTextController.text.isEmpty) {
      _dalgeurakToast.show("설정되지 않은 칸을 모두 설정 후 다시 시도해주세요.");
      return;
    }
    bool isContainMe = false;
    selectUserList.forEach((element) {
      if (element.id! == DimigoinAccount().currentUser.id!) { isContainMe = true; }
    });
    if (selectUserList.isNotEmpty && !isContainMe) {
      selectUserList.add(DimigoinAccount().currentUser);
    }

    List<MealType> mealTypeList = [];
    List<String> dateList = [];
    List<MealExceptionType> exceptionList = [];
    selectExceptionKindList.forEach((element) {
      mealTypeList.add(element.mealType!);
      dateList.add(element.weekDay!.convertWeekDayEngStr);
      exceptionList.add(element.exceptionType!);
    });

    Map result = await _dalgeurakService.setUserMealException(
      mealTypeList,
      dateList,
      exceptionList,
      reasonTextController.text,
      selectUserList.map((element) => element.id!).cast<int>().toList(),
    );


    _dalgeurakToast.show("선/후밥 신청을 ${result['success'] ? "성공" : "실패"}하였습니다.${result['success'] ? "" : "\n사유: ${result['content']}"}");
    Get.back();
  }

  getRemainStudentAmount() async { //삭제 예정으로 디미고인 API 연동 임시 제거하였습니다.
    remainStudentAmount.value = -1;

    _dalgeurakToast.show("후밥 신청 가능 인원 수 불러오기에 실패하였습니다.");
  }
}
