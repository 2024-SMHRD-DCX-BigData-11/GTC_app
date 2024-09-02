import 'package:dalgeurak/services/shared_preference.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore를 사용하기 위해 추가

class UserController extends GetxController {
  DalgeurakToast dalgeurakToast = DalgeurakToast();
  DalgeurakService dalgeurakService = Get.find<DalgeurakService>();
  DimigoinAccount _dimigoinAccount = Get.find<DimigoinAccount>();

  Rxn<DimigoinUser?> _dimigoinUser = Rxn<DimigoinUser?>();

  DimigoinUser? get user => _dimigoinUser.value;

  set user(DimigoinUser? value) => _dimigoinUser.value = value;

  RxBool isAllowAlert = true.obs;
  RxList<DalgeurakWarning> warningList = [].cast<DalgeurakWarning>().obs;

  @override
  onInit() async {
    super.onInit(); // 반드시 super.onInit()을 호출해야 합니다.
    _dimigoinUser.bindStream(_dimigoinAccount.userChangeStream);
  }

  void updateClassId(int? newClassId) {
    _dimigoinUser.update((user) {
      if (user != null) {
        user.setClassId = newClassId; // 이 줄에서 직접 속성을 수정합니다.
      }
    });
  }



  dynamic getProfileWidget(double _width) {
    if (user?.photos == null || user?.photos?.length == 0) {
      return Icon(Icons.person_rounded, size: _width * 0.12);
    } else {
      return ExtendedImage.network("${user?.photos![0]}",
          cache: true, width: _width * 0.3);
    }
  }

  getUserWarningList() async {
    Map result = await dalgeurakService.getMyWarningList();

    if (result['success']) {
      warningList.value = (result['content'] as List).cast<DalgeurakWarning>();
    } else {
      dalgeurakToast.show("경고 목록을 불러오는데 실패하였습니다.");
    }
  }

  checkUserAllowAlert() async {
    bool? isAllow = await SharedPreference().getAllowAlert();

    if (isAllow == null) {
      setUserAllowAlert(true);
    } else {
      isAllowAlert.value = isAllow;
    }

    return true;
  }

  setUserAllowAlert(bool isAllow) {
    SharedPreference().saveAllowAlert(isAllow);
    isAllowAlert.value = isAllow;
  }

  void updateProfile(String name, int grade, int _class) async {
    Map joinResult = await _dimigoinAccount.update(name, grade, _class);

    if (joinResult['success']) {
      dalgeurakToast.show("프로필 정보가 업데이트되었습니다.");
    } else {
      dalgeurakToast.show("프로필 업데이트에 실패했습니다.");
    }
  }

  void showToast(String text) async {
    dalgeurakToast.show(text);
  }
}
