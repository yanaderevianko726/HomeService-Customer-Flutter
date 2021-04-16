/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/payment_method_model.dart';
import '../controllers/checkout_controller.dart';

class PaymentMethodItemWidget extends GetWidget<CheckoutController> {
  PaymentMethodItemWidget({
    @required PaymentMethod paymentMethod,
  }) : _paymentMethod = paymentMethod;

  final PaymentMethod _paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: Ui.getBoxDecoration(color: controller.getColor(_paymentMethod)),
        child: Theme(
          data: ThemeData(
            toggleableActiveColor: Get.theme.primaryColor,
          ),
          child: RadioListTile(
              value: _paymentMethod,
              groupValue: controller.selectedPaymentMethod.value,
              onChanged: (value) {
                controller.selectPaymentMethod(value);
              },
              title: Text(_paymentMethod.name, style: controller.getTitleTheme(_paymentMethod)).paddingOnly(bottom: 5),
              subtitle: Text(_paymentMethod.description, style: controller.getSubTitleTheme(_paymentMethod)),
              secondary: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: _paymentMethod.logo.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              )),
        ),
      );
    });
  }
}
