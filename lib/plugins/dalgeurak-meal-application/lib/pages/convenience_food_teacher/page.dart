import 'package:dalgeurak_meal_application/routes/routes.dart';
import 'package:dalgeurak_widget_package/screens/basic_student_search.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ConvenienceFoodTeacherPage extends BasicStudentSearch {
  @override
  void Function()? studentBtnOnClick(DimigoinUser selectStudent) {
    return () => SchedulerBinding.instance.addPostFrameCallback((_) async {
      Get.toNamed(DalgeurakMealApplicationRoutes.CONVENIENCEFOOD, arguments: {"studentUid": selectStudent.id!});
    });
  }

  @override
  String get studentListTileBtnLabel => "신청";
}