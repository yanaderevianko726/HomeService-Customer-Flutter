import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getCategories();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address get currentAddress {
    return Get.find<AuthService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
