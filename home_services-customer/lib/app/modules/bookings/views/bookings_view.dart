import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/notifications_button_widget.dart';
import '../../../global_widgets/tab_bar_widget.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list_widget.dart';

class BookingsView extends GetView<BookingsController> {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBookings(showMessage: true, statusId: controller.currentStatus.value);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              Obx(() {
                return SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 120,
                  elevation: 0.5,
                  floating: false,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    Get.find<SettingsService>().setting.value.appName,
                    style: Get.textTheme.headline6,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.sort, color: Colors.black87),
                    onPressed: () => {Scaffold.of(context).openDrawer()},
                  ),
                  actions: [NotificationsButtonWidget()],
                  bottom: controller.bookingStatuses.isEmpty
                      ? TabBarLoadingWidget()
                      : TabBarWidget(
                          tag: 'bookings',
                          tabs: List.generate(controller.bookingStatuses.length, (index) {
                            var _status = controller.bookingStatuses.elementAt(index);
                            return ChipWidget(
                              tag: 'bookings',
                              text: _status.status.tr,
                              id: _status.id,
                              onSelected: (id) {
                                controller.changeTab(id);
                              },
                            );
                          }),
                        ),
                );
              }),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    BookingsListWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
