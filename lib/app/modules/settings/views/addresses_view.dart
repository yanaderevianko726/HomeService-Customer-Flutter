import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/auth_service.dart';
import '../controllers/address_controller.dart';

class AddressesView extends GetView<AddressController> {
  final bool hideAppBar;

  AddressesView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "My Addresses".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshAddresses(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: Obx(() {
            return ListView(
              primary: true,
              children: [
                if (controller.addresses.isEmpty) CircularLoadingWidget(height: 300),
                if (controller.addresses.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: Ui.getBoxDecoration(),
                    child: Column(
                      children: List.generate(controller.addresses.length, (index) {
                        var _address = controller.addresses.elementAt(index);
                        return Obx(() {
                          return RadioListTile(
                            value: _address,
                            groupValue: Get.find<AuthService>().address.value,
                            onChanged: (value) {
                              Get.find<AuthService>().address.value = value;
                            },
                            title: Text(_address.description, style: Get.textTheme.bodyText2),
                            subtitle: Text(_address.address, style: Get.textTheme.caption),
                          ).paddingSymmetric(vertical: 10);
                        });
                      }).toList(),
                    ),
                  )
              ],
            );
          }),
        ));
  }
}
