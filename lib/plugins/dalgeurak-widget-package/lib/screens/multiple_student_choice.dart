import 'package:dalgeurak_widget_package/screens/basic_student_search.dart';
import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../widgets/choice_user_container.dart';

abstract class MultipleStudentChoice extends BasicStudentSearch {
  Duration animationDuration = const Duration(milliseconds: 300);
  RxBool isStudentListSizeBig = true.obs;

  RxList<DimigoinUser> selectStudentList = ([].cast<DimigoinUser>()).obs;


  @override
  String get studentListTileBtnLabel => '선택';

  @override
  void Function()? studentBtnOnClick(DimigoinUser selectStudent) => () {
    int studentIndex = selectStudentList.indexWhere((element) => element.id! == selectStudent.id!);
    if (studentIndex != -1) {
      selectStudentList.removeAt(studentIndex);
      if (selectStudentList.isEmpty) { Future.delayed(animationDuration, () => isStudentListSizeBig.value = true); }

      studentListTileBtnColor[selectStudent.id!] = dalgeurakGrayOne;
      studentListTileBtnTextColor[selectStudent.id!] = dalgeurakGrayFour;
    } else {
      selectStudentList.insert(0, selectStudent);
      if (selectStudentList.isEmpty) { Future.delayed(animationDuration, () => isStudentListSizeBig.value = false); }

      studentListTileBtnColor[selectStudent.id!] = dalgeurakBlueOne;
      studentListTileBtnTextColor[selectStudent.id!] = Colors.white;
    }
  };

  void Function()? nextBtnOnClick(List<DimigoinUser> selectStudentList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Center(
        child: GestureDetector(
          onTap: nextBtnOnClick(selectStudentList),
          child: Container(
            width: 55,
            height: 33,
            decoration: BoxDecoration(
                color: dalgeurakYellowOne,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Center(child: Text("다음", style: studentSearchListTileBtn.copyWith(color: Colors.white))),
          ),
        ),
      ),
      const SizedBox(width: 20),
    ];
  }

  @override
  Widget searchResultWidget(List<DimigoinUser> suggestionList) {
    Widget searchStudentListView = super.searchResultWidget(suggestionList);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(width: Get.width, height: Get.height),
        Obx(() => AnimatedPositioned(
          top: selectStudentList.isNotEmpty ? 0 : -112,
          curve: Curves.ease,
          duration: animationDuration,
          child: Container(
            width: Get.width,
            height: selectStudentList.isNotEmpty ? 112 : 112,
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 4),
                    SizedBox(
                      width: Get.width - 4,
                      height: 80,
                      child: Obx(() => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectStudentList.length,
                          itemBuilder: (context, index) {
                            DimigoinUser selectUser = selectStudentList[index];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChoiceUserContainer(choiceUser: selectUser, choiceUserList: selectStudentList, isSearchPage: true, onClick: studentBtnOnClick(selectUser)),
                              ],
                            );
                          }
                      )),
                    )
                  ],
                ),
                Container(width: Get.width, child: Divider(color: grayOne, thickness: 1.0)),
              ],
            )
          ),
        )),
        Obx(() => AnimatedPositioned(
          top: selectStudentList.isNotEmpty ? 112 : 0,
          duration: animationDuration,
          curve: Curves.ease,
          child: SizedBox(
            width: Get.width,
            height: Get.height - 105 - (isStudentListSizeBig.value ? 0 : 112),
            child: searchStudentListView,
          )
        ))
      ],
    );
  }

}