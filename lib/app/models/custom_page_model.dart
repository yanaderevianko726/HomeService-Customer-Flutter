import 'parents/model.dart';

class CustomPage extends Model {
  String id;
  String title;
  String content;
  DateTime updatedAt;

  CustomPage({this.id, this.title, this.content, this.updatedAt});

  CustomPage.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = stringFromJson(json, 'title');
    content = stringFromJson(json, 'content');
    updatedAt = dateFromJson(json, 'updated_at');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CustomPage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ title.hashCode ^ content.hashCode ^ updatedAt.hashCode;
}
