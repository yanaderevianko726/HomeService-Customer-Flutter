/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'media_model.dart';
import 'parents/model.dart';

class Gallery extends Model {
  String id;
  Media image;
  String description;

  Gallery({this.id, this.image, this.description});

  Gallery.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    image = mediaFromJson(json, 'image');
    description = stringFromJson(json, 'description');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}
