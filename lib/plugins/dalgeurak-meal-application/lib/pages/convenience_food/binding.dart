import 'package:get/get.dart';

import 'controller.dart';

class ConvenienceFoodPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConvenienceFoodPageController>(() => ConvenienceFoodPageController());
  }
}
