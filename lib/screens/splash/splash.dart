import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
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
  late AnimationController _controller;
  late Animation<double> _animation;
  final LocalAuthentication auth = LocalAuthentication();
  startTime() async {
    var _duration = const Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final LocalAuthentication localAuthentication = LocalAuthentication();

    String? faceId = _prefs.getString(Prefs.faceId);
    bool checkValue = _prefs.containsKey(Prefs.email);
    String? type = _prefs.getString(Prefs.roleType);
    if (checkValue) {
      AccountType = _prefs.getString(Prefs.roleType).toString();
      email = _prefs.getString(Prefs.email)!;
      user_id = _prefs.getString(Prefs.userId)!;
      AccountType = _prefs.getString(Prefs.roleType)!;
      name = _prefs.getString(Prefs.name)!;
      authorization = _prefs.getString(Prefs.accessToken)!;
      mobile = _prefs.getString(Prefs.mobile)!;
      profileimg = _prefs.getString(Prefs.avatar)!;
      if (type == 'REGULAR') {
        age = _prefs.getString(Prefs.age)!;
        dateOfBirth = _prefs.getString(Prefs.dob);
      }

      isBiometric = _prefs.getString(Prefs.faceId)!;
      bio = _prefs.getString(Prefs.bio)!;
      address = _prefs.getString(Prefs.address)!;
      latitude = _prefs.getDouble(Prefs.latitude)!;
      longitude = _prefs.getDouble(Prefs.longitude)!;
      if (faceId == 'true') {
        // bool isAuthenticated =
        //     await Authentication.authenticateWithBiometrics();
        bool hasbiometrics = await auth.canCheckBiometrics;

        //check if there is authencations,
        if (hasbiometrics) {
          List<BiometricType> availableBiometrics =
              await auth.getAvailableBiometrics();
          print(hasbiometrics);
          print(availableBiometrics);
          bool isBiometricSupported =
              await localAuthentication.isDeviceSupported();
          bool pass = await auth.authenticate(
              localizedReason: 'Authenticate with pattern/pin/passcode',
              biometricOnly: false);

          if (availableBiometrics.contains(BiometricType.face) &&
              Platform.isIOS) {
            bool pass = await auth.authenticate(
                localizedReason: 'Authenticate with fingerprint',
                biometricOnly: true);
            if (pass) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainPage(0)));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          } else if (pass) {
            // bool pass = await auth.authenticate(
            //     localizedReason: 'Authenticate with fingerprint/face',
            //     biometricOnly: true);
            // if (pass) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainPage(0)));
            // }
            // } else if (isAuthenticated && isBiometricSupported) {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => const MainPage(0)));
            // }
            //  else if (pass) {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (context) => const MainPage(0)));
          } else if (!isBiometricSupported) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometrics does not support!'),
              ),
            );
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error authenticating using Biometrics.'),
            ),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainPage(0)));
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
              child: Center(child: Image.asset('assets/splash_logo.png')))
        ],
      ),
    );
  }
}
