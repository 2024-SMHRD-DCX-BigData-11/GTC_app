import 'package:dalgeurak_meal_application/widgets/date_select_container.dart';
import 'package:dalgeurak_widget_package/screens/multiple_student_choice.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/checkbox.dart';
import 'package:dalgeurak_widget_package/widgets/choice_user_container.dart';
import 'package:dalgeurak_widget_package/widgets/oneline_textfield.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../themes/text_theme.dart';
import '../exception_type_select/widgets/exception_type_container.dart';
import 'controller.dart';

class MealExceptionPage extends GetView<MealExceptionPageController> {
  const MealExceptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
          child: SafeArea(
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(width: Get.width, height: 64),
                          Positioned(
                            left: Get.width * 0.1,
                            child: WindowTitle(
                              subTitle: "선/후밥",
                              title: "신청",
                            ),
                          ),
                          Positioned(
                              right: Get.width * 0.1,
                              child: GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset("assets/images/close.svg", package: "dalgeurak_widget_package", width: 18, color: Colors.black))
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const SizedBox(width: 42),
                          Text("명단", style: containerMenu.copyWith(fontSize: 17)),
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => showSearch(context: Get.context!, delegate: _StudentMultipleChoice()),
                            child: Text("추가하기", style: exceptionPage_addPeople),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Obx(() => AnimatedSize(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeIn,
                        child: SizedBox(
                            width: 290,
                            height: controller.selectUserList.isNotEmpty ? 75 : 0,
                            child: ListView.builder(
                              itemCount: controller.selectUserList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return ChoiceUserContainer(
                                  choiceUser: controller.selectUserList[index],
                                  choiceUserList: controller.selectUserList,
                                  onClick: () => controller.selectUserList.removeAt(index),
                                  isSearchPage: false,
                                );
                              },
                            )
                        ),
                      )),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 42),
                          Text("* 신청 목록", style: containerMenu.copyWith(fontSize: 17)),
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => controller.getSelectExceptionList(),
                            child: Text("설정하기", style: exceptionPage_addPeople),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(width: 28),
                          Obx(() {
                            int exceptionListAmount = controller.selectExceptionKindList.length;

                            return SizedBox(
                              width: 300,
                              height: ((exceptionListAmount / 2).floor() * 80) + ((exceptionListAmount == 1) ? 70 : 0),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: exceptionListAmount,
                                itemBuilder: (context, index) {
                                  if (index % 2 != 0) { return SizedBox(); }

                                  if (index == (exceptionListAmount-1)) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ExceptionTypeContainer(
                                          weekday: controller.selectExceptionKindList[index].weekDay!.convertWeekDayKorStr,
                                          mealType: controller.selectExceptionKindList[index].mealType!,
                                          exceptionType: controller.selectExceptionKindList[index].exceptionType!,
                                          isEnable: false,
                                          isApplicationPage: true,
                                        ),
                                        const SizedBox(width: 120, height: 40)
                                      ],
                                    );

                                  }

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ExceptionTypeContainer(
                                        weekday: controller.selectExceptionKindList[index].weekDay!.convertWeekDayKorStr,
                                        mealType: controller.selectExceptionKindList[index].mealType!,
                                        exceptionType: controller.selectExceptionKindList[index].exceptionType!,
                                        isEnable: false,
                                        isApplicationPage: true,
                                      ),
                                      ExceptionTypeContainer(
                                        weekday: controller.selectExceptionKindList[index+1].weekDay!.convertWeekDayKorStr,
                                        mealType: controller.selectExceptionKindList[index+1].mealType!,
                                        exceptionType: controller.selectExceptionKindList[index+1].exceptionType!,
                                        isEnable: false,
                                        isApplicationPage: true,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 42),
                      Row(
                        children: [
                          const SizedBox(width: 42),
                          Text("* 상세 사유", style: containerMenu.copyWith(fontSize: 17)),
                        ],
                      ),
                      SizedBox(height: 16),
                      OneLineTextField(hintText: "상세사유를 입력해주세요.", textController: controller.reasonTextController, isEnable: true),
                      SizedBox(height: 24),
                      Text("별도로 앱에 신청 현황이 표시되지 않으니\n신청 전 스크린샷을 찍어두세요", style: exceptionPage_screenshot, textAlign: TextAlign.center),
                      SizedBox(height: 42),
                      GestureDetector(
                          onTap: () => controller.applicationMealException(),
                          child: BlueButton(content: "신청", isLong: false, isSmall: false, isFill: true, isDisable: false)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}

class _StudentMultipleChoice extends MultipleStudentChoice {
  @override
  void Function()? nextBtnOnClick(List<DimigoinUser> selectStudentList) {
    return () {
      Get.find<MealExceptionPageController>().selectUserList.value = selectStudentList;

      Get.back();
    };
  }

}
