import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/drawer_link_widget.dart';
import '../../../models/custom_page_model.dart';
import '../../../routes/app_pages.dart';
import '../../root/controllers/root_controller.dart';

class CustomPageDrawerLinkWidget extends GetView<RootController> {
  const CustomPageDrawerLinkWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.customPages.isEmpty) {
        return SizedBox();
      }
      return Column(
        children: List.generate(controller.customPages.length, (index) {
          var _page = controller.customPages.elementAt(index);
          return DrawerLinkWidget(
            icon: getDrawerLinkIcon(_page),
            text: _page.title,
            onTap: (e) async {
              //print(_page.id);
              await Get.offAndToNamed(Routes.CUSTOM_PAGES, arguments: _page);
            },
          );
        }),
      );
    });
  }

  IconData getDrawerLinkIcon(CustomPage _page) {
    switch (_page.id) {
      case '1':
        return Icons.privacy_tip_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
