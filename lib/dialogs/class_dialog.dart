import 'package:dalgeurak/screens/studentManage/qrcode_scan.dart';
import 'package:dalgeurak/screens/widgets/medium_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassDialog extends StatelessWidget {
  const ClassDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showDialog() => Get.dialog(
        Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent, // 투명 배경
                        child: InkWell(
                          child: Container(
                            width: 120,
                            height: 120,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: MediumMenuButton(
                                iconName: "flag",
                                title: "반 만들기",
                                subTitle: "생성",
                                clickAction: () => {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Material(
                        color: Colors.transparent, // 투명 배경
                        child: InkWell(
                          child: Container(
                            width: 120,
                            height: 120,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: MediumMenuButton(
                                iconName: "qrCode",
                                title: "반 등록하기",
                                subTitle: "QR 코드",
                                clickAction: () => {
                                  Get.back(),
                                  Get.to(QrCodeScan()),
                                }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ),
      );
}
