import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sliding_navigation_bar/custom_tab.dart';

const double CIRCLE_SIZE = 100;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 90;
const double CIRCLE_OUTLINE = 10;
const double SHADOW_ALLOWANCE = 20;
const double BAR_HEIGHT = 60;
const int ANIM_DURATION = 300;
double blockSize = 100;

class SlidingNavigationBar extends StatefulWidget {
  SlidingNavigationBar(
      {@required this.tabs,
      @required this.onTabChangedListener,
      this.key,
      this.initialSelection = 0,
      this.circleColor,
      this.activeIconColor,
      this.inactiveIconColor,
      this.textColor,
      this.barBackgroundColor})
      : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length <= 5);

  final Function(int position) onTabChangedListener;
  final Color circleColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;

  final Key key;
  @override
  _SlidingNavigationBar createState() => _SlidingNavigationBar();
}

class _SlidingNavigationBar extends State<SlidingNavigationBar> with TickerProviderStateMixin, RouteAware {

  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = -1;
  double _circleIconAlpha = 1;

  Color circleColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;

  /////////////////
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;

    circleColor = (widget.circleColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);
    blockSize = _circleAlignX * 2;

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  ///////////////////
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          //////////////
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                //borderRadius: Radius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
                ],
              ),
              child: Stack(
                children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: ANIM_DURATION),
                      curve: Curves.easeOut,
                      //curve: Curves.easeInOutQuad,
                      alignment: Alignment(_circleAlignX, 1),
                      child: FractionallySizedBox(
                        widthFactor: 1 / widget.tabs.length,
                        child: GestureDetector(
                          onTap: widget.tabs[currentSelected].onclick,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            //child: CustomPaint(
                              //painter: customBlock(),
                            //),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //////////---------------

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.tabs.map((t) => CustomTab(
                            uniqueKey: t.key,
                            selected: t.key == widget.tabs[currentSelected].key,
                            iconData: t.iconData,
                            title: t.title,
                            iconColor: inactiveIconColor,
                            textColor: textColor,
                            callbackFunction: (uniqueKey) {
                              int selected = widget.tabs.indexWhere((tabData)
                              => tabData.key == uniqueKey);
                              widget.onTabChangedListener(selected);
                              _setSelected(uniqueKey);
                              _initAnimationAndStart(_circleAlignX, 1);
                            }))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          /////////////

        ],
      ),
    );
  }

  _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(Duration(milliseconds: ANIM_DURATION ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(Duration(milliseconds: (ANIM_DURATION ~/ 5 * 3)), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class customBlock extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0
      ..color = Colors.black;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, blockSize, 50), Radius.circular(12)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TabData {
  TabData({@required this.iconData, @required this.title, this.onclick});

  IconData iconData;
  String title;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
