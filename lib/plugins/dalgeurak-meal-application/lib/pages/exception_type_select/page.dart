import 'package:dalgeurak_meal_application/models/meal_exception_kind.dart';
import 'package:dalgeurak_meal_application/pages/exception_type_select/widgets/exception_type_container.dart';
import 'package:dalgeurak_meal_application/pages/meal_exception/controller.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';
import 'controller.dart';

class MealExceptionTypeSelectPage extends GetView<MealExceptionTypeSelectPageController> {
  const MealExceptionTypeSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: () => Get.back(result: "back"), child: Icon(Icons.arrow_back_ios_rounded, size: 26, color: dalgeurakGrayFour)),
                    const SizedBox(width: 14),
                    const Text("신청할 시간을 모두 선택해주세요", style: exceptionTypeSelectPage_title),
                    const SizedBox(width: 56),
                    GestureDetector(
                      onTap: () => Get.back(result: controller.getSelectMealExceptionKind()),
                      child: Container(
                        width: 55,
                        height: 33,
                        decoration: BoxDecoration(
                            color: dalgeurakYellowOne,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(child: Text("확인", style: studentSearchListTileBtn.copyWith(color: Colors.white))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.exceptionKindList.length,
                    itemBuilder: (context, index) {
                      if (index % 2 != 0) { return SizedBox(); }


                      MealExceptionKind firstExceptionKind = controller.exceptionKindList[index];
                      MealExceptionKind lastExceptionKind = controller.exceptionKindList[index+1];

                      return Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () => controller.selectMealExceptionSelectType(firstExceptionKind),
                              child: ExceptionTypeContainer(
                                  weekday: firstExceptionKind.weekDay!.convertWeekDayKorStr,
                                  mealType: firstExceptionKind.mealType!,
                                  exceptionType: firstExceptionKind.exceptionType!,
                                  isEnable: controller.selectExceptionType[firstExceptionKind]!,
                                  remainPeople: controller.exceptionKindRemainAmount[firstExceptionKind],
                              )
                          ),
                          GestureDetector(
                              onTap: () => controller.selectMealExceptionSelectType(lastExceptionKind),
                              child: ExceptionTypeContainer(
                                  weekday: lastExceptionKind.weekDay!.convertWeekDayKorStr,
                                  mealType: lastExceptionKind.mealType!,
                                  exceptionType: lastExceptionKind.exceptionType!,
                                  isEnable: controller.selectExceptionType[lastExceptionKind]!,
                                remainPeople: controller.exceptionKindRemainAmount[lastExceptionKind],
                              )
                          )
                        ],
                      ));
                    },
                  ),
                )
                //getExceptionTypeWidgets()
              ],
            )
        ),
      ),
    );
  }
}