import 'parents/model.dart';
import 'payment_method_model.dart';
import 'payment_status_model.dart';

class Payment extends Model {
  String id;
  String description;
  double amount;
  PaymentMethod paymentMethod;
  PaymentStatus paymentStatus;

  Payment({this.id, this.description, this.amount, this.paymentMethod, this.paymentStatus});

  Payment.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = stringFromJson(json, 'description');
    amount = doubleFromJson(json, 'amount');
    paymentMethod = objectFromJson(json, 'payment_method', (v) => PaymentMethod.fromJson(v));
    paymentStatus = objectFromJson(json, 'payment_status', (v) => PaymentStatus.fromJson(v));
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['amount'] = this.amount;
    if (paymentMethod != null) {
      data['payment_method_id'] = this.paymentMethod.id;
    }
    if (paymentStatus != null) {
      data['payment_status_id'] = this.paymentStatus.id;
    }
    return data;
  }
}
