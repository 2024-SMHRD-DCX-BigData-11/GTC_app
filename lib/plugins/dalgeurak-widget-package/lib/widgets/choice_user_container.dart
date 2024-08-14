import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/text_theme.dart';


class ChoiceUserContainer extends StatelessWidget {
  DimigoinUser choiceUser;
  List<DimigoinUser> choiceUserList;
  bool isSearchPage;
  void Function()? onClick;
  ChoiceUserContainer({required this.choiceUser, required this.choiceUserList, required this.isSearchPage, required this.onClick});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 44,
        height: 75,
        decoration: BoxDecoration(
          color: Colors.transparent
        ),
        margin: EdgeInsets.only(left: (choiceUserList.indexOf(choiceUser) != 0 ? 18 : (isSearchPage ? 18 : 0))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.cancel_rounded, color: dalgeurakGrayFour, size: 16),
            ),
            Positioned(
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/user.svg', package: "dalgeurak_widget_package", width: 36),
                  SizedBox(height: 4),
                  Text("${choiceUser.gradeNum}학년 ${choiceUser.classNum}반", style: choiceUserContainerId),
                  Text("${choiceUser.name}", style: choiceUserContainerName),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}