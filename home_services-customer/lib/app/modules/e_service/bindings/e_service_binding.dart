import 'package:get/get.dart';
import '../controllers/e_service_controller.dart';

class EServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EServiceController>(
      () => EServiceController(),
    );
  }
}
