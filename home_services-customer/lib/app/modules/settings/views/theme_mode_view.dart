import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';

import '../controllers/theme_mode_controller.dart';

class ThemeModeView extends GetView<ThemeModeController> {
  final bool hideAppBar;

  ThemeModeView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Theme Mode".tr,
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
        body: ListView(
          primary: true,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  RadioListTile(
                    value: ThemeMode.light,
                    groupValue: controller.selectedThemeMode.value,
                    onChanged: (value) {
                      controller.changeThemeMode(value);
                    },
                    title: Text("Light Theme".tr, style: Get.textTheme.bodyText2),
                  ),
                  RadioListTile(
                    value: ThemeMode.dark,
                    groupValue: controller.selectedThemeMode.value,
                    onChanged: (value) {
                      controller.changeThemeMode(value);
                    },
                    title: Text("Dark Theme".tr, style: Get.textTheme.bodyText2),
                  ),
                  RadioListTile(
                    value: ThemeMode.system,
                    groupValue: controller.selectedThemeMode.value,
                    onChanged: (value) {
                      controller.changeThemeMode(value);
                    },
                    title: Text("System Theme".tr, style: Get.textTheme.bodyText2),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
