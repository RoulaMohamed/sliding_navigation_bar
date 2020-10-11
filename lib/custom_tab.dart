import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  CustomTab({
    @required this.uniqueKey,
    @required this.selected,
    @required this.iconData,
    @required this.title,
    @required this.callbackFunction,
    @required this.textColor,
    @required this.iconColorActive,
    @required this.iconColorInactive,
  });

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final bool selected;
  final Function(UniqueKey uniqueKey) callbackFunction;
  final Color textColor;
  final Color iconColorActive;
  final Color iconColorInactive;

  Animation<Color> animation;
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    //AnimationController _animationController;

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    padding: EdgeInsets.all(12.0),
                    curve: Curves.easeInCubic,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedAlign(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                          alignment: Alignment((selected) ? 3 : 0, 0),
                          child: Row(
                            children: <Widget>[
                              (!selected)
                                  ? AnimatedOpacity(
                                      duration: Duration(milliseconds: 200),
                                      opacity: (selected) ? 0 : 1,
                                      child: IconButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment(0, 0),
                                        icon: Icon(
                                          iconData,
                                          color: iconColorInactive,
                                        ),
                                        onPressed: () {
                                          callbackFunction(uniqueKey);
                                        },
                                      ), // ),
                                    )
                                  : Container(),
                              (selected)
                                  ? Row(
                                      children: <Widget>[
                                        IconButton(
                                          padding: EdgeInsets.all(0),
                                          alignment: Alignment(0, 0),
                                          icon: Icon(
                                            iconData,
                                            color: iconColorActive,
                                          ),
                                          onPressed: () {
                                            callbackFunction(uniqueKey);
                                          },
                                        ),
                                        Text(
                                          title,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
