import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/notifications_button_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<AuthService>().user;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Account".tr,
            style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.accentColor,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Get.theme.primaryColor),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          elevation: 0,
          actions: [
            NotificationsButtonWidget(
              iconColor: Get.theme.primaryColor,
              labelColor: Get.theme.hintColor,
            )
          ],
        ),
        body: ListView(
          primary: true,
          children: [
            Obx(() {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 150,
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
                            _currentUser.value.name,
                            style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                          SizedBox(height: 5),
                          Text(_currentUser.value.email, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
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
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: _currentUser.value.avatar.thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.person_outline, color: Get.theme.accentColor),
                    text: Text("Profile".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.PROFILE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.assignment_outlined, color: Get.theme.accentColor),
                    text: Text("My Bookings".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(1);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.notifications_outlined, color: Get.theme.accentColor),
                    text: Text("Notifications".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.NOTIFICATIONS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.chat_outlined, color: Get.theme.accentColor),
                    text: Text("Messages".tr),
                    onTap: (e) {
                      Get.find<RootController>().changePage(2);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.settings_outlined, color: Get.theme.accentColor),
                    text: Text("Settings".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.translate_outlined, color: Get.theme.accentColor),
                    text: Text("Languages".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_LANGUAGE);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.brightness_6_outlined, color: Get.theme.accentColor),
                    text: Text("Theme Mode".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.SETTINGS_THEME_MODE);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(Icons.support_outlined, color: Get.theme.accentColor),
                    text: Text("Help & FAQ".tr),
                    onTap: (e) {
                      Get.toNamed(Routes.HELP);
                    },
                  ),
                  AccountLinkWidget(
                    icon: Icon(Icons.logout, color: Get.theme.accentColor),
                    text: Text("Logout".tr),
                    onTap: (e) async {
                      await Get.find<AuthService>().removeCurrentUser();
                      Get.find<RootController>().changePageOutRoot(0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
