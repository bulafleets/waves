import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('Privacy Policy',
            style: GoogleFonts.ptSans(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
          child: Text(privacyPolicyData,
              textAlign: TextAlign.left,
              style: GoogleFonts.ptSans(
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: Colors.white)),
        ),
      ),
    );
  }
}
