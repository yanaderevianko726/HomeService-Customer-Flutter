import 'option_model.dart';
import 'parents/model.dart';

class OptionGroup extends Model {
  String id;
  String name;
  bool allowMultiple;
  List<Option> options;

  OptionGroup({this.id, this.name, this.options});

  OptionGroup.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, 'name');
    allowMultiple = boolFromJson(json, 'allow_multiple');
    options = listFromJson(json, 'options', (v) => Option.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["allow_multiple"] = allowMultiple;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
