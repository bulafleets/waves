import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/change_password/changePassword.dart';
import 'package:waves/screens/setting/about.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/setting/notification_setting.dart';
import 'package:waves/screens/setting/privacy_policy.dart';
import 'package:waves/screens/setting/term_condition.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    aboutdataApi();
    termCOndition();
    privacyPolicy();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Settings',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(35),
        child: ListView(
          children: [
            ListTile(
              title: Text('Change Password',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.white)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()));
              },
            ),
            ListTile(
              title: Text('Notification Setting',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.white)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationSettingScreen()));
              },
            ),
            ListTile(
              title: Text('Privacy Policy',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.white)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PrivacyPolicy()));
              },
            ),
            ListTile(
              title: Text('Term & Conditions',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.white)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TermAndCondition()));
              },
            ),
            ListTile(
              title: Text('About',
                  style: GoogleFonts.ptSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.white)),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> aboutdataApi() async {
    http.Response response =
        await http.post(Uri.parse(AboutData), body: {"slug": "about_us"});
    final jsonString = response.body;

    String status = jsonDecode(jsonString)['status'].toString();
    if (status == '200') {
      setState(() {
        aboutdata = jsonDecode(jsonString)['data']['description'].toString();
      });
    }
  }

  Future<void> privacyPolicy() async {
    http.Response response =
        await http.post(Uri.parse(AboutData), body: {"slug": "privacy_policy"});
    final jsonString = response.body;

    String status = jsonDecode(jsonString)['status'].toString();
    if (status == '200') {
      setState(() {
        privacyPolicyData =
            jsonDecode(jsonString)['data']['description'].toString();
      });
    }
  }

  Future<void> termCOndition() async {
    http.Response response =
        await http.post(Uri.parse(AboutData), body: {"slug": "term_condtions"});
    final jsonString = response.body;

    String status = jsonDecode(jsonString)['status'].toString();
    if (status == '200') {
      setState(() {
        termContiondata =
            jsonDecode(jsonString)['data']['description'].toString();
      });
    }
  }
}
