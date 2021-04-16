import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;

  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  CameraPosition _kGooglePlex;

  @override
  Widget build(BuildContext context) {
    controller.profileForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar ? null
          : AppBar(
              title: Text(
                "Profile".tr,
                style: context.textTheme.headline6,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () => Get.back(),
              ),
              elevation: 0,
            ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    controller.saveProfileForm();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.accentColor,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                ),
              ),
              SizedBox(width: 10),
              MaterialButton(
                onPressed: () {
                  controller.resetProfileForm();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Reset".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              Text("Profile details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.name = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                initialValue: controller.user.value.name,
                hintText: "John Doe".tr,
                labelText: "Full Name".tr,
                iconData: Icons.person_outline,
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.email = input,
                validator: (input) => !input.contains('@') ? "Should be a valid email" : null,
                initialValue: controller.user.value.email,
                hintText: "johndoe@gmail.com",
                labelText: "Email".tr,
                iconData: Icons.alternate_email,
              ),
              TextFieldWidget(
                keyboardType: TextInputType.phone,
                onSaved: (input) => controller.user.value.phoneNumber = input,
                validator: (input) => !input.startsWith('+') && !input.startsWith('00') ? "Phone number must start with country code!".tr : null,
                initialValue: controller.user.value.phoneNumber,
                hintText: "+1 565 6899 659",
                labelText: "Phone number".tr,
                iconData: Icons.phone_android_outlined,
                suffix: controller.user.value.verifiedPhone
                    ? Text(
                        "Verified",
                        style: Get.textTheme.caption.merge(TextStyle(color: Colors.green)),
                      )
                    : Text(
                        "Not Verified",
                        style: Get.textTheme.caption.merge(TextStyle(color: Colors.redAccent)),
                      ),
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.address = input,
                validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                initialValue: controller.user.value.address,
                hintText: "123 Street, City 136, State, Country".tr,
                labelText: "Address".tr,
                iconData: Icons.map_outlined,
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.bio = input,
                initialValue: controller.user.value.bio,
                hintText: "Your short biography here".tr,
                labelText: "Short Biography".tr,
                iconData: Icons.article_outlined,
              ),
              Text("Change password".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              Text("Fill your old password and type new password and confirm it".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
              Obx(() {
                // TODO verify old password
                return TextFieldWidget(
                  labelText: "Old Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) => controller.oldPassword.value = input,
                  onChanged: (input) => controller.oldPassword.value = input,
                  validator: (input) => input.length > 0 && input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.oldPassword.value,
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
                  isFirst: true,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "New Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) => controller.newPassword.value = input,
                  onChanged: (input) => controller.newPassword.value = input,
                  validator: (input) {
                    if (input.length > 0 && input.length < 3) {
                      return "Should be more than 3 letters".tr;
                    } else if (input != controller.confirmPassword.value) {
                      return "Passwords do not match".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.newPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Confirm New Password".tr,
                  hintText: "••••••••••••".tr,
                  onSaved: (input) => controller.confirmPassword.value = input,
                  onChanged: (input) => controller.confirmPassword.value = input,
                  validator: (input) {
                    if (input.length > 0 && input.length < 3) {
                      return "Should be more than 3 letters".tr;
                    } else if (input != controller.newPassword.value) {
                      return "Passwords do not match".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.confirmPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: true,
                );
              }),
            ],
          ),
        ));
  }
}
