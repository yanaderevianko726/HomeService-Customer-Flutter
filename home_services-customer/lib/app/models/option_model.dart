import 'package:get/get.dart';

import 'media_model.dart';
import 'parents/model.dart';

class Option extends Model {
  String id;
  String optionGroupId;
  String eServiceId;
  String name;
  double price;
  Media image;
  String description;
  var checked = false.obs;

  Option({this.id, this.optionGroupId, this.eServiceId, this.name, this.price, this.image, this.description, this.checked});

  Option.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    optionGroupId = stringFromJson(json, 'option_group_id', defaultValue: '0');
    eServiceId = stringFromJson(json, 'e_service_id', defaultValue: '0');
    name = stringFromJson(json, 'name');
    price = doubleFromJson(json, 'price');
    description = stringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    map["checked"] = checked.value;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
