import 'parents/model.dart';

class FaqCategory extends Model {
  String id;
  String name;

  FaqCategory({this.id, this.name});

  FaqCategory.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, 'name');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
