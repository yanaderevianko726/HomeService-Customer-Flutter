import 'package:get/get.dart';

import '../../../models/media_model.dart';

class GalleryController extends GetxController {
  final media = <Media>[].obs;
  final current = Media().obs;
  final heroTag = ''.obs;

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    media.assignAll(arguments['media'] as List<Media>);
    current.value = arguments['current'] as Media;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
