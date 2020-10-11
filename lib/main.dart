import 'package:flutter/material.dart';
import 'package:sliding_navigation_bar/custom_tab.dart';
import 'package:sliding_navigation_bar/sliding_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BottomNavigationBar Package',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'HomePage'),
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
        barBackgroundColor: Colors.grey[100],
        inactiveIconColor: Colors.black,
        activeIconColor: Colors.deepOrange,
        tabs: [
          TabData(iconData: Icons.perm_identity),
          TabData(iconData: Icons.search),
          TabData(iconData: Icons.add),
          TabData(iconData: Icons.shopping_cart),
          TabData(iconData: Icons.settings)
        ],
        onTabChangedListener: (position) {
          setState(() {});
        },
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
