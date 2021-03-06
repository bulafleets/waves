import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:waves/contants/common_params.dart';
import 'package:http/http.dart' as http;

class ShowDialogRemoveFriend extends StatefulWidget {
  final String id;
  final BuildContext context;
  const ShowDialogRemoveFriend(this.id, this.context, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ShowDialogRemoveFriendState();
}

class ShowDialogRemoveFriendState extends State<ShowDialogRemoveFriend>
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
                                "Are you sure to remove",
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
                                      child: RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                      onPressed: () {
                                        removeFriends(widget.id);

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

  Future<void> removeFriends(String receiverID) async {
    final response = await http.post(Uri.parse(RemoveFriend), body: {
      'sender_id': receiverID,
      'reciever_id': user_id,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authorization"
    });

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    // EasyLoading.dismiss();
    if (status == "200") {
      print('suxx');
      // String message = jsonDecode(data)['message'];
      String message = 'Removed friend from list';
      ScaffoldMessenger.of(widget.context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.of(context).pop();
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      Navigator.of(context).pop();
    }
  }
}
