import 'package:get/get.dart';

import '../models/setting_model.dart';
import '../providers/laravel_provider.dart';

class SettingRepository {
  LaravelApiClient _laravelApiClient;

  SettingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Setting> get() {
    return _laravelApiClient.getSettings();
  }
}
