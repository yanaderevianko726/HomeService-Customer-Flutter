import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';

class CustomPagesController extends GetxController {
  final customPage = CustomPage().obs;
  CustomPageRepository _customPageRepository;

  CustomPagesController() {
    _customPageRepository = CustomPageRepository();
  }

  @override
  void onInit() {
    customPage.value = Get.arguments as CustomPage;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshCustomPage();
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> refreshCustomPage({bool showMessage = false}) async {
    await getCustomPage();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Page refreshed successfully".tr));
    }
  }

  Future<void> getCustomPage() async {
    try {
      customPage.value = await _customPageRepository.get(customPage.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
