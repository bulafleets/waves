import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:waves/contants/common_params.dart';

class ReviewComment extends StatefulWidget {
  final String bussinessName;
  final String waveId;
  final String image;
  final String star;
  final Function(double stars) starData;
  const ReviewComment(
      {required this.bussinessName,
      required this.waveId,
      required this.image,
      required this.starData,
      required this.star,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ReviewCommentState();
}

class ReviewCommentState extends State<ReviewComment>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  double _star = 0;
  TextEditingController _reviewController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

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
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
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
                      height: 500.0,
                      width: 320,
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(color: Colors.white))),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Text(
                              "Your Review",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(38, 69, 255, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21.0),
                            ),
                            const SizedBox(height: 15),
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
                                // backgroundImage: NetworkImage(widget.image)
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(widget.bussinessName,
                                style: GoogleFonts.quicksand(
                                    color: const Color.fromRGBO(38, 69, 255, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300)),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // _oneStar = !_oneStar;
                                      if (_star == 1) {
                                        _star = 0;
                                      } else {
                                        _star = 1;
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: _star == 1 ||
                                              _star == 2 ||
                                              _star == 3 ||
                                              _star == 4 ||
                                              _star == 5
                                          ? const Color.fromRGBO(
                                              255, 216, 87, 1)
                                          : const Color.fromRGBO(
                                              255, 227, 134, .6)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_star == 2) {
                                        _star = 0;
                                      } else {
                                        _star = 2;
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: _star == 2 ||
                                              _star == 3 ||
                                              _star == 4 ||
                                              _star == 5
                                          ? const Color.fromRGBO(
                                              255, 216, 87, 1)
                                          : const Color.fromRGBO(
                                              255, 227, 134, .6)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_star == 3) {
                                        _star = 0;
                                      } else {
                                        _star = 3;
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color:
                                          _star == 3 || _star == 4 || _star == 5
                                              ? const Color.fromRGBO(
                                                  255, 216, 87, 1)
                                              : const Color.fromRGBO(
                                                  255, 227, 134, .6)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_star == 4) {
                                        _star = 0;
                                      } else {
                                        _star = 4;
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: _star == 4 || _star == 5
                                          ? const Color.fromRGBO(
                                              255, 216, 87, 1)
                                          : const Color.fromRGBO(
                                              255, 227, 134, .6)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_star == 5) {
                                        _star = 0;
                                      } else {
                                        _star = 5;
                                      }
                                    });
                                  },
                                  icon: FaIcon(FontAwesomeIcons.solidStar,
                                      size: 32,
                                      color: _star == 5
                                          ? const Color.fromRGBO(
                                              255, 216, 87, 1)
                                          : const Color.fromRGBO(
                                              255, 227, 134, .6)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                                child: TextFormField(
                                    maxLines: 7,
                                    style: const TextStyle(color: Colors.black),
                                    validator: (val) {
                                      if (val!.isEmpty)
                                        return 'Please Enter Review';

                                      return null;
                                    },
                                    // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
                                    controller: _reviewController,
                                    keyboardType: TextInputType.text,
                                    cursorColor: Colors.grey,
                                    onChanged: (val) {},
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                          color: Color.fromRGBO(98, 8, 15, 1)),
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                          237, 232, 232, 1),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                      hintText: "Enter review here..",
                                      hintStyle: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                      border: const OutlineInputBorder(),
                                    ))),
                            const SizedBox(height: 10),
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
                                            if (_formkey.currentState!
                                                .validate()) {
                                              EasyLoading.show(
                                                  status: 'Please Wait ...');
                                              reviewBussiness();
                                            }
                                          },
                                        ))),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ),
              // ),
            ));
  }

  Future<void> reviewBussiness() async {
    final response = await http.post(Uri.parse(ReviewBussines), body: {
      "wave_id": widget.waveId,
      "user_id": user_id,
      "rating": _star.toString(),
      "review_comment": _reviewController.text.toString(),
    });

    String data = response.body;
    EasyLoading.dismiss();

    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      Navigator.of(context).pop();
      var star = double.parse(widget.star);
      widget.starData((_star + star) / 2);
    }
    if (status == "400") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      Navigator.of(context).pop();
    }
  }
}
