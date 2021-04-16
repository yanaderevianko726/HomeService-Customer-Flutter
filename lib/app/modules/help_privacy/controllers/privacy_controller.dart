import 'dart:io';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyController extends GetxController {
  @override
  void onInit() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.onInit();
  }
}
