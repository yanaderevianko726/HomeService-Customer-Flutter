import 'parents/model.dart';

class Coupon extends Model {
  String id;
  String code;
  double discount;
  String discountType;

  Coupon({this.id, this.code, this.discount, this.discountType});

  Coupon.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    code = stringFromJson(json, 'code');
    discount = doubleFromJson(json, 'discount');
    discountType = stringFromJson(json, 'discount_type');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    return data;
  }
}
