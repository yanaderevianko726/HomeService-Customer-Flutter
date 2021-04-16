import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

  Future<Payment> create(Booking booking) {
    return _laravelApiClient.createPayment(booking);
  }

  String getPayPalUrl(Booking booking) {
    return _laravelApiClient.getPayPalUrl(booking);
  }
}
