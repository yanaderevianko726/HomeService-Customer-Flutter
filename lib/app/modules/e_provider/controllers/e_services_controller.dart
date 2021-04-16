import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/e_provider_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class EServicesController extends GetxController {
  final eProvider = new EProvider().obs;
  final selected = Rx<CategoryFilter>();
  final eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  EProviderRepository _eProviderRepository;
  ScrollController scrollController = ScrollController();

  EServicesController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  Future<void> onInit() async {
    eProvider.value = Get.arguments as EProvider;
    selected.value = CategoryFilter.ALL;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadEServicesOfCategory(filter: selected.value);
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    await loadEServicesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadEServicesOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eProviderRepository.getEServices(eProvider.value.id, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eProviderRepository.getFeaturedEServices(eProvider.value.id, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _eProviderRepository.getPopularEServices(eProvider.value.id, page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _eProviderRepository.getMostRatedEServices(eProvider.value.id, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _eProviderRepository.getAvailableEServices(eProvider.value.id, page: this.page.value);
          break;
        default:
          _eServices = await _eProviderRepository.getEServices(eProvider.value.id, page: this.page.value);
      }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
