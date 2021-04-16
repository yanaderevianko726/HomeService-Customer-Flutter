import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'theme_mode_controller.dart';
import '../../../services/settings_service.dart';

class LanguageController extends GetxController {
  GetStorage _box;

  LanguageController() {
    _box = new GetStorage();
  }

  void updateLocale(value) async {
    if (value.contains('_')) {
      // en_US
      Get.updateLocale(Locale(value.split('_').elementAt(0), value.split('_').elementAt(1)));
    } else {
      // en
      Get.updateLocale(Locale(value));
    }
    await _box.write('language', value);
    if (Get.isDarkMode) {
      Get.find<ThemeModeController>().changeThemeMode(ThemeMode.light);
    }
    Get.rootController.setTheme(Get.find<SettingsService>().getLightTheme());
  }
}
