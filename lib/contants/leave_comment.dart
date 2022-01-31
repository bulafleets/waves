import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveComment extends StatefulWidget {
  const LeaveComment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LeaveCommentState();
}

class LeaveCommentState extends State<LeaveComment>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
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
                        height: 300.0,
                        width: 300,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                    color: Color.fromRGBO(151, 151, 151, 1)))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Leave a Comment",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(38, 69, 255, 1),
                                        fontSize: 20.0,
                                        fontFamily: 'RobotoBold'),
                                  ),
                                  SizedBox(width: 5),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const FaIcon(FontAwesomeIcons.times,
                                          size: 16)),
                                ]),
                            SizedBox(height: 8),
                            Expanded(
                                child: TextField(
                                    maxLines: 7,
                                    style: const TextStyle(color: Colors.black),
                                    // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
                                    // controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.grey,
                                    onChanged: (val) {},
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(237, 232, 232, 1),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      hintText: "Your comment..",
                                      hintStyle: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                      border: const OutlineInputBorder(),
                                    ))),
                            submitButton()
                          ],
                        )),
                  ),
                ),
              ),
              // ),
            ));
  }

  Widget submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: const Color.fromRGBO(0, 69, 255, 1),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        // onPressed: () {
        onPressed: () {},

        child: const Text(
          "Submit",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }
}
