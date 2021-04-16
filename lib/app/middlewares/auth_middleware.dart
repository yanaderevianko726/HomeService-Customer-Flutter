import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings redirect(String route) {
    final authService = Get.find<AuthService>();
    if (!authService.isAuth) {
      return RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
