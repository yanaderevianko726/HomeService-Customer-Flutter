import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailabilityHourItemWidget extends StatelessWidget {
  const AvailabilityHourItemWidget({
    Key key,
    @required MapEntry<String, List<String>> availabilityHour,
    @required List<String> data,
  })  : _availabilityHour = availabilityHour,
        _data = data,
        super(key: key);

  final MapEntry<String, List<String>> _availabilityHour;
  final List<String> _data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
                  Text(_availabilityHour.key.tr.capitalizeFirst).paddingSymmetric(vertical: 5),
                ] +
                List.generate(_data.length, (index) {
                  return Text(
                    _data.elementAt(index),
                    style: Get.textTheme.caption,
                  );
                }),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        Column(
          children: List.generate(_availabilityHour.value.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              width: 110,
              child: Text(
                _availabilityHour.value.elementAt(index),
                style: Get.textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            );
          }),
          //mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}
