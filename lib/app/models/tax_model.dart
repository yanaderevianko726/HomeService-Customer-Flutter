import 'parents/model.dart';

class Tax extends Model {
  String id;
  String name;
  String type;
  double value;

  Tax(this.id, this.name, this.type, this.value);

  Tax.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, 'name');
    type = stringFromJson(json, 'type');
    value = doubleFromJson(json, 'value');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
