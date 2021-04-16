import 'media_model.dart';
import 'parents/model.dart';

class PaymentMethod extends Model {
  String id;
  String name;
  String description;
  Media logo;
  String route;
  int order;
  bool isDefault;

  PaymentMethod({this.id, this.name, this.description, this.route, this.logo, this.isDefault = false});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, 'name');
    description = stringFromJson(json, 'description');
    route = stringFromJson(json, 'route');
    logo = mediaFromJson(json, 'logo');
    order = intFromJson(json, 'order');
    isDefault = boolFromJson(json, 'default');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
