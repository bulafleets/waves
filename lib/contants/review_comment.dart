import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewComment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReviewCommentState();
}

class ReviewCommentState extends State<ReviewComment>
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
                        height: 320.0,
                        width: 320,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.white))),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(
                              "Your Review",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21.0),
                            ),
                            SizedBox(height: 15),
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
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color:
                                          Color.fromRGBO(255, 227, 134, 0.9)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: Color.fromRGBO(255, 227, 134, .5)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: Color.fromRGBO(255, 227, 134, .5)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: Color.fromRGBO(255, 227, 134, .5)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: Color.fromRGBO(255, 227, 134, .5)),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
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
                                          color: const Color.fromRGBO(
                                              0, 69, 255, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          splashColor: Colors.red,
                                          child: Text('Submit',
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
              ),
              // ),
            ));
  }
}
