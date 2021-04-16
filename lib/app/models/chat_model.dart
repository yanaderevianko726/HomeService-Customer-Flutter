import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import "parents/model.dart";
import 'user_model.dart';

class Chat extends Model {
  String id = UniqueKey().toString();
  // message text
  String text;
  // time of the message
  int time;
  // user id who send the message
  String userId;

  User user;

  Chat(this.text, this.time, this.userId);

  Chat.fromDocumentSnapshot(DocumentSnapshot jsonMap) {
    try {
      id = jsonMap.id;
      text = jsonMap.get('text') != null ? jsonMap.get('text').toString() : '';
      time = jsonMap.get('time') != null ? jsonMap.get('time') : 0;
      userId = jsonMap.get('user') != null ? jsonMap.get('user').toString() : null;
    } catch (e) {
      id = null;
      text = '';
      time = 0;
      user = null;
      userId = null;
      print(e);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["text"] = text;
    map["time"] = time;
    map["user"] = userId;
    return map;
  }
}
