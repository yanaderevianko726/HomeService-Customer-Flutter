import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_services_controller.dart';
import 'services_list_item_widget.dart';

class ServicesListWidget extends GetView<EServicesController> {
  ServicesListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.eServices.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eServices.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.eServices.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _service = controller.eServices.elementAt(index);
              return ServicesListItemWidget(service: _service);
            }
          }),
        );
      }
    });
  }
}
