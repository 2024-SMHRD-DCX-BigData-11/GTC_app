import 'package:dalgeurak_meal_application/pages/meal_cancel/page.dart';
import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:dalgeurak_widget_package/screens/multiple_student_choice.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TeacherMealCancel {
  showStudentChoicePage() {
    showSearch(context: Get.context!, delegate: _MealCancelStudentMultipleChoice());
  }
}

class _MealCancelStudentMultipleChoice extends MultipleStudentChoice {
  @override
  void Function()? nextBtnOnClick(List<DimigoinUser> selectStudentList) {
    return () => Get.toNamed(DalgeurakMealApplicationRoutes.MEALCANCEL, arguments: {"pageMode": MealCancelPageMode.application, "selectStudentList": selectStudentList});
  }

}