/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../bookings/widgets/booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: Ui.getBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: _booking.eService.firstImageUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Obx(() {
              return Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        _booking.eService.name ?? '',
                        style: Get.textTheme.bodyText2,
                        maxLines: 3,
                        // textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Divider(height: 8, thickness: 1),
                  BookingRowWidget(
                    description: "Tax Amount".tr,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Ui.getPrice(_booking.getTaxesValue(), style: Get.textTheme.subtitle2),
                    ),
                  ),
                  BookingRowWidget(
                    description: "Subtotal".tr,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Ui.getPrice(_booking.getSubtotal(), style: Get.textTheme.subtitle2),
                    ),
                  ),
                  if ((_booking.coupon?.discount ?? 0) > 0)
                    BookingRowWidget(
                      description: "Coupon".tr,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          children: [
                            Text(' - ', style: Get.textTheme.bodyText1),
                            Ui.getPrice(_booking.coupon?.discount ?? 0,
                                style: Get.textTheme.bodyText1, unit: _booking.coupon.discountType == 'percent' ? "%" : null),
                          ],
                        ),
                      ),
                      hasDivider: false,
                    ),
                  BookingRowWidget(
                    description: "Total Amount".tr,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Ui.getPrice(_booking.getTotal(), style: Get.textTheme.headline6),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
