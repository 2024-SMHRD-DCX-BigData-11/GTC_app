import 'package:get/get.dart';

import 'controller.dart';

class MealCancelPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealCancelPageController>(() => MealCancelPageController());
  }
}
