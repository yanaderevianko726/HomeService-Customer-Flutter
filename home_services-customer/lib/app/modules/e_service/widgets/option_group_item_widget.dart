/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/option_group_model.dart';
import '../controllers/e_service_controller.dart';
import 'option_item_widget.dart';

class OptionGroupItemWidget extends GetWidget<EServiceController> {
  OptionGroupItemWidget({
    @required OptionGroup optionGroup,
  }) : _optionGroup = optionGroup;

  final OptionGroup _optionGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: [
            Icon(
              Icons.create_new_folder_outlined,
              color: Get.theme.hintColor,
            ),
            Text(
              _optionGroup.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.headline5,
            ),
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 10),
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero,
          itemCount: _optionGroup.options.length,
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemBuilder: (context, index) {
            var _option = _optionGroup.options.elementAt(index);
            return OptionItemWidget(option: _option, optionGroup: _optionGroup);
          },
        ),
      ],
    );
  }
}
