import 'package:get/get.dart';

import '../models/slide_model.dart';
import '../providers/laravel_provider.dart';

class SliderRepository {
  LaravelApiClient _laravelApiClient;

  SliderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Slide>> getHomeSlider() {
    return _laravelApiClient.getHomeSlider();
  }
}
