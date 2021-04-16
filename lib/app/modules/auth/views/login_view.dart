import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Login".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.accentColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
          key: controller.loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.accentColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.appName,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best service provider system!".tr,
                            style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border: Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset('assets/icon/icon.png', fit: BoxFit.cover, width: 100, height: 100,),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue)
                  return CircularLoadingWidget(height: 300);
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        onSaved: (input) => controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@') ? "Should be a valid email".tr : null,
                        iconData: Icons.email_outlined,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          onSaved: (input) => controller.currentUser.value.password = input,
                          validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value = !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offAndToNamed(Routes.FORGOT_PASSWORD);
                            },
                            child: Text("Forgot Password?".tr),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      BlockButtonWidget(
                        onPressed: () {
                          controller.login();
                        },
                        color: Get.theme.accentColor,
                        text: Text(
                          "Login".tr,
                          style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text("You don't have an account?".tr),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 20),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
