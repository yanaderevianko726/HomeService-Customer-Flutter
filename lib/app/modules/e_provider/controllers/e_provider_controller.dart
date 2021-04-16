import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/award_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/review_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../routes/app_pages.dart';

class EProviderController extends GetxController {
  final eProvider = EProvider().obs;
  final reviews = <Review>[].obs;
  final awards = <Award>[].obs;
  final galleries = <Media>[].obs;
  final experiences = <Experience>[].obs;
  final featuredEServices = <EService>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  EProviderRepository _eProviderRepository;

  EProviderController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    eProvider.value = arguments['eProvider'] as EProvider;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();
    await getFeaturedEServices();
    await getAwards();
    await getExperiences();
    await getGalleries();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProvider() async {
    try {
      eProvider.value = await _eProviderRepository.get(eProvider.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedEServices() async {
    try {
      featuredEServices.assignAll(await _eProviderRepository.getFeaturedEServices(eProvider.value.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _eProviderRepository.getReviews(eProvider.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAwards() async {
    try {
      awards.assignAll(await _eProviderRepository.getAwards(eProvider.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getExperiences() async {
    try {
      experiences.assignAll(await _eProviderRepository.getExperiences(eProvider.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getGalleries() async {
    try {
      final _galleries = await _eProviderRepository.getGalleries(eProvider.value.id);
      galleries.assignAll(_galleries.map((e) {
        e.image.name = e.description;
        return e.image;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void startChat() {
    List<User> _employees = eProvider.value.employees.map((e) {
      e.avatar = eProvider.value.images[0];
      return e;
    }).toList();
    Message _message = new Message(_employees, name: eProvider.value.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
