import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/text_theme.dart';

class StudentListTile extends StatelessWidget {
  bool isGroupTile;
  DimigoinUser selectStudent;
  int? groupStudentAmount;
  Widget trailingWidget;
  StudentListTile({required this.isGroupTile, required this.selectStudent, this.groupStudentAmount, required this.trailingWidget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${selectStudent.gradeNum}학년 ${selectStudent.classNum}반", style: studentSearchListTileStudentId),
      subtitle: Text("${selectStudent.name!}${isGroupTile ? " 외 $groupStudentAmount명" : ""}", style: studentSearchListTileStudentName),
      leading: SizedBox(
        width: Get.width * 0.1,
        height: Get.width * 0.1,
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.0115),
            SvgPicture.asset('assets/images/user.svg', package: "dalgeurak_widget_package", width: 24),
          ],
        ),
      ),
      trailing: trailingWidget,
    );
  }
}