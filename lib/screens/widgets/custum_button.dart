import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/utils/colors.dart';
import 'package:flutter/material.dart';

class CustumButton extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;
  final bool isEmpty;  // 추가: 버튼이 비어있는 상태인지 여부를 나타내는 플래그

  const CustumButton({
    Key? key,
    required this.buttonName,
    required this.buttonColor,
    this.isEmpty = false,  // 기본값은 false로 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: dalgeurakBlueOne,  // 테두리 색상
          width: 1.0,  // 테두리 두께
        ),
        color: isEmpty ? Colors.white : buttonColor,  // 비어있으면 흰색, 아니면 버튼 컬러
      ),
      child: Center(
        child: Text(
          buttonName,
          style: TextStyle(
            color: isEmpty ? dalgeurakBlueOne : kWhite,  // 비어있으면 텍스트는 파란색, 아니면 흰색
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
