import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:waves/contants/common_params.dart';

class ReplyCommentWidget extends StatefulWidget {
  final String waveId;
  final String commentId;
  final int index;
  final Function(String replyText, String waveId, int index, String commentId)
      replyData;
  const ReplyCommentWidget({
    Key? key,
    required this.waveId,
    required this.commentId,
    required this.index,
    required this.replyData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ReplyCommentWidgetState();
}

class ReplyCommentWidgetState extends State<ReplyCommentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  TextEditingController _replyController = TextEditingController();

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
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  height: 300.0,
                  width: 300,
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                              color: Color.fromRGBO(151, 151, 151, 1)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text(
                          "Leave a Comment Reply",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(38, 69, 255, 1),
                              fontSize: 20.0,
                              fontFamily: 'RobotoBold'),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon:
                                const FaIcon(FontAwesomeIcons.times, size: 16)),
                      ]),
                      const SizedBox(height: 8),
                      Expanded(
                          child: TextField(
                              maxLines: 7,
                              style: const TextStyle(color: Colors.black),
                              // validator:RequiredValidator(errorText: "Please Enter Your Mobile Number."),
                              controller: _replyController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.grey,
                              onChanged: (val) {},
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                    color: Color.fromRGBO(98, 8, 15, 1)),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(237, 232, 232, 1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
        onPressed: () {
          if (_replyController.text.isNotEmpty) {
            EasyLoading.show(status: 'Please Wait ...');
            FocusScope.of(context).unfocus();

            replyCommentApi();
          } else {
            String message = 'please enter comment first';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
            ));
          }
        },

        child: const Text(
          "Submit",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> replyCommentApi() async {
    final response = await http.post(Uri.parse(ReplyComment), body: {
      "user_id": user_id,
      "wave_id": widget.waveId,
      "comment": _replyController.text,
      "comment_id": widget.commentId,
      "avatar": profileimg,
      "username": name
    });

    EasyLoading.dismiss();
    String data = response.body;
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
      widget.replyData(
          _replyController.text, widget.waveId, widget.index, widget.commentId);
      Navigator.of(context).pop();
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
