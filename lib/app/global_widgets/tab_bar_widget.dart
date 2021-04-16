/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController {
  RxString selectedId;

  @override
  void onInit() {
    super.onInit();
  }

  TabBarController() {
    selectedId = RxString();
  }

  bool isSelected(dynamic tabId) => selectedId.value == tabId.toString();

  void toggleSelected(
    dynamic tabId,
  ) {
    if (!isSelected(tabId)) {
      selectedId.value = tabId.toString();
    }
  }
}

class TabBarWidget extends StatelessWidget implements PreferredSize {
  TabBarWidget({Key key, @required this.tag, @required this.tabs}) {
    tabs[0] = Padding(padding: EdgeInsetsDirectional.only(start: 15), child: tabs.elementAt(0));
    tabs[tabs.length - 1] = Padding(padding: EdgeInsetsDirectional.only(end: 15), child: tabs[tabs.length - 1]);
  }

  final String tag;
  final List<Widget> tabs;

  Widget buildTabBar() {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    if (controller.selectedId.firstRebuild) {
      controller.selectedId.value = ((tabs.elementAt(0) as Padding).child as ChipWidget).id.toString();
    }
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(primary: false, shrinkWrap: true, scrollDirection: Axis.horizontal, children: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => new Size(Get.width, 60);
}

class TabBarLoadingWidget extends StatelessWidget implements PreferredSize {
  Widget buildTabBar() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(
          4,
          (index) => RawChip(
            elevation: 0,
            label: Text(''),
            padding: EdgeInsets.symmetric(horizontal: 20.0 * (index + 1), vertical: 15),
            backgroundColor: Get.theme.focusColor.withOpacity(0.1),
            selectedColor: Get.theme.accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            showCheckmark: false,
            pressElevation: 0,
          ).marginSymmetric(horizontal: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => new Size(Get.width, 60);
}

class ChipWidget extends StatelessWidget {
  ChipWidget({
    Key key,
    @required this.text,
    this.onSelected,
    @required this.tag,
    @required this.id,
  }) : super(key: key);

  final String text;
  final dynamic id;
  final String tag;
  final ValueChanged<dynamic> onSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    return Obx(() {
      return RawChip(
        elevation: 0,
        label: Text(text),
        labelStyle: controller.isSelected(this.id) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        backgroundColor: Get.theme.focusColor.withOpacity(0.1),
        selectedColor: Get.theme.accentColor,
        selected: controller.isSelected(this.id),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        pressElevation: 0,
        onSelected: (bool value) {
          controller.toggleSelected(this.id);
          onSelected(id);
        },
      ).marginSymmetric(horizontal: 5);
    });
  }
}
