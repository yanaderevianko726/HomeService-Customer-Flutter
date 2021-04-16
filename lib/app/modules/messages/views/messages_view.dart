import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../../../global_widgets/notifications_button_widget.dart';
import '../controllers/messages_controller.dart';
import '../widgets/message_item_widget.dart';

class MessagesView extends GetView<MessagesController> {
  Widget conversationsList() {
    return Obx(
      () {
        if (controller.messages.isNotEmpty) {
          var _messages = controller.messages;
          return ListView.separated(
              itemCount: _messages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return MessageItemWidget(
                  message: controller.messages.elementAt(index),
                  onDismissed: (conversation) {
                    controller.messages.removeAt(index);
                  },
                );
              });
        } else {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Messages List Empty".tr,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          conversationsList(),
        ],
      ),
    );
  }
}
