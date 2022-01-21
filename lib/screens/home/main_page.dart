import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/screens/activity/activity_screen.dart';
import 'package:waves/screens/home/home.dart';
import 'package:waves/screens/map/map_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedpage = 0;
  final _children = const [HomePage(), MapScreen(), Scaffold(), Scaffold()];
  void _selectPage(int index) {
    setState(() {
      selectedpage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[selectedpage],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 18,
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).primaryColor, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.grey, size: 30),
        currentIndex: selectedpage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 's',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 's',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 's',
          ),
          BottomNavigationBarItem(
            label: 's',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
