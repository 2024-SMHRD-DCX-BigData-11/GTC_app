import 'package:dalgeurak_meal_application/widgets/date_select_container.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/checkbox.dart';
import 'package:dalgeurak_widget_package/widgets/reason_textfield.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../themes/text_theme.dart';
import 'controller.dart';

enum MealCancelPageMode {
  application,
  changeStatus
}

extension MealCancelPageModeExtension on MealCancelPageMode {
  String get convertBtnStr {
    switch (this) {
      case MealCancelPageMode.application: return "신청";
      case MealCancelPageMode.changeStatus: return "수락";
      default: return "";
    }
  }
}


class MealCancelPage extends GetView<MealCancelPageController> {
  const MealCancelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MealCancelPageMode pageMode = Get.arguments['pageMode'];
    late DalgeurakMealCancel mealCancelContent;
    if (pageMode == MealCancelPageMode.changeStatus) {
      mealCancelContent = Get.arguments['cancelContent'];
      print(mealCancelContent.toJson());

      controller.reasonTextController.text = mealCancelContent.reason!;
      controller.selectDate.value = PickerDateRange(mealCancelContent.durationList!['start'], mealCancelContent.durationList!['end']);
      controller.selectMeal.value = controller.selectMeal.map((key, value) => MapEntry(key, mealCancelContent.mealTypeList?.contains(key))).cast<MealType, bool>();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dalgeurakGrayOne,
      body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: Get.height * 0.115,
                left: Get.width * 0.1,
                child: WindowTitle(
                  subTitle: "급식 취소",
                  title: "신청",
                ),
              ),
              Positioned(
                top: Get.height * 0.15,
                right: Get.width * 0.1,
                child: GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset("assets/images/close.svg", package: "dalgeurak_widget_package", width: 18, color: Colors.black))
              ),
              Positioned(
                top: Get.height * 0.24,
                child: Container(
                  width: 350,
                  height: Get.height * 0.52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("변경 사유", style: containerMenu),
                          SizedBox(height: 18),
                          ReasonTextField(hintText: "변경 사유를 입력해주세요.", textController: controller.reasonTextController, isBig: false, isEnable: (pageMode == MealCancelPageMode.application)),
                          SizedBox(height: 32),
                          Text("변경 기간", style: containerMenu),
                          SizedBox(height: 18),
                          DateSelectContainer(isEnable: (pageMode == MealCancelPageMode.application), selectDate: controller.selectDate),
                          SizedBox(height: 32),
                          Text("변경 신청 급식", style: containerMenu),
                          SizedBox(height: 18),
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: (pageMode == MealCancelPageMode.application ? () => controller.selectMeal[MealType.breakfast] = !controller.selectMeal[MealType.breakfast] : (){}),
                                  child: DalgeurakCheckBox(content: "조식", isOn: controller.selectMeal[MealType.breakfast], checkBoxType: DalgeurakCheckBoxType.window)
                              ),
                              GestureDetector(
                                  onTap: (pageMode == MealCancelPageMode.application ? () => controller.selectMeal[MealType.lunch] = !controller.selectMeal[MealType.lunch] : (){}),
                                  child: DalgeurakCheckBox(content: "중식", isOn: controller.selectMeal[MealType.lunch], checkBoxType: DalgeurakCheckBoxType.window)
                              ),
                              GestureDetector(
                                  onTap: (pageMode == MealCancelPageMode.application ? () => controller.selectMeal[MealType.dinner] = !controller.selectMeal[MealType.dinner] : (){}),
                                  child: DalgeurakCheckBox(content: "석식", isOn: controller.selectMeal[MealType.dinner], checkBoxType: DalgeurakCheckBoxType.window)
                              ),

                            ],
                          ))
                        ],
                      )
                  ),
                )
              ),
              Positioned(
                bottom: Get.height * 0.12,
                child: Row(
                  children: [
                    (
                      pageMode == MealCancelPageMode.changeStatus ?
                      GestureDetector(
                          onTap: () => controller.changeMealCancelStatus(mealCancelContent, false),
                          child: BlueButton(content: "거절", isLong: false, isSmall: false, isFill: false, isDisable: false)
                      ) : SizedBox()
                    ),
                    SizedBox(width: (pageMode == MealCancelPageMode.changeStatus ? 16 : 0)),
                    GestureDetector(
                        onTap: () {
                          if (pageMode == MealCancelPageMode.application) {
                            controller.applicationMealCancel();
                          } else if (pageMode == MealCancelPageMode.changeStatus) {
                            controller.changeMealCancelStatus(mealCancelContent, true);
                          }
                        },
                        child: BlueButton(content: pageMode.convertBtnStr, isLong: false, isSmall: false, isFill: true, isDisable: false)
                    )
                  ],
                )
              )
            ],
          )
      ),
    );
  }
}
