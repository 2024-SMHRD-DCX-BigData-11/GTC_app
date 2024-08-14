import 'package:dalgeurak_meal_application/themes/text_theme.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';


class ExceptionTypeContainer extends StatelessWidget {
  final String weekday;
  final MealType mealType;
  final MealExceptionType exceptionType;
  final bool isEnable;
  String? remainPeople;
  bool? isApplicationPage;
  ExceptionTypeContainer({required this.weekday, required this.mealType, required this.exceptionType, required this.isEnable, this.remainPeople, this.isApplicationPage});

  @override
  Widget build(BuildContext context) {
    isApplicationPage ??= false;

    return Container(
      width: isApplicationPage! ? 120 : 145,
      height: isApplicationPage! ? 40 : 65,
      decoration: BoxDecoration(
        color: (isEnable ? dalgeurakBlueOne : dalgeurakGrayOne),
        borderRadius: BorderRadius.circular(isApplicationPage! ? 5 : 10),
      ),
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$weekday요일 ${mealType.convertKorStr} ${exceptionType.convertKorStr}", style: exceptionTypeContainer_title.copyWith(color: isEnable ? Colors.white : exceptionTypeContainer_title.color)),
            (
              isApplicationPage! ? const SizedBox()
               : Column(
                children: [
                  const SizedBox(height: 4),
                Text("남은 인원: $remainPeople명", style: exceptionTypeContainer_remainAmount.copyWith(color: isEnable ? Colors.white : exceptionTypeContainer_remainAmount.color))
                ],
              )
            )
          ],
        )
      ),
    );
  }
}