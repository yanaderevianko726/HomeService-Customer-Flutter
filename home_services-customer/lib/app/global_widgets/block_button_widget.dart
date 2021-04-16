import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({Key key, @required this.color, @required this.text, @required this.onPressed}) : super(key: key);

  final Color color;
  final Widget text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: this.color.withOpacity(0.3), blurRadius: 40, offset: Offset(0, 15)),
          BoxShadow(color: this.color.withOpacity(0.2), blurRadius: 13, offset: Offset(0, 3))
        ],
        // borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: this.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: this.text,
        elevation: 0,
      ),
    );
  }
}
