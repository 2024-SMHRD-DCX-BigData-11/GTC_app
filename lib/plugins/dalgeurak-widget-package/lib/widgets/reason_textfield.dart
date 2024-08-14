import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class ReasonTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool isBig;
  final bool isEnable;
  ReasonTextField({required this.hintText, required this.textController, required this.isBig, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isBig ? Get.width * 0.846 : 300,
      height: isBig ? Get.height * 0.185 : 100,
      decoration: BoxDecoration(
        border: Border.all(color: dalgeurakGrayTwo, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        enabled: isEnable,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: textController,
        textAlign: TextAlign.center,
        style: reasonTextField,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
          hintText: hintText,
          hintStyle: reasonTextField.copyWith(color: dalgeurakGrayTwo),
        ),
      ),
    );
  }
}