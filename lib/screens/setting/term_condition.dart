import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  _TermAndConditionState createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('Term & Conditions',
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
          child: Text(termContiondata,
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
