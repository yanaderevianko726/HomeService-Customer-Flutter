import 'package:flutter/material.dart';

const Color PRIMARY_COLOR = Colors.blueAccent;
const Color BACKGROUND_COLOR = Color(0xffE2E7F2);

class CustomBottomNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;

  CustomBottomNavigationBar({this.backgroundColor = BACKGROUND_COLOR, this.itemColor = PRIMARY_COLOR, this.currentIndex = 0, @required this.children, this.onChange});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    if (widget.onChange != null) {
      widget.onChange(index);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.children.map((item) {
          var color = item.color ?? widget.itemColor;
          var icon = item.icon;
          var label = item.label;
          int index = widget.children.indexOf(item);
          return GestureDetector(
            onTap: () {
              _changeIndex(index);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: widget.currentIndex == index ? MediaQuery.of(context).size.width / widget.children.length + 20 : 50,
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: widget.currentIndex == index ? color.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 24,
                    color: widget.currentIndex == index ? color : color.withOpacity(0.5),
                  ),
                  widget.currentIndex == index
                      ? Expanded(
                          flex: 2,
                          child: Text(
                            label ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: widget.currentIndex == index ? color : color.withOpacity(0.5)),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  CustomBottomNavigationItem({@required this.icon, @required this.label, this.color});
}
