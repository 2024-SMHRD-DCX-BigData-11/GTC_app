import 'package:dalgeurak_widget_package/themes/color_theme.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../themes/text_theme.dart';

class DateSelectContainer extends StatelessWidget {
  Rx<PickerDateRange> selectDate;
  bool isEnable;
  DateSelectContainer({required this.selectDate, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            border: Border.all(
              width: 1,
              color: dalgeurakGrayTwo,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            late String text;
            PickerDateRange? selectDate = this.selectDate.value;

            if (selectDate.startDate == null) {
              text = "";
            } else {
              text = "${selectDate.startDate?.month}월 ${selectDate.startDate?.day}일";

              if (selectDate.endDate != null) {
                text = text + " ~ ${selectDate.endDate?.month}월 ${selectDate.endDate?.day}일";
              }
            }

            return Text(text, style: datePicker_selectDate);
          }),
        ),
        GestureDetector(
          onTap: () {
            if (isEnable) {
              Get.dialog(
                  Dialog(
                    child: Container(
                      height: Get.height * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          showActionButtons: true,
                          confirmText: "선택",
                          cancelText: "취소",
                          onCancel: () => Get.back(),
                          onSubmit: (Object? value) {
                            try {
                              PickerDateRange date = (value as PickerDateRange);
                              selectDate.value = date;
                            } catch (e) {
                              DalgeurakToast().show("날짜를 선택하지 않으셨습니다. 선택한 후 다시 시도해주세요.");
                            } finally {
                              Get.back();
                            }
                          }
                      ),
                    ),
                  )
              );
            }
          },
          child: Container(
            width: 50,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
              border: Border.all(
                width: 1,
                color: dalgeurakGrayFour,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                "${DimigoinAccount().isLogin ? "packages/dalgeurak_meal_application/" : ""}assets/images/icons/calendar.svg",
                width: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}