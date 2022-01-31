import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/auth/local_auth/local_auth.dart';

import 'package:waves/screens/user_type/user_type.dart';

import '../auth/login_page.dart';

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
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final LocalAuthentication localAuthentication = LocalAuthentication();
    AccountType = _prefs.getString('roleType').toString();

    // // ignore: non_constant_identifier_names
    String? faceId = _prefs.getString('faceId');
    bool checkValue = _prefs.containsKey('email');
    print(checkValue);
    print(latitude);
    print(faceId);
    if (checkValue) {
      if (faceId == 'true') {
        bool isAuthenticated =
            await Authentication.authenticateWithBiometrics();
        bool isBiometricSupported =
            await localAuthentication.isDeviceSupported();
        // print(isAuthenticated);
        print(isBiometricSupported);
        // print(faceId);
        if (isAuthenticated && isBiometricSupported) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainPage()));
        } else if (!isBiometricSupported) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometrics does not support!'),
            ),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error authenticating using Biometrics.'),
            ),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const UserType()));
    }
  }

  // Navigator.of(context).pushReplacementNamed(SELECT_ACCOUNT);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
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
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Image.asset('assets/splash_logo.png'),
            ),
          )
        ],
      ),
    );
  }
}
