import 'package:get/get.dart';

import '../controllers/address_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/theme_mode_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<AddressController>(
      () => AddressController(),
    );
    Get.lazyPut<ThemeModeController>(
      () => ThemeModeController(),
    );
    Get.lazyPut<LanguageController>(
      () => LanguageController(),
    );
  }
}
