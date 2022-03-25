import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/screens/auth/login_page.dart';

class ShowDialogSignOutScreen extends StatefulWidget {
  const ShowDialogSignOutScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowDialogSignOutScreenState();
}

class ShowDialogSignOutScreenState extends State<ShowDialogSignOutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   backgroundColor: Color.fromRGBO(250, 255, 252, 0.9),
        //   body:
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Center(
              child: Container(
                child: Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        height: 218.0,
                        width: 320,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                    color: Color.fromRGBO(151, 151, 151, 1)))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Are you sure you want to Logout?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18.0,
                                    fontFamily: 'RobotoBold'),
                              ),
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ButtonTheme(
                                      minWidth: 118,
                                      height: 45,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        splashColor: Colors.white,
                                        child: const Text(
                                          'No',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: ButtonTheme(
                                        minWidth: 118,
                                        height: 45,
                                        child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          splashColor: Colors.red,
                                          child: const Text(
                                            'Yes',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.remove('email');
                                            prefs.clear();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext ctx) =>
                                                            const LoginPage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (context) =>
                                            //       ));
                                          },
                                        ))),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              ),
              // ),
            ));
  }
}
