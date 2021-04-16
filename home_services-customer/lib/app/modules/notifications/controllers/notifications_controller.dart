import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/notification_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../root/controllers/root_controller.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  NotificationRepository _notificationRepository;

  NotificationsController() {
    _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    await getNotifications();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {
      notifications.assignAll(await _notificationRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeNotification(Notification notification) async {
    try {
      _notificationRepository.remove(notification).then((value) {
        if (!notification.read) {
          --Get.find<RootController>().notificationsCount.value;
        }
        notifications.remove(notification);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future markAsReadNotification(Notification notification) async {
    try {
      _notificationRepository.markAsRead(notification).then((value) {
        if (!notification.read) {
          notification.read = true;
          --Get.find<RootController>().notificationsCount.value;
        }
        notifications.refresh();
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
