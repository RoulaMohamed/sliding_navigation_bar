import 'package:flutter/material.dart';
import 'package:sliding_navigation_bar/sliding_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      bottomNavigationBar: SlidingNavigationBar(
        inactiveIconColor: Colors.black,
        activeIconColor: Colors.white,
        tabs: [
          TabData(iconData: Icons.perm_identity, title: "", ),
          TabData(iconData: Icons.search, title: ""),
          TabData(iconData: Icons.add, title: ""),
          TabData(iconData: Icons.shopping_cart, title: ""),
          TabData(iconData: Icons.settings, title: "")
        ],
        onTabChangedListener: (position) {
          setState(() {

          });
        },
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
