import 'e_service_model.dart';
import 'option_model.dart';
import 'parents/model.dart';

class Favorite extends Model {
  String id;
  EService eService;
  List<Option> options;
  String userId;

  Favorite({this.id, this.eService, this.options, this.userId});

  Favorite.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    eService = objectFromJson(json, 'e_service', (v) => EService.fromJson(v));
    options = listFromJson(json, 'options', (v) => Option.fromJson(v));
    userId = stringFromJson(json, 'user_id');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["e_service_id"] = eService.id;
    map["user_id"] = userId;
    if (options is List<Option>) {
      map["options"] = options.map((element) => element.id).toList();
    }
    return map;
  }
}
