import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingScreenState createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool notificationtile = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text('Notification Settings',
              style: GoogleFonts.ptSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(35),
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Notification Tile',
                              style: GoogleFonts.ptSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21,
                                  color: Colors.white)),
                          FlutterSwitch(
                              height: 25.0,
                              width: 40.0,
                              padding: 4.0,
                              toggleSize: 15.0,
                              borderRadius: 10.0,
                              activeColor: Colors.blue,
                              inactiveText: 'off',
                              activeText: 'on',
                              activeTextColor: Colors.black,
                              value: notificationtile,
                              onToggle: (value) {
                                setState(() {
                                  notificationtile = value;
                                });
                              })
                        ],
                      ),
                    ))));
  }
}
