import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/faq_category_model.dart';
import '../../../models/faq_model.dart';
import '../../../repositories/faq_repository.dart';

class HelpController extends GetxController {
  FaqRepository _faqRepository;
  final faqCategories = <FaqCategory>[].obs;
  final faqs = <Faq>[].obs;

  HelpController() {
    _faqRepository = new FaqRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshFaqs();
    super.onInit();
  }

  Future refreshFaqs({bool showMessage, String categoryId}) async {
    getFaqCategories().then((value) async {
      await getFaqs(categoryId: categoryId);
    });
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  Future getFaqs({String categoryId}) async {
    try {
      if (categoryId == null) {
        faqs.assignAll(await _faqRepository.getFaqs(faqCategories.elementAt(0).id));
      } else {
        faqs.assignAll(await _faqRepository.getFaqs(categoryId));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFaqCategories() async {
    try {
      faqCategories.assignAll(await _faqRepository.getFaqCategories());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
