import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../services/auth_service.dart';
import '../../favorites/controllers/favorites_controller.dart';

class EServiceController extends GetxController {
  final eService = EService().obs;
  final reviews = <Review>[].obs;
  final optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final heroTag = ''.obs;
  EServiceRepository _eServiceRepository;

  EServiceController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    eService.value = arguments['eService'] as EService;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    await getEService();
    await getReviews();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEService() async {
    try {
      eService.value = await _eServiceRepository.get(eService.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _eServiceRepository.getReviews(eService.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getOptionGroups() async {
    try {
      var _optionGroups = await _eServiceRepository.getOptionGroups(eService.value.id);
      optionGroups.assignAll(_optionGroups.map((element) {
        element.options.removeWhere((option) => option.eServiceId != eService.value.id);
        return element;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future addToFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        eService: this.eService.value,
        userId: Get.find<AuthService>().user.value.id,
        options: getCheckedOptions(),
      );
      await _eServiceRepository.addFavorite(_favorite);
      eService.update((val) {
        val.isFavorite = true;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: this.eService.value.name + " Added to favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeFromFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        eService: this.eService.value,
        userId: Get.find<AuthService>().user.value.id,
      );
      await _eServiceRepository.removeFavorite(_favorite);
      eService.update((val) {
        val.isFavorite = false;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: this.eService.value.name + " Removed from favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectOption(OptionGroup optionGroup, Option option) {
    optionGroup.options.forEach((e) {
      if (!optionGroup.allowMultiple && option != e) {
        e.checked.value = false;
      }
    });
    option.checked.value = !option.checked.value;
  }

  List<Option> getCheckedOptions() {
    if (optionGroups.isNotEmpty) {
      return optionGroups.map((element) => element.options).expand((element) => element).toList().where((option) => option.checked.value).toList();
    }
    return [];
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.accentColor));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.accentColor));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.accentColor.withOpacity(0.1);
    }
    return null;
  }
}
