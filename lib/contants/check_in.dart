import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckInState();
}

class CheckInState extends State<CheckIn> with SingleTickerProviderStateMixin {
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
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      height: 260.0,
                      width: 310,
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Colors.white))),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 2),
                          const CircleAvatar(
                            radius: 37,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 36,
                              backgroundImage: NetworkImage(
                                  "https://i.pinimg.com/564x/bd/cd/4e/bdcd4e097d609543724874b01aa91c76.jpg"),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Bar Name',
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)),
                          const SizedBox(height: 18),
                          Text(
                            "Do you want to check-in here?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                color: const Color.fromRGBO(38, 69, 255, 1),
                                fontWeight: FontWeight.w700,
                                fontSize: 19.0),
                          ),
                          const SizedBox(height: 15),
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
                                      child: Text('Cancel',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(
                                              color: const Color.fromRGBO(
                                                  38, 69, 255, 1),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
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
                                        color:
                                            const Color.fromRGBO(0, 69, 255, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        splashColor: Colors.red,
                                        child: Text('Check-In',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
              // ),
            ));
  }
}
