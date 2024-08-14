import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class OneLineTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool isEnable;
  bool? isSmall;
  OneLineTextField({required this.hintText, required this.textController, required this.isEnable, this.isSmall});

  @override
  Widget build(BuildContext context) {
    isSmall ??= false;

    return Container(
      width: isSmall! ? 270 : 300,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: dalgeurakGrayTwo, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        enabled: isEnable,
        keyboardType: TextInputType.text,
        controller: textController,
        style: reasonTextField,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0, style: BorderStyle.none,)),
          hintText: hintText,
          hintStyle: reasonTextField.copyWith(color: dalgeurakGrayTwo),
        ),
      ),
    );
  }
}