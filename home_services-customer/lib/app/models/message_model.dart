import 'package:cloud_firestore/cloud_firestore.dart';

import 'parents/model.dart';
import 'user_model.dart';

class Message extends Model {
  String id;

  // conversation name for example chat with market name
  String name;

  // Chats messages
  String lastMessage;

  int lastMessageTime;

  // Ids of users that read the chat message
  List<String> readByUsers;

  // Ids of users in this conversation
  List<String> visibleToUsers;

  // users in the conversation
  List<User> users;

  Message(this.users, {this.id = null, this.name = ''}) {
    visibleToUsers = this.users.map((user) => user.id).toList();
    readByUsers = [];
  }

  Message.fromDocumentSnapshot(DocumentSnapshot jsonMap) {
    try {
      id = jsonMap.id;
      name = jsonMap.get('name') != null ? jsonMap.get('name').toString() : '';
      readByUsers = jsonMap.get('read_by_users') != null ? List.from(jsonMap.get('read_by_users')) : [];
      visibleToUsers = jsonMap.get('visible_to_users') != null ? List.from(jsonMap.get('visible_to_users')) : [];
      lastMessage = jsonMap.get('message') != null ? jsonMap.get('message').toString() : '';
      lastMessageTime = jsonMap.get('time') != null ? jsonMap.get('time') : 0;
      users = jsonMap.get('users') != null
          ? List.from(jsonMap.get('users')).map((element) {
              element['media'] = [
                {'thumb': element['thumb']}
              ];
              return User.fromJson(element);
            }).toList()
          : [];
    } catch (e) {
      id = '';
      name = '';
      readByUsers = [];
      users = [];
      lastMessage = '';
      lastMessageTime = 0;
    }
  }
  @override
  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["users"] = users.map((element) => element.toRestrictMap()).toSet().toList();
    map["visible_to_users"] = users.map((element) => element.id).toSet().toList();
    map["read_by_users"] = readByUsers;
    map["message"] = lastMessage;
    map["time"] = lastMessageTime;
    return map;
  }

  Map toUpdatedMap() {
    var map = new Map<String, dynamic>();
    map["message"] = lastMessage;
    map["time"] = lastMessageTime;
    map["read_by_users"] = readByUsers;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          lastMessage == other.lastMessage &&
          lastMessageTime == other.lastMessageTime &&
          readByUsers == other.readByUsers &&
          visibleToUsers == other.visibleToUsers &&
          users == other.users;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      lastMessage.hashCode ^
      lastMessageTime.hashCode ^
      readByUsers.hashCode ^
      visibleToUsers.hashCode ^
      users.hashCode;
}
