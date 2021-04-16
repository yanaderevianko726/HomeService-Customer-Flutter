import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'services_carousel_widget.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetX(builder: (context) {
      return Column(
        children: List.generate(controller.featured.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(_category.name, style: Get.textTheme.headline5)),
                    MaterialButton(
                      onPressed: () {
                        Get.toNamed(Routes.CATEGORY, arguments: _category);
                      },
                      shape: StadiumBorder(),
                      color: Get.theme.accentColor.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.featured.elementAt(index).eServices.isEmpty) {
                  return Text('loading...');
                }
                return ServicesCarouselWidget(services: controller.featured.elementAt(index).eServices);
              }),
            ],
          );
        }),
      );
    });
  }
}
