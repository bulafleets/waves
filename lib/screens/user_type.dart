// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/login_page.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool isselect = false;
  bool isregularclicked = false;
  bool isbussinesstclicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          //  Stack(alignment: Alignment.bottomCenter, children: [
          //   RotationTransition(
          //       turns: const AlwaysStoppedAnimation(50 / 360),
          //       child: SvgPicture.asset(
          //         'assets/back.svg',
          //         fit: BoxFit.fitHeight,
          //       )),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: const DecorationImage(
                  opacity: 0.8,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/back1.png",
                  ),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(height: 100),
                Text('User Type',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white)),
                const SizedBox(height: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text('Please choose your User Type',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 14, color: Colors.white))),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 1),
                      ], borderRadius: BorderRadius.circular(16)),
                      width: 166,
                      height: 145,
                      child: RaisedButton(
                          color: isregularclicked
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          onPressed: () => {
                                setState(() {
                                  AccountType = "REGULAR";
                                  isselect = true;
                                  isregularclicked = true;
                                  isbussinesstclicked = false;
                                })
                              },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, bottom: 15),
                                child: FaIcon(FontAwesomeIcons.userAlt,
                                    size: 57,
                                    color: !isregularclicked
                                        ? Colors.white
                                        : Color.fromRGBO(12, 41, 93, 1)),
                              ),
                              Text('Regular Customers',
                                  style: GoogleFonts.muli(
                                      fontSize: 13,
                                      color: !isregularclicked
                                          ? Colors.white
                                          : const Color.fromRGBO(
                                              12, 41, 93, 1)))
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 1),
                      ], borderRadius: BorderRadius.circular(16)),
                      width: 166,
                      height: 145,
                      child: RaisedButton(
                          color: isbussinesstclicked
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          onPressed: () => {
                                setState(() {
                                  AccountType = "BUSINESS";
                                  isselect = true;
                                  isregularclicked = false;
                                  isbussinesstclicked = true;
                                })
                              },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, bottom: 15),
                                child: FaIcon(FontAwesomeIcons.userTie,
                                    size: 60,
                                    color: !isbussinesstclicked
                                        ? Colors.white
                                        : const Color.fromRGBO(12, 41, 93, 1)),
                              ),
                              Text('Bussiness Customers',
                                  style: GoogleFonts.muli(
                                      fontSize: 13,
                                      color: !isbussinesstclicked
                                          ? Colors.white
                                          : const Color.fromRGBO(
                                              12, 41, 93, 1)))
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    ),
                  ],
                ),
                // SizedBox(height: 50),
              ])),
      // ]),
      floatingActionButton: nextButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  Widget nextButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      margin: const EdgeInsets.only(bottom: 20.0),
      height: 60,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isselect
              ? const Color.fromRGBO(0, 69, 255, 1)
              : const Color.fromRGBO(55, 93, 159, 1),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          if (isselect == false) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please Select Type"),
            ));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const AddFriends()));
          // if (_formkey.currentState.validate()) {
          // showDialog(
          //   context: context,
          //   builder: (_) ,
          // );
          //  EasyLoading.show(status: 'Please Wait ...');
          //sendRESENT();
          //CircularProgressIndicator();
          //  EasyLoading.show(status: 'Please Wait ...');

          //print("Routing to your account");
          // }
        },
        child: Text(
          "Next",
          style: TextStyle(
              color: isselect
                  ? Colors.white
                  : const Color.fromRGBO(206, 188, 188, 1),
              fontSize: 18,
              fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }
}
