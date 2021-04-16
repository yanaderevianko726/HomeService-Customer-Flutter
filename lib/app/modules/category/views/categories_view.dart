import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../../../global_widgets/home_search_bar_widget.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/categories_controller.dart';
import '../widgets/category_grid_item_widget.dart';
import '../widgets/category_list_item_widget.dart';

class CategoriesView extends GetView<CategoriesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Categories".tr,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshCategories(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            children: [
              HomeSearchBarWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "Categories of services".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          controller.layout.value = CategoriesLayout.LIST;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.format_list_bulleted,
                            color: controller.layout.value == CategoriesLayout.LIST ? Get.theme.accentColor : Get.theme.focusColor,
                          );
                        }),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.layout.value = CategoriesLayout.GRID;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.apps,
                            color: controller.layout.value == CategoriesLayout.GRID ? Get.theme.accentColor : Get.theme.focusColor,
                          );
                        }),
                      )
                    ],
                  ),
                ]),
              ),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != CategoriesLayout.GRID,
                  child: controller.categories.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : StaggeredGridView.countBuilder(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: controller.categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryGridItemWidget(category: controller.categories.elementAt(index), heroTag: "heroTag");
                          },
                          staggeredTileBuilder: (int index) => new StaggeredTile.fit(Get.mediaQuery.orientation == Orientation.portrait ? 2 : 4),
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                );
              }),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != CategoriesLayout.LIST,
                  child: controller.categories.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.categories.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return CategoryListItemWidget(
                              heroTag: 'category_list',
                              expanded: index == 0,
                              category: controller.categories.elementAt(index),
                            );
                          },
                        ),
                );
              }),
              // Container(
              //   child: ListView(
              //       primary: false,
              //       shrinkWrap: true,
              //       children: List.generate(controller.categories.length, (index) {
              //         return Obx(() {
              //           var _category = controller.categories.elementAt(index);
              //           return Padding(
              //             padding: const EdgeInsetsDirectional.only(start: 20),
              //             child: Text(_category.name),
              //           );
              //         });
              //       })),
              // ),
            ],
          ),
        ));
  }
}
