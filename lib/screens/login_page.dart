import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/widget/signup.dart';

import '../widget/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: MediaQuery.of(context).size.height / 3),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/login.png',
                  height: 142,
                  width: 201,
                  fit: BoxFit.cover,
                )),
            DefaultTabController(
                length: 2, // length of tabs
                initialIndex: 0,
                child: Column(

                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TabBar(
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            child: Text(
                              ' LOGIN ',
                              style: GoogleFonts.muli(fontSize: 16),
                            ),
                          ),
                          Tab(
                            child: Text(
                              ' SIGNUP ',
                              style: GoogleFonts.muli(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 500, //height of TabBarView
                          padding: const EdgeInsets.all(30),
                          child: const TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[LoginScreen(), SignUpPage()]))
                    ])),
          ],
        ),
      ),
    ));
  }
}
