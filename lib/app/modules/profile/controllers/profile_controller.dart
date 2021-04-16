import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/phone_verification_bottom_sheet_widget.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  GlobalKey<FormState> profileForm;
  UserRepository _userRepository;

  ProfileController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    super.onInit();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (profileForm.currentState.validate()) {
      try {
        profileForm.currentState.save();
        user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value ? newPassword.value : null;
        await _userRepository.sendCodeToPhone();
        Get.bottomSheet(
          PhoneVerificationBottomSheetWidget(),
          isScrollControlled: false,
        );
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
