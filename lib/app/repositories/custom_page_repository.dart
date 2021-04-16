import 'package:get/get.dart';

import '../models/custom_page_model.dart';
import '../providers/laravel_provider.dart';

class CustomPageRepository {
  LaravelApiClient _laravelApiClient;

  CustomPageRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<CustomPage>> all() {
    return _laravelApiClient.getCustomPages();
  }

  Future<CustomPage> get(String id) {
    return _laravelApiClient.getCustomPageById(id);
  }
}
