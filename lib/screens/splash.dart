import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/add_friends.dart';
import 'package:waves/screens/create_profile.dart';
import 'package:waves/screens/homePage.dart';
import 'package:waves/screens/user_type.dart';
import 'package:waves/widget/login.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  late double _height;
  late double _width;
  late AnimationController _controller;
  late Animation<double> _animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    // SharedPreferences _prefs = await SharedPreferences.getInstance();
    // // ignore: non_constant_identifier_names
    // bool CheckValue = _prefs.containsKey('email');
    // print(CheckValue);
    // if (CheckValue) {
    //   // name = _prefs.getString('name')!;
    //   email = _prefs.getString('email')!;
    //   user_id = _prefs.getString('user_id')!;
    //   // AccountType = _prefs.getString('role')!;
    //   authorization = _prefs.getString('token')!;
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => MyHomePage()));
    // } else {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) => UserType()));
    // }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserType()));
  }
  // Navigator.of(context).pushReplacementNamed(SELECT_ACCOUNT);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/splash.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          // Container(
          //   decoration: BoxDecoration(
          //       color: Color.fromRGBO(42, 124, 202, 1),
          //       gradient: LinearGradient(
          //         begin: Alignment.topRight,
          //         end: Alignment.bottomLeft,
          //         colors: [
          //           Color.fromRGBO(42, 124, 202, 1),
          //           Color.fromRGBO(0, 68, 255, 1),
          //         ],
          //       )),
          // ),
        ],
      ),
    );
  }
}
