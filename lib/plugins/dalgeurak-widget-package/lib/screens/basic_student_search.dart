import 'package:dalgeurak_widget_package/services/check_text_validate.dart';
import 'package:dalgeurak_widget_package/services/dalgeurak_api.dart';
import 'package:dalgeurak_widget_package/widgets/student_list_tile.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:korea_regexp/korea_regexp.dart';

import '../../themes/color_theme.dart';
import '../themes/text_theme.dart';

abstract class BasicStudentSearch extends SearchDelegate {
  late List<DimigoinUser> _studentList;

  set studentList(List<DimigoinUser> list) => _studentList = list;

  @override
  String get searchFieldLabel => '학번, 이름으로 검색';

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    hintStyle: studentSearchFieldLabel.copyWith(color: dalgeurakGrayTwo),
    labelStyle: studentSearchFieldLabel, //TODO 오류인지 뭔지는 모르겠는데 스타일이 정상적으로 적용되지 않음. 추후 확인필요.
    border: InputBorder.none,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_rounded, color: dalgeurakGrayFour),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
        elevation: 0.4,
      )
    );
  }

  String studentListTileBtnLabel = "관리";

  RxMap<int, Color> studentListTileBtnColor = ({}.cast<int, Color>()).obs;

  RxMap<int, Color> studentListTileBtnTextColor = ({}.cast<int, Color>()).obs;

  void Function()? studentBtnOnClick(DimigoinUser selectStudent);

  Widget searchResultWidget(List<DimigoinUser> suggestionList) => ListView.builder(
    itemCount: suggestionList.length,
    itemBuilder: (context, index) {
      DimigoinUser selectStudent = suggestionList[index];

      return StudentListTile(
          isGroupTile: false,
          selectStudent: selectStudent,
          trailingWidget: GestureDetector(
              onTap: studentBtnOnClick(selectStudent),
              child: Obx(() => Container(
                width: Get.width * 0.15,
                height: Get.height * 0.045,
                decoration: BoxDecoration(
                    color: studentListTileBtnColor[selectStudent.id],
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(child: Text(studentListTileBtnLabel, style: studentSearchListTileBtn.copyWith(color: studentListTileBtnTextColor[selectStudent.id]))),
              ))
          )
      );
    },
  );

  bool isMustStudentListDataReload = false;

  @override
  Widget buildSuggestions(BuildContext context) {
    DalgeurakStudentListAPI _dalgeurakStudentListAPI = DalgeurakStudentListAPI();

    return FutureBuilder(
        future: _dalgeurakStudentListAPI.getStudentList(isMustStudentListDataReload),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _studentList = List<DimigoinUser>.from(snapshot.data);

            if (studentListTileBtnColor.isEmpty) { _studentList.forEach((element) { studentListTileBtnColor.addAll({(element).id!: dalgeurakGrayOne}); studentListTileBtnTextColor.addAll({(element).id!: dalgeurakGrayFour}); }); }

            dynamic resultWidget;

            if (query.isNotEmpty) {
              List<DimigoinUser> suggestionList = changeSearchTerm(query);

              resultWidget = searchResultWidget(suggestionList);
            } else {
              resultWidget = Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(width: Get.width, height: Get.height),
                  Column(
                    children: [
                      SizedBox(height: Get.height * 0.1),
                      Text(
                        "검색어를 입력해주세요",
                        style: studentSearchQueryEmptyTitle,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        "학생 이름(ex: 유*희 or ㅇ*ㅎ)을 직접 입력하거나,\n각 학생의 학번(ex: 2300)으로 찾을 수도 있어요\n\n\n개인정보 보호로 인해 예시처럼 이름 가운데엔 *표시가,\n학생 번호는 00으로 가림처리 됩니다.\n이에 유의하면서 검색을 진행해주세요!",
                        style: studentSearchQueryEmptySubTitle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              );
            }


            return Scaffold(
              backgroundColor: Colors.white,
              body: resultWidget,
            );
          } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width, height: Get.height * 0.4),
                Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
              ],
            );
          } else { //데이터를 불러오는 중
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width, height: Get.height * 0.4),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        }
    );
  }

  changeSearchTerm(String text) {
    RegExpOptions expOptions = RegExpOptions(
      initialSearch: true,
      startsWith: false,
      endsWith: false,
      fuzzy: false,
      ignoreSpace: false,
      ignoreCase: false,
    );

    RegExp regExp;
    String searchText = "";
    if (CheckTextValidate().validateIsOnlyHangeulStr(text) && text.length > 1) {
      switch (text.length) {
        case 2:
          searchText = "신*${text[1]}";
          break;
        case 3:
          searchText = "${text[0]}*${text[2]}";
          break;
        case 4:
          searchText = "${text.substring(0, 2)}*${text[3]}";
          break;
        default:
          searchText = text;
      }

      regExp = getRegExp(
          searchText,
          expOptions
      );
    } else {
      regExp = getRegExp(
          text,
          expOptions
      );
    }

    List<DimigoinUser> result = [];
    result.addAll(_studentList.where((element) => (regExp.hasMatch(element.name as String) || element.name == searchText)).toList());
    result.addAll(_studentList.where((element) => regExp.hasMatch(element.studentId.toString())).toList());

    return result;
  }
}