import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../services/translation_service.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  final bool hideAppBar;

  LanguageView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Languages".tr,
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
        body: ListView(
          primary: true,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: List.generate(TranslationService.languages.length, (index) {
                  var _lang = TranslationService.languages.elementAt(index);
                  return RadioListTile(
                    value: _lang,
                    groupValue: Get.locale.toString(),
                    onChanged: (value) {
                      controller.updateLocale(value);
                    },
                    title: Text(_lang.tr, style: Get.textTheme.bodyText2),
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }
}
