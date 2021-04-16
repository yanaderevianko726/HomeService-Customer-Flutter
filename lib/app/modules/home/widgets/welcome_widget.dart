import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

import '../../../global_widgets/search_bar_widget.dart';
import '../controllers/home_controller.dart';

class WelcomeWidget extends StatelessWidget {
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Get.theme.accentColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Welcome,".tr, style: Get.textTheme.bodyText1),
                Text(Get.find<AuthService>().user.value.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor))),
                Text('!', style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.primaryColor)))
              ],
            ),
            SizedBox(height: 8),
            Text("Can I help you something?".tr, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
            SizedBox(height: 22),
            SearchBarWidget()
          ],
        ),
      ),
    );
  }
}
