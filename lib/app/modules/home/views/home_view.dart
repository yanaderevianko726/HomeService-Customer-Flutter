import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../controllers/home_controller.dart';
import '../widgets/address_widget.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/welcome_widget.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.find<SettingsService>().setting.value.appName,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              AddressWidget(),
              WelcomeWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text("Categories".tr, style: Get.textTheme.headline5)),
                    MaterialButton(
                      onPressed: () {},
                      shape: StadiumBorder(),
                      color: Get.theme.accentColor.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              CategoriesCarouselWidget(),
              Container(
                color: Get.theme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text("Recommended for you".tr, style: Get.textTheme.headline5)),
                    MaterialButton(
                      onPressed: () {},
                      shape: StadiumBorder(),
                      color: Get.theme.accentColor.withOpacity(0.1),
                      child: Text("View All".tr, style: Get.textTheme.subtitle1),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              RecommendedCarouselWidget(),
              FeaturedCategoriesWidget(),
            ],
          )),
    );
  }
}
