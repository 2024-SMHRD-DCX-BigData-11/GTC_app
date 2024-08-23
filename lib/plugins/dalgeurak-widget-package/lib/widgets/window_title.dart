import 'package:flutter/material.dart';

import 'package:dalgeurak_widget_package/themes/text_theme.dart';

class WindowTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  WindowTitle({required this.subTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subTitle, style: windowTitleSubTitle),
        Text(title, style: windowTitleTitle)
      ],
    );
  }
}