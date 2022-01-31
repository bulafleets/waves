import 'package:flutter/material.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/TYPE/bussiness_type/home/homePage_bussiness.dart';
import 'package:waves/screens/TYPE/bussiness_type/map/map_screen_bussiness.dart';
import 'package:waves/screens/TYPE/regular_type/activity/activity_screen.dart';
import 'package:waves/screens/TYPE/regular_type/home/home.dart';
import 'package:waves/screens/TYPE/regular_type/map/map_screen.dart';
import 'package:waves/screens/profile/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedpage = 0;

  final _children = (AccountType == 'REGULAR')
      ? const [
          HomePage(),
          MapScreenBussiness(),
          ActivityScreen(),
          MyProfileScreen()
        ]
      : const [HomeBussiness(), MapScreenBussiness(), MyProfileScreen()];
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
        unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 30),
        currentIndex: selectedpage,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 's',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 's',
          ),
          if (AccountType == 'REGULAR')
            const BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 's',
            ),
          const BottomNavigationBarItem(
            label: 's',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
