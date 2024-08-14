import 'package:get/get.dart';

import 'controller.dart';

class MealExceptionPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealExceptionPageController>(() => MealExceptionPageController());
  }
}
