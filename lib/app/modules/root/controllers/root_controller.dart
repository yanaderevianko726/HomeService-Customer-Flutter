/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    await getCustomPages();
    if (Get.arguments != null && Get.arguments is int) {
      await changePageInRoot(Get.arguments as int);
    } else {
      await changePageInRoot(0);
    }
    super.onInit();
  }

  List<Widget> pages = [
    Home2View(),
    BookingsView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
    await refreshPage(_index);
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          await Get.find<BookingsController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().listenForMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
