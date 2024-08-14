import 'package:get/get.dart';

import 'controller.dart';

class MealExceptionTypeSelectPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealExceptionTypeSelectPageController>(() => MealExceptionTypeSelectPageController());
  }
}
