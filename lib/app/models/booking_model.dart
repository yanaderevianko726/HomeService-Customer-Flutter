import 'address_model.dart';
import 'booking_status_model.dart';
import 'coupon_model.dart';
import 'e_provider_model.dart';
import 'e_service_model.dart';
import 'option_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Booking extends Model {
  String id;
  String hint;
  bool cancel;
  double duration;
  BookingStatus status;
  User user;
  EService eService;
  EProvider eProvider;
  List<Option> options;
  List<Tax> taxes;
  Address address;
  Coupon coupon;
  DateTime bookingAt;
  DateTime startAt;
  DateTime endsAt;
  Payment payment;

  Booking(
      {this.id,
      this.hint,
      this.cancel,
      this.duration,
      this.status,
      this.user,
      this.eService,
      this.eProvider,
      this.options,
      this.taxes,
      this.address,
      this.coupon,
      this.bookingAt,
      this.startAt,
      this.endsAt,
      this.payment});

  Booking.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    hint = stringFromJson(json, 'hint');
    cancel = boolFromJson(json, 'cancel');
    duration = doubleFromJson(json, 'duration');
    status = objectFromJson(json, 'booking_status', (v) => BookingStatus.fromJson(v));
    user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    eService = objectFromJson(json, 'e_service', (v) => EService.fromJson(v));
    eProvider = objectFromJson(json, 'e_provider', (v) => EProvider.fromJson(v));
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    coupon = objectFromJson(json, 'coupon', (v) => Coupon.fromJson(v));
    payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    options = listFromJson(json, 'options', (v) => Option.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    bookingAt = dateFromJson(json, 'booking_at', defaultValue: null);
    startAt = dateFromJson(json, 'start_at', defaultValue: null);
    endsAt = dateFromJson(json, 'ends_at', defaultValue: null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.hint != null) {
      data['hint'] = this.hint;
    }
    if (this.duration != null) {
      data['duration'] = this.duration;
    }
    if (this.cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this.status != null) {
      data['booking_status_id'] = this.status.id;
    }
    if (this.coupon != null && this.coupon.code != null) {
      data['coupon'] = this.coupon.toJson();
    }
    if (this.coupon != null && this.coupon.id != null) {
      data['coupon_id'] = this.coupon.id;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this.options != null && this.options.isNotEmpty) {
      data['options'] = this.options.map((e) => e.id).toList();
    }
    if (this.user != null) {
      data['user_id'] = this.user.id;
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.eService != null) {
      data['e_service'] = this.eService.id;
    }
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.bookingAt != null) {
      data['booking_at'] = bookingAt.toString();
    }
    if (this.startAt != null) {
      data['start_at'] = startAt.toString();
    }
    if (this.endsAt != null) {
      data['ends_at'] = endsAt.toString();
    }
    return data;
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    total += getCouponValue();
    return total;
  }

  double getTaxesValue() {
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getCouponValue() {
    double total = getSubtotal();
    if (coupon == null && !coupon.hasData) {
      return 0;
    } else {
      if (coupon.discountType == 'percent') {
        return -(total * coupon.discount / 100);
      } else {
        return -coupon.discount;
      }
    }
  }

  double getSubtotal() {
    double total = 0.0;
    if (eService.priceUnit == 'fixed') {
      total = eService.getPrice;
    } else {
      total = eService.getPrice * duration;
    }
    options.forEach((element) {
      total += element.price;
    });
    return total;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hint == other.hint &&
          cancel == other.cancel &&
          duration == other.duration &&
          status == other.status &&
          user == other.user &&
          eService == other.eService &&
          eProvider == other.eProvider &&
          options == other.options &&
          taxes == other.taxes &&
          address == other.address &&
          coupon == other.coupon &&
          bookingAt == other.bookingAt &&
          startAt == other.startAt &&
          endsAt == other.endsAt &&
          payment == other.payment;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      duration.hashCode ^
      status.hashCode ^
      user.hashCode ^
      eService.hashCode ^
      eProvider.hashCode ^
      options.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      bookingAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode;
}
