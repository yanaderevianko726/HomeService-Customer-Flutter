import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/tab_bar_widget.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../bookings/controllers/bookings_controller.dart';

class BookEServiceController extends GetxController {
  final scheduled = false.obs;
  final Rx<Booking> booking = Booking().obs;
  BookingRepository _bookingRepository;

  get currentAddress => Get.find<AuthService>().address.value;

  BookEServiceController() {
    _bookingRepository = BookingRepository();
  }

  @override
  void onInit() {
    this.booking.value = Booking(
      bookingAt: DateTime.now(),
      address: Get.find<AuthService>().address.value,
      eService: (Get.arguments['eService'] as EService),
      options: (Get.arguments['options'] as List<Option>),
      user: Get.find<AuthService>().user.value,
      coupon: new Coupon(),
    );
    super.onInit();
  }

  void toggleScheduled(value) {
    scheduled.value = value;
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.accentColor;
    }
    return null;
  }

  void createBooking() async {
    try {
      this.booking.value.address = Get.find<AuthService>().address.value;
      await _bookingRepository.add(booking.value);
      Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(1).id;
      if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
        Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(1).id;
      }
      Get.toNamed(Routes.CONFIRMATION);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void validateCoupon() async {
    try {
      Coupon _coupon = await _bookingRepository.coupon(booking.value);
      booking.update((val) {
        val.coupon = _coupon;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String getValidationMessage() {
    if (booking.value.coupon.id == null) {
      return null;
    } else {
      if (booking.value.coupon.id == '') {
        return "Invalid Coupon Code".tr;
      } else {
        return null;
      }
    }
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: booking.value.bookingAt.add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(picked.year, picked.month, picked.day, val.bookingAt.hour, val.bookingAt.minute);
        ;
      });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(booking.value.bookingAt),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      booking.update((val) {
        val.bookingAt = DateTime(booking.value.bookingAt.year, booking.value.bookingAt.month, booking.value.bookingAt.day)
            .add(Duration(minutes: picked.minute + picked.hour * 60));
      });
    }
  }
}
