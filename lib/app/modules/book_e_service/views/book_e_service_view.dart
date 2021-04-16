import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Book the Service".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Address".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SETTINGS_ADDRESSES);
                            },
                            child: Text(controller.currentAddress?.address ?? "Loading...".tr, style: Get.textTheme.bodyText2),
                          );
                        }),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                          icon: Icon(Icons.gps_fixed),
                          onPressed: () async {
                            LocationResult result = await showLocationPicker(context, Get.find<SettingsService>().setting.value.googleMapsKey,
                                initialCenter: Get.find<AuthService>().address.value.getLatLng(),
                                automaticallyAnimateToCurrentLocation: false,
                                myLocationButtonEnabled: true,
                                layersButtonEnabled: true,
                                language: Get.locale.languageCode,
                                desiredAccuracy: LocationAccuracy.best,
                                appBarColor: Get.theme.primaryColor);
                            print("result = $result");
                            Get.find<AuthService>().address.update((val) {
                              val.address = result?.address;
                              val.latitude = result?.latLng?.latitude;
                              val.longitude = result?.latLng?.longitude;
                              val.userId = Get.find<AuthService>().user.value.id;
                            });
                          })
                    ],
                  ),
                ],
              ),
            ),
            TextFieldWidget(
              onChanged: (input) => controller.booking.value.hint = input,
              hintText: "A Hint for the Provider".tr,
              labelText: "Hint".tr,
              iconData: Icons.description_outlined,
            ),
            Obx(() {
              return TextFieldWidget(
                onChanged: (input) => controller.booking.value.coupon.code = input,
                hintText: "COUPON01".tr,
                labelText: "Coupon Code".tr,
                errorText: controller.getValidationMessage(),
                iconData: Icons.confirmation_number_outlined,
                style: Get.textTheme.bodyText2.merge(TextStyle(color: controller.getValidationMessage() != null ? Colors.redAccent : Colors.green)),
                suffixIcon: MaterialButton(
                  onPressed: () {
                    controller.validateCoupon();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: Get.theme.focusColor.withOpacity(0.1),
                  child: Text("Validate".tr, style: Get.textTheme.bodyText1),
                  elevation: 0,
                ).marginSymmetric(vertical: 4),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: Ui.getBoxDecoration(color: controller.getColor(!controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    toggleableActiveColor: Get.theme.primaryColor,
                  ),
                  child: RadioListTile(
                    value: false,
                    groupValue: controller.scheduled.value,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("As Soon as Possible".tr, style: controller.getTextTheme(!controller.scheduled.value)).paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: Ui.getBoxDecoration(color: controller.getColor(controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    toggleableActiveColor: Get.theme.primaryColor,
                  ),
                  child: RadioListTile(
                    value: true,
                    groupValue: controller.scheduled.value,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("Schedule an Order".tr, style: controller.getTextTheme(controller.scheduled.value)).paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedOpacity(
                opacity: controller.scheduled.value ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: controller.scheduled.value ? 20 : 0),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: controller.scheduled.value ? 20 : 0),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text("When would you like us to come to your address?", style: Get.textTheme.bodyText1),
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.showMyDatePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.2),
                            child: Text("Select a Date".tr, style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                      Divider(thickness: 1.3, height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Text("At What's time you are free in your address?", style: Get.textTheme.bodyText1),
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                            onPressed: () {
                              controller.showMyTimePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.2),
                            child: Text("Select a time".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                transform: Matrix4.translationValues(0, controller.scheduled.value ? 0 : -110, 0),
                child: Obx(() {
                  return Column(
                    children: [
                      Text("Requested Service on".tr).paddingSymmetric(vertical: 20),
                      Text('${DateFormat.yMMMMEEEEd().format(controller.booking.value.bookingAt)}', style: Get.textTheme.headline5),
                      Text('At ${DateFormat('HH:mm').format(controller.booking.value.bookingAt)}', style: Get.textTheme.headline3),
                    ],
                  );
                }),
              );
            })
          ],
        ));
  }

  Widget buildBlockButtonWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Continue".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
            ],
          ),
          color: Get.theme.accentColor,
          onPressed: () {
            controller.createBooking();
          }).paddingOnly(right: 20, left: 20),
    );
  }
}
