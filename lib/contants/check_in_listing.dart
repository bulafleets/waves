import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/check_In_model.dart';
import 'package:http/http.dart' as http;

class CheckInListing extends StatefulWidget {
  final String waveId;
  const CheckInListing(this.waveId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckInListingState();
}

class CheckInListingState extends State<CheckInListing>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Future<CheckInModel> _future;

  @override
  void initState() {
    super.initState();
    _future = checkInListing();

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
        Center(
      child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(2.0),
                  height: MediaQuery.of(context).size.height / 2 - 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: ShapeDecoration(
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              color: Color.fromRGBO(151, 151, 151, 1)))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 80),
                              const Text(
                                "Checked In",
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
                                  icon: const FaIcon(FontAwesomeIcons.times,
                                      size: 16)),
                            ]),
                        const SizedBox(height: 8),
                        FutureBuilder<CheckInModel>(
                            future: _future,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.checkInList.isNotEmpty) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshot.data!.checkInList.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            snapshot.data!.checkInList[index];
                                        // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                                        //     .parse(data.createdAt);
                                        var time = DateTime.now()
                                            .difference(data.createdAt)
                                            .inMinutes;
                                        String tt = time > 59
                                            ? time > 1440
                                                ? '${DateTime.now().difference(data.createdAt).inDays.toString()} d'
                                                : '${DateTime.now().difference(data.createdAt).inHours.toString()} h'
                                            : "${DateTime.now().difference(data.createdAt).inMinutes.toString()} m";
                                        // if (index == 0) {
                                        //   return const SizedBox(height: 15);
                                        // }
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(data.avatar),
                                          ),
                                          title: Text(
                                            '${data.name} checked in for this event',
                                            style: GoogleFonts.quicksand(
                                                fontSize: 12,
                                                // color: const Color.fromRGBO(,1),
                                                fontWeight: FontWeight.w300),
                                          ),
                                          trailing: Text(tt),
                                        );
                                      });
                                } else {
                                  return const Center(
                                      child: Text('No one checked In'));
                                }
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                      ])))),
    );
  }

  Future<CheckInModel> checkInListing() async {
    var data;
    http.Response response = await http
        .post(Uri.parse(CheckInListingApi), body: {'wave_id': widget.waveId});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = CheckInModel.fromJson(jsonMap);
    return data;
  }
}
