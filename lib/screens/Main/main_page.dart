import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/TYPE/bussiness_type/home/homePage_bussiness.dart';
import 'package:waves/screens/TYPE/bussiness_type/map/map_screen_bussiness.dart';
import 'package:waves/screens/TYPE/bussiness_type/profile/profile_screen_Bussiness.dart';
import 'package:waves/screens/TYPE/regular_type/activity/activity_screen.dart';
import 'package:waves/screens/TYPE/regular_type/home/home.dart';
import 'package:waves/screens/TYPE/regular_type/map/map_screen.dart';
import 'package:waves/screens/notification/notification_screen.dart';
import 'package:waves/screens/profile/profile.dart';

class MainPage extends StatefulWidget {
  final int selectPage;

  const MainPage(this.selectPage, {Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedpage = 0;
  @override
  void initState() {
    selectedpage = widget.selectPage;
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NotificationScreen()));
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return MaterialApp(
        //         home: Scaffold(
        //           body: AlertDialog(
        //             title: Text(notification.title!),
        //             content: SingleChildScrollView(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [Text(notification.body!)],
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     });
      }
    });
  }

  final _children = (AccountType == 'REGULAR')
      ? const [
          HomePage(),
          MapScreenBussiness(),
          ActivityScreen(),
          MyProfileScreen()
        ]
      : const [
          HomeBussiness(),
          MapScreenBussiness(),
          MyProfileBussinessScreen()
        ];
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
