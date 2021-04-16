/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../controllers/e_service_controller.dart';

class OptionItemWidget extends GetWidget<EServiceController> {
  OptionItemWidget({
    @required Option option,
    @required OptionGroup optionGroup,
  })  : _option = option,
        _optionGroup = optionGroup;

  final Option _option;
  final OptionGroup _optionGroup;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          controller.selectOption(_optionGroup, _option);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: Ui.getBoxDecoration(color: controller.getColor(_option), radius: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 54,
                      width: 54,
                      fit: BoxFit.cover,
                      imageUrl: _option.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        height: 54,
                        width: 54,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).accentColor.withOpacity(_option.checked.value ? 0.8 : 0),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 36,
                      color: Theme.of(context).primaryColor.withOpacity(_option.checked.value ? 1 : 0),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_option.name, style: controller.getTitleTheme(_option)).paddingOnly(bottom: 5),
                          Ui.applyHtml(_option.description, style: controller.getSubTitleTheme(_option)),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Ui.getPrice(
                      _option.price,
                      style: Get.textTheme.headline6.merge(TextStyle(color: _option.checked.value ? Get.theme.accentColor : Get.theme.hintColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
