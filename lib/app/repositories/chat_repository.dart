import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
//  User _userFromFirebaseUser(User user) {
//    return user != null ? User(uid: user.uid) : null;
//  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String token) async {
    return FirebaseFirestore.instance.collection("users").where("token", isEqualTo: token).get().catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection("users").where('userName', isEqualTo: searchField).get();
  }

  // Create Message
  Future<void> createMessage(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).set(message.toJson()).catchError((e) {
      print(e);
    });
  }

  Stream<List<Message>> getUserMessages(String userId) {
    return FirebaseFirestore.instance.collection("messages").where('visible_to_users', arrayContains: userId).snapshots().map((QuerySnapshot query) {
      List<Message> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Message.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<Chat>> getChats(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").orderBy('time', descending: true).snapshots().map((QuerySnapshot query) {
      List<Chat> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Chat.fromDocumentSnapshot(element));
      });
      return retVal;
    });
    // return updateMessage(message.id, {'read_by_users': message.readByUsers}).then((value) async {
    //
    // });
  }

  Future<void> addMessage(Message message, Chat chat) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").add(chat.toJson()).whenComplete(() {
      updateMessage(message.id, message.toUpdatedMap());
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> message) {
    return FirebaseFirestore.instance.collection("messages").doc(messageId).update(message).catchError((e) {
      print(e.toString());
    });
  }
}
