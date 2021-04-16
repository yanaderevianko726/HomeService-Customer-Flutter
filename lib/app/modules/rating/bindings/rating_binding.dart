import 'package:get/get.dart';

import '../controllers/rating_controller.dart';

class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingController>(
      () => RatingController(),
    );
  }
}
