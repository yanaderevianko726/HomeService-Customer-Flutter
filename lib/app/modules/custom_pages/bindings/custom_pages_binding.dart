import 'package:get/get.dart';

import '../controllers/custom_pages_controller.dart';

class CustomPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomPagesController>(
      () => CustomPagesController(),
    );
  }
}
