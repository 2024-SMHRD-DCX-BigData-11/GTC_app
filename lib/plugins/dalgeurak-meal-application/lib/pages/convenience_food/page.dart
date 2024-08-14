import 'package:dalgeurak_meal_application/pages/convenience_food/widgets/food_select_container.dart';
import 'package:dalgeurak_meal_application/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ConvenienceFoodPage extends GetView<ConvenienceFoodPageController> {
  const ConvenienceFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dalgeurakGrayOne,
      body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: Get.height * 0.095,
                left: Get.width * 0.1,
                child: WindowTitle(
                  subTitle: "간편식",
                  title: "신청",
                ),
              ),
              Positioned(
                top: Get.height * 0.13,
                right: Get.width * 0.1,
                child: GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset("assets/images/close.svg", package: "dalgeurak_widget_package", width: 18, color: Colors.black))
              ),
              Positioned(
                top: Get.height * 0.185,
                left: Get.width * 0.1,
                child: Text("주 2회 이상 먹지 않을 경우 다음 신청시에 제한이 있습니다.", style: convenienceFood_warning),
              ),
              Positioned(
                top: Get.height * 0.23,
                left: Get.width * 0.1,
                child: Text("시간", style: convenienceFood_menuTitle),
              ),
              Positioned(
                top: Get.height * 0.265,
                left: Get.width * 0.1,
                child: Obx(() => Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.changeMealTypeMenu(MealType.breakfast),
                      child: BlueButton(content: "아침", isLong: false, isSmall: true, isFill: true, isDisable: !(controller.selectMealType.value == MealType.breakfast)),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                        onTap: () => controller.changeMealTypeMenu(MealType.dinner),
                        child: BlueButton(content: "저녁", isLong: false, isSmall: true, isFill: true, isDisable: !(controller.selectMealType.value == MealType.dinner))
                    ),
                  ],
                )),
              ),
              Positioned(
                top: Get.height * 0.345,
                left: Get.width * 0.1,
                child: Text("메뉴", style: convenienceFood_menuTitle),
              ),
              Positioned(
                top: Get.height * 0.33,
                child: Obx(() {
                  List menuList = (controller.convenienceFoodMenuList[controller.selectMealType.value] as List);

                  return SizedBox(
                    width: 330,
                    height: 440,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        return Obx(() => GestureDetector(
                          onTap: () => controller.selectConvenienceFoodType.value = menuList[index],
                          child: FoodSelectContainer(
                              foodType: menuList[index],
                              leftPeopleAmount: controller.convenienceFoodRemainAmount[menuList[index]],
                              lastRefreshDate: controller.lastRefreshTime.value,
                              isSelect: controller.selectConvenienceFoodType.value == menuList[index]
                          ),
                        ));
                      },
                    ),
                  );
                })
              ),
              Positioned(
                bottom: Get.height * 0.07,
                child: GestureDetector(
                  onTap: () => controller.applicationConvenienceFood(),
                  child: BlueButton(content: "신청", isLong: false, isSmall: false, isFill: true, isDisable: false)
                )
              )
            ],
          )
      ),
    );
  }
}
