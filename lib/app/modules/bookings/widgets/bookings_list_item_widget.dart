/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_pages.dart';
import 'booking_options_popup_menu_widget.dart';

class BookingsListItemWidget extends StatelessWidget {
  const BookingsListItemWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel ? Get.theme.focusColor : Get.theme.accentColor;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: _booking.eService.firstImageThumb,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 80,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  ),
                ),
                if (_booking.payment != null)
                  Container(
                    width: 80,
                    child: Text(_booking.payment.paymentStatus?.status ?? '',
                        style: Get.textTheme.caption.merge(
                          TextStyle(fontSize: 10),
                        ),
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  ),
                Container(
                  width: 80,
                  child: Column(
                    children: [
                      Text(DateFormat('HH:mm').format(_booking.bookingAt),
                          maxLines: 1,
                          style: Get.textTheme.bodyText2.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1.4),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('dd').format(_booking.bookingAt),
                          maxLines: 1,
                          style: Get.textTheme.headline3.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('MMM').format(_booking.bookingAt),
                          maxLines: 1,
                          style: Get.textTheme.bodyText2.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Opacity(
                opacity: _booking.cancel ? 0.3 : 1,
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _booking.eService?.name ?? '',
                            style: Get.textTheme.bodyText2,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                        ),
                        BookingOptionsPopupMenuWidget(booking: _booking),
                      ],
                    ),
                    Divider(height: 8, thickness: 1),
                    Row(
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _booking.eProvider.name,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Get.theme.focusColor,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _booking.address.address,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 8, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Total".tr,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Ui.getPrice(
                              _booking.getTotal(),
                              style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
