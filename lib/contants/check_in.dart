import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';

class CheckIn extends StatefulWidget {
  final String waveId;
  final String image;
  final String waveName;
  final String waveType;
  final Function(bool isCheckIN) checkInData;
  const CheckIn(
      this.waveId, this.checkInData, this.image, this.waveName, this.waveType,
      {Key? key})
      : super(key: key);

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
                      height: 282.0,
                      width: 310,
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Colors.white))),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 2),
                          CircleAvatar(
                            radius: 37,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 36,
                              child: CachedNetworkImage(
                                imageUrl: widget.image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              // backgroundImage: NetworkImage(widget.image),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(widget.waveName,
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)),
                          const SizedBox(height: 8),
                          Text(widget.waveType,
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontSize: 16,
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
                                          EasyLoading.show(
                                              status: 'Please Wait ...');
                                          checkInApi();

                                          setState(() {
                                            widget.checkInData(true);
                                          }); // Navigator.of(context).push(MaterialPageRoute(
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

  Future<void> checkInApi() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getString('user_id');
    final response = await http.post(
      Uri.parse(checkIn),
      body: {"wave_id": widget.waveId, "user_id": userId},
    );
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
    Navigator.of(context).pop();
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }
}
