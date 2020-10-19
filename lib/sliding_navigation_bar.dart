import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sliding_navigation_bar/custom_tab.dart';

const int ANIM_DURATION = 300;
double blockSize = 100;
Color blockColorGlobal;

class SlidingNavigationBar extends StatefulWidget {
  SlidingNavigationBar(
      {@required this.tabs,
      @required this.onTabChangedListener,
      this.key,
      this.initialSelection = 0,
      this.activeIconColor,
      this.inactiveIconColor,
      this.textColor,
      this.blockColor,
      this.barBackgroundColor})
      : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 6);

  final Function(int position) onTabChangedListener;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color textColor;
  final Color blockColor;
  final Color barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;

  final Key key;
  @override
  _SlidingNavigationBar createState() => _SlidingNavigationBar();
}

class _SlidingNavigationBar extends State<SlidingNavigationBar>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _blockAlignX = -1;

  Color blockColor;
  Color activeIconColor;
  Color inactiveIconColor;
  Color barBackgroundColor;
  Color textColor;

  /////////////////
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;

    blockColor = (widget.blockColor == null) ? Colors.black : widget.blockColor;
    blockColorGlobal = blockColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor);
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
    blockSize = _blockAlignX * 2;

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _blockAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  ///////////////////
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        //////////////
        Container(
          height: 72,
          decoration: BoxDecoration(
            color: barBackgroundColor,
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
                  alignment: Alignment(_blockAlignX, 1),
                  child: FractionallySizedBox(
                    widthFactor: 1 / widget.tabs.length,
                    child: GestureDetector(
                      onTap: widget.tabs[currentSelected].onclick,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: blockColor,
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
                children: widget.tabs
                    .map((t) => CustomTab(
                        uniqueKey: t.key,
                        selected: t.key == widget.tabs[currentSelected].key,
                        iconData: t.iconData,
                        title: (t.title == null) ? '' : t.title,
                        iconColorActive: activeIconColor,
                        iconColorInactive: inactiveIconColor,
                        textColor: textColor,
                        callbackFunction: (uniqueKey) {
                          int selected = widget.tabs.indexWhere(
                              (tabData) => tabData.key == uniqueKey);
                          widget.onTabChangedListener(selected);
                          _setSelected(uniqueKey);
                        }))
                    .toList(),
              ),
            ],
          ),
        ),
        /////////////
      ],
    );
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);

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
      ..color = blockColorGlobal;

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
  TabData({
    @required this.iconData,
    this.title,
    this.onclick,
  });
  IconData iconData;
  String title;
  Function onclick;
  final UniqueKey key = UniqueKey();
}
