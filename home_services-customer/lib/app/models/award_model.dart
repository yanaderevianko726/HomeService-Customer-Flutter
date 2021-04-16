/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'parents/model.dart';

class Award extends Model {
  String id;
  String title;
  String description;

  Award({this.id, this.title, this.description});

  Award.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = stringFromJson(json, 'title');
    description = stringFromJson(json, 'description');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
