import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';

class AddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SETTINGS_ADDRESSES);
                },
                child: Text(Get.find<AuthService>().address.value?.address ?? "Loading...".tr, style: Get.textTheme.bodyText1),
              );
            }),
          ),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: () async {
                LocationResult result = await showLocationPicker(context, Get.find<SettingsService>().setting.value.googleMapsKey,
                    initialCenter: Get.find<AuthService>().address.value.getLatLng(),
                    automaticallyAnimateToCurrentLocation: false,
                    myLocationButtonEnabled: true,
                    layersButtonEnabled: true,
                    language: Get.locale.languageCode,
                    desiredAccuracy: LocationAccuracy.best,
                    appBarColor: Get.theme.primaryColor);
                print("result = $result");
                Get.find<AuthService>().address.update((val) {
                  val.address = result?.address;
                  val.latitude = result?.latLng?.latitude;
                  val.longitude = result?.latLng?.longitude;
                  val.userId = Get.find<AuthService>().user.value.id;
                });
              })
        ],
      ),
    );
  }
}
