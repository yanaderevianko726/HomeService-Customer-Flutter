import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/payment_model.dart';
import '../../../repositories/payment_repository.dart';

class CheckoutController extends GetxController {
  PaymentRepository _paymentRepository;
  final paymentsList = <PaymentMethod>[].obs;
  Rx<PaymentMethod> selectedPaymentMethod = new PaymentMethod().obs;

  CheckoutController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    await loadPaymentMethodsList();
    selectedPaymentMethod.value = this.paymentsList.firstWhere((element) => element.isDefault);
    super.onInit();
  }

  Future loadPaymentMethodsList() async {
    try {
      paymentsList.assignAll(await _paymentRepository.getMethods());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  void payBooking(Booking _booking) async {
    try {
      _booking.payment = new Payment(paymentMethod: selectedPaymentMethod.value);
      if (selectedPaymentMethod.value.route != null) {
        Get.toNamed(selectedPaymentMethod.value.route.toLowerCase(), arguments: Booking(id: _booking.id, payment: _booking.payment));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.caption;
  }

  Color getColor(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.accentColor;
    }
    return null;
  }
}
