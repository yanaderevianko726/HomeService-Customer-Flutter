import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/auth_service.dart';
// import '../repository/notification_repository.dart';

class MessagesController extends GetxController {
  var message = Message([]).obs;
  ChatRepository _chatRepository;
  AuthService _authService;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  final chatTextController = TextEditingController();

  MessagesController() {
    _chatRepository = new ChatRepository();
    _authService = Get.find<AuthService>();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Pet Car Company'));
    await listenForMessages();
    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }

  Future createMessage(Message _message) async {
    _message.users.insert(0, _authService.user.value);
    _message.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    _message.readByUsers = [_authService.user.value.id];

    message.value = _message;

    _chatRepository.createMessage(_message).then((value) {
      listenForChats();
    });
  }

  Future listenForMessages() async {
    _chatRepository.getUserMessages(_authService.user.value.id).listen((event) {
      event.sort((Message a, Message b) {
        return b.lastMessageTime.compareTo(a.lastMessageTime);
      });
      messages.assignAll(event);
    });
  }

  listenForChats() async {
    message.value.readByUsers.add(_authService.user.value.id);
    _chatRepository.getChats(message.value).listen((event) {
      chats.assignAll(event);
    });
  }

  addMessage(Message _message, String text) {
    Chat _chat = new Chat(text, DateTime.now().millisecondsSinceEpoch, _authService.user.value.id);
    if (_message.id == null) {
      _message.id = UniqueKey().toString();
      createMessage(_message);
    }
    _message.lastMessage = text;
    _message.lastMessageTime = _chat.time;
    _message.readByUsers = [_authService.user.value.id];
    _chatRepository.addMessage(_message, _chat).then((value) {
      _message.users.forEach((_user) {
        if (_user.id != _authService.user.value.id) {
          //sendNotification(text, "New Message From".tr + " " + _authService.user.value.name, _user);
        }
      });
    });
  }
}
