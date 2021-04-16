import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_row_widget.dart';
import '../widgets/booking_til_widget.dart';
import '../widgets/booking_title_bar_widget.dart';

class BookingView extends GetView<BookingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BookingActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBooking(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 370,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => {Get.back()},
                ),
                bottom: buildBookingTitleBarWidget(controller.booking),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return GoogleMap(
                      compassEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      liteModeEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
                      markers: Set.from(controller.allMarkers),
                      onMapCreated: (GoogleMapController _con) {
                        controller.mapController = _con;
                      },
                    );
                  }),
                ).marginOnly(bottom: 60),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildContactProvider(controller.booking.value),
                    Obx(() {
                      return BookingTilWidget(
                        title: Text("Booking Details".tr, style: Get.textTheme.subtitle2),
                        actions: [Text("#" + controller.booking.value.id, style: Get.textTheme.subtitle2)],
                        content: Column(
                          children: [
                            BookingRowWidget(
                                description: "Status".tr,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Get.theme.focusColor.withOpacity(0.1),
                                      ),
                                      child: Text(
                                        controller.booking.value.status.status,
                                        style: TextStyle(color: Get.theme.hintColor),
                                      ),
                                    ),
                                  ],
                                ),
                                hasDivider: true),
                            BookingRowWidget(
                                description: "Payment Status".tr,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: Get.theme.focusColor.withOpacity(0.1),
                                      ),
                                      child: Text(
                                        controller.booking.value.payment?.paymentStatus?.status ?? "Not Paid".tr,
                                        style: TextStyle(color: Get.theme.hintColor),
                                      ),
                                    ),
                                  ],
                                ),
                                hasDivider: true),
                            if (controller.booking.value.payment?.paymentMethod != null)
                              BookingRowWidget(
                                  description: "Payment Method".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.booking.value.payment?.paymentMethod?.name ?? "Not Paid".tr,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                            BookingRowWidget(description: "Hint".tr, value: controller.booking.value.hint),
                          ],
                        ),
                      );
                    }),
                    BookingTilWidget(
                      title: Text("Booking Date & Time".tr, style: Get.textTheme.subtitle2),
                      actions: [
                        Container(
                          padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Get.theme.focusColor.withOpacity(0.1),
                          ),
                          child: Obx(() {
                            return Text(
                              controller.getTime(),
                              style: Get.textTheme.bodyText2,
                            );
                          }),
                        )
                      ],
                      content: Obx(() {
                        return Column(
                          children: [
                            if (controller.booking.value.bookingAt != null)
                              BookingRowWidget(
                                  description: "Booking At".tr,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        DateFormat('d, MMMM y | HH:mm').format(controller.booking.value.bookingAt),
                                        style: Get.textTheme.caption,
                                      )),
                                  hasDivider: controller.booking.value.startAt != null || controller.booking.value.endsAt != null),
                            if (controller.booking.value.startAt != null)
                              BookingRowWidget(
                                  description: "Started At".tr,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        DateFormat('d, MMMM y | HH:mm').format(controller.booking.value.startAt),
                                        style: Get.textTheme.caption,
                                      )),
                                  hasDivider: false),
                            if (controller.booking.value.endsAt != null)
                              BookingRowWidget(
                                description: "Ended At".tr,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      DateFormat('d, MMMM y | HH:mm').format(controller.booking.value.endsAt),
                                      style: Get.textTheme.caption,
                                    )),
                              ),
                          ],
                        );
                      }),
                    ),
                    BookingTilWidget(
                      title: Text("Pricing".tr, style: Get.textTheme.subtitle2),
                      content: Column(
                        children: [
                          BookingRowWidget(
                              description: controller.booking.value.eService.name,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Ui.getPrice(controller.booking.value.eService.getPrice, style: Get.textTheme.subtitle2),
                              ),
                              hasDivider: true),
                          Column(
                            children: List.generate(controller.booking.value.options.length, (index) {
                              var _option = controller.booking.value.options.elementAt(index);
                              return BookingRowWidget(
                                  description: _option.name,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(_option.price, style: Get.textTheme.bodyText1),
                                  ),
                                  hasDivider: (controller.booking.value.options.length - 1) == index);
                            }),
                          ),
                          Column(
                            children: List.generate(controller.booking.value.taxes.length, (index) {
                              var _tax = controller.booking.value.taxes.elementAt(index);
                              return BookingRowWidget(
                                  description: _tax.name,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: _tax.type == 'percent'
                                        ? Text(_tax.value.toString() + '%', style: Get.textTheme.bodyText1)
                                        : Ui.getPrice(
                                            _tax.value,
                                            style: Get.textTheme.bodyText1,
                                          ),
                                  ),
                                  hasDivider: (controller.booking.value.taxes.length - 1) == index);
                            }),
                          ),
                          Obx(() {
                            return BookingRowWidget(
                              description: "Tax Amount".tr,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Ui.getPrice(controller.booking.value.getTaxesValue(), style: Get.textTheme.subtitle2),
                              ),
                              hasDivider: false,
                            );
                          }),
                          Obx(() {
                            return BookingRowWidget(
                                description: "Subtotal".tr,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Ui.getPrice(controller.booking.value.getSubtotal(), style: Get.textTheme.subtitle2),
                                ),
                                hasDivider: true);
                          }),
                          if ((controller.booking.value.coupon?.discount ?? 0) > 0)
                            BookingRowWidget(
                                description: "Coupon".tr,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Wrap(
                                    children: [
                                      Text(' - ', style: Get.textTheme.bodyText1),
                                      Ui.getPrice(controller.booking.value.coupon.discount,
                                          style: Get.textTheme.bodyText1, unit: controller.booking.value.coupon.discountType == 'percent' ? "%" : null),
                                    ],
                                  ),
                                ),
                                hasDivider: true),
                          Obx(() {
                            return BookingRowWidget(
                              description: "Total Amount".tr,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Ui.getPrice(controller.booking.value.getTotal(), style: Get.textTheme.headline6),
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  BookingTitleBarWidget buildBookingTitleBarWidget(Rx<Booking> _booking) {
    return BookingTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _booking.value.eService?.name ?? '',
                    style: Get.textTheme.headline5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Text(
                        _booking.value.user?.name ?? '',
                        style: Get.textTheme.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(_booking.value.address.address, maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyText1),
                      ),
                    ],
                    // spacing: 8,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm').format(_booking.value.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.accentColor, height: 1.4),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('dd').format(_booking.value.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.headline3.merge(
                        TextStyle(color: Get.theme.accentColor, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  Text(DateFormat('MMM').format(_booking.value.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.accentColor, height: 1),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                ],
              ),
              decoration: BoxDecoration(
                color: Get.theme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            ),
          ],
        );
      }),
    );
  }

  Container buildContactProvider(Booking _booking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Provider".tr, style: Get.textTheme.subtitle2),
                Text(_booking.eProvider?.phoneNumber ?? '', style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  //controller.saveProfileForm(_profileForm);
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.accentColor,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  //controller.saveProfileForm(_profileForm);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                padding: EdgeInsets.zero,
                height: 44,
                minWidth: 44,
                child: Icon(
                  Icons.chat_outlined,
                  color: Get.theme.accentColor,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
