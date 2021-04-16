import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/auth_service.dart';

class RatingController extends GetxController {
  final booking = Booking().obs;
  final review = new Review(rate: 1).obs;
  BookingRepository _bookingRepository;

  RatingController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    booking.value = Get.arguments as Booking;
    review.value.user = Get.find<AuthService>().user.value;
    review.value.eService = booking.value.eService;
    super.onInit();
  }

  Future addReview() async {
    try {
      await _bookingRepository.addReview(review.value);
      Get.back(closeOverlays: true);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
