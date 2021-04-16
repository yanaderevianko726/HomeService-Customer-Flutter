import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingRowWidget extends StatelessWidget {
  const BookingRowWidget({
    Key key,
    @required this.description,
    this.value,
    this.valueStyle,
    this.hasDivider,
    this.child,
  }) : super(key: key);

  final String description;
  final String value;
  final Widget child;
  final TextStyle valueStyle;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                this.description,
                style: Get.textTheme.bodyText1,
              ),
            ),
            Expanded(
                flex: 2,
                child: child ??
                    Text(
                      value,
                      style: valueStyle ?? Get.textTheme.bodyText2,
                      maxLines: 3,
                      textAlign: TextAlign.end,
                    )),
          ],
        ),
        if (hasDivider != null && hasDivider) Divider(thickness: 1, height: 25),
        if (hasDivider != null && !hasDivider) SizedBox(height: 6),
      ],
    );
  }
}
