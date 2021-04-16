import '../media_model.dart';
import 'model.dart';

abstract class MediaModel extends Model {
  Media media;

  void fromJson(Map<String, dynamic> json) {
    try {
      super.fromJson(json);
      media = json['media'] != null && (json['media'] as List).length > 0 ? Media.fromJson(json['media'][0]) : new Media();
    } catch (e) {
      media = new Media();
      print(e);
    }
  }

  String get mediaUrl {
    if (media != null && Uri.parse(media.url).isAbsolute) {
      return media.url;
    } else {
      return Media().url;
    }
  }

  String get mediaThumb {
    if (media != null && Uri.parse(media.thumb).isAbsolute) {
      return media.thumb;
    } else {
      return Media().thumb;
    }
  }

  String get mediaIcon {
    if (media != null && Uri.parse(media.icon).isAbsolute) {
      return media.icon;
    } else {
      return Media().icon;
    }
  }
}
