import 'package:dalgeurak_meal_application/models/meal_exception_kind.dart';
import 'package:dalgeurak_meal_application/pages/meal_exception/controller.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class MealExceptionTypeSelectPageController extends GetxController with StateMixin {
  Rx<PickerDateRange> selectDate = PickerDateRange(null, null).obs;
  TextEditingController reasonTextController = TextEditingController();

  RxMap<MealExceptionKind, bool> selectExceptionType = Map<MealExceptionKind, bool>.from({}).obs;
  List<MealExceptionKind> exceptionKindList = [].cast<MealExceptionKind>();
  RxMap<MealExceptionKind, String> exceptionKindRemainAmount = Map<MealExceptionKind, String>.from({}).obs;

  DalgeurakService _dalgeurakService = DalgeurakService();
  DalgeurakToast _dalgeurakToast = DalgeurakToast();


  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();

    for (int weekDay=1; weekDay<=5; weekDay++) {
      for (MealType mealType in [MealType.lunch, MealType.dinner]) {
        MealExceptionKind exceptionKind = MealExceptionKind(weekDay: weekDay, mealType: mealType, exceptionType: MealExceptionType.first);
        selectExceptionType.addAll({exceptionKind: false});
        exceptionKindList.add(exceptionKind);
        exceptionKindRemainAmount.addAll({exceptionKind: "-"});

        exceptionKind = MealExceptionKind(weekDay: weekDay, mealType: mealType, exceptionType: MealExceptionType.last);
        selectExceptionType.addAll({exceptionKind: false});
        exceptionKindList.add(exceptionKind);
        exceptionKindRemainAmount.addAll({exceptionKind: "-"});
      }
    }

    getRemainStudentAmount();
  }

  getRemainStudentAmount() async {
    Map apiResult = await _dalgeurakService.getRemainMealExceptionStudentAmount();

    if (!apiResult['success']) { _dalgeurakToast.show("선/후밥 남은 인원 불러오기에 실패하였습니다.");  return; }

    Map remainAmountData = apiResult['content'];

    exceptionKindList.forEach((element) {
      String remainAmount = (remainAmountData[element.weekDay!.convertWeekDayEngStr][element.mealType!.convertEngStr][element.exceptionType!.convertStr] as int).toString();
      exceptionKindRemainAmount.update(element, (value) => remainAmount);
    });
  }

  selectMealExceptionSelectType(MealExceptionKind exceptionKind) async {
    int exceptionIndex = exceptionKindList.indexOf(exceptionKind);
    late int otherExceptionIndex;
    if (exceptionIndex % 2 == 0) { //선밥일경우
      otherExceptionIndex = exceptionIndex + 1;
    } else {
      otherExceptionIndex = exceptionIndex - 1;
    }

    if (selectExceptionType[exceptionKindList[otherExceptionIndex]]!) { //같은 날 같은 시간대의 다른 선밥이 활성화 되있을 경우
      selectExceptionType[exceptionKindList[otherExceptionIndex]] = false;
    }

    selectExceptionType.update(exceptionKind, (value) => !(selectExceptionType[exceptionKind])!);
  }

  getSelectMealExceptionKind() {
    List<MealExceptionKind> result = [].cast<MealExceptionKind>();

    selectExceptionType.forEach((key, value) {
      if (value) {
        result.add(key);
      }
    });

    return result;
  }
}
