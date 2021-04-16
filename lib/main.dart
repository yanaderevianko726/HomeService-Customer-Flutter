import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/providers/laravel_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';

void initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => GlobalService().init());
  // await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => SettingsService().init());
  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp fbApp = await Firebase.initializeApp (
    name: 'HomeService',
    options: Platform.isIOS || Platform.isMacOS ?
    FirebaseOptions(
      appId: '1:961455465391:ios:9c66b1f686a4313984455a',
      apiKey: 'AIzaSyCFRBy41IbNaeOYZUltCd8ke29kjCxI4fw',
      projectId: 'homeservice-4ef60',
      messagingSenderId: '961455465391',
      databaseURL: 'https://homeservice-4ef60-default-rtdb.firebaseio.com/',
    ) :
    FirebaseOptions(
      appId: '1:961455465391:android:28ded16b554da65384455a',
      apiKey: 'AIzaSyCFRBy41IbNaeOYZUltCd8ke29kjCxI4fw',
      projectId: 'homeservice-4ef60',
      messagingSenderId: '961455465391',
      databaseURL: 'https://homeservice-4ef60-default-rtdb.firebaseio.com/',
    ),
  );

  await initServices();

  runApp(
    GetMaterialApp(
      title: Get.find<SettingsService>().setting.value.appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<SettingsService>().getLocale(),
      fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      //Get.find<SettingsService>().getLightTheme.value,
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  );
}
