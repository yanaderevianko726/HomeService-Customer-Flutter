import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../controllers/privacy_controller.dart';

class HelpPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyController>(
      () => PrivacyController(),
    );
    Get.lazyPut<HelpController>(
      () => HelpController(),
    );
  }
}
