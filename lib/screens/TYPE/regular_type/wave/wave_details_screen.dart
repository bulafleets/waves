import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/check_in.dart';
import 'package:waves/contants/comment_widget.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/contants/review_comment.dart';
import 'package:waves/models/singlewave_model.dart';
import 'package:waves/models/waveListing_regular_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/screens/TYPE/regular_type/map/map_screen.dart';

class WaveDetailsScreen extends StatefulWidget {
  final String WaveId;
  final int age;
  const WaveDetailsScreen(this.WaveId, this.age, {Key? key}) : super(key: key);

  @override
  _WaveDetailsScreenState createState() => _WaveDetailsScreenState();
}

class _WaveDetailsScreenState extends State<WaveDetailsScreen> {
  late Future<SingleWaveModel> _future;
  bool _isCheckIn = false;

  void _check(bool checkIn) {
    setState(() {
      _isCheckIn = checkIn;
    });
  }

  @override
  void initState() {
    _future = singleWavebyRegular();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _future = singleWavebyRegular();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(top: 17.0, left: 5),
              child: IconButton(
                iconSize: 24,
                alignment: Alignment.bottomLeft,
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            flexibleSpace: Container(
                width: 85,
                height: 70,
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/login.png',
                  width: 85,
                  height: 70,
                  fit: BoxFit.contain,
                )),
            centerTitle: true,
          )),
      body: FutureBuilder<SingleWaveModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.wave.first;

              var date = DateFormat('yyyy/MM/dd').format(data.date);
              var time = DateTime.now().difference(data.createdAt).inMinutes;
              String tt = time > 59
                  ? time > 1440
                      ? '${DateTime.now().difference(data.createdAt).inDays.toString()} d'
                      : '${DateTime.now().difference(data.createdAt).inHours.toString()} h'
                  : "${DateTime.now().difference(data.createdAt).inMinutes.toString()} m";
              return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView(
                    // physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                          // height: 251,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(188, 220, 243, 1),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60)),
                          ),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: 102,
                                    // color: Colors.black,
                                    margin: const EdgeInsets.only(
                                        right: 20, left: 20),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.black,
                                            child: CircleAvatar(
                                              radius: 48,
                                              backgroundImage: NetworkImage(
                                                  data.media.first.location),
                                            )),
                                        CircleAvatar(
                                            radius: 19,
                                            backgroundColor: widget.age > 17 &&
                                                    widget.age < 30
                                                ? const Color.fromRGBO(
                                                    0, 0, 255, 1)
                                                : widget.age > 29 &&
                                                        widget.age < 50
                                                    ? const Color.fromRGBO(
                                                        255, 255, 0, 1)
                                                    : const Color.fromRGBO(
                                                        0, 255, 128, 1),
                                            child: CircleAvatar(
                                              radius: 17,
                                              backgroundImage:
                                                  NetworkImage(data.avatar),
                                            ))
                                      ],
                                    ),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              data.username,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(width: 15),
                                            if (data.userType == 'BUSINESS')
                                              Image.asset(
                                                'assets/icons/verified.png',
                                                scale: .9,
                                              ),
                                            // const FaIcon(
                                            //   FontAwesomeIcons.shieldAlt,
                                            //   color: Color.fromRGBO(
                                            //       0, 149, 242, 1),
                                            //   size: 18,
                                            // ),
                                            const SizedBox(width: 30),
                                            Text(
                                              tt,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          data.isCheckedIn
                                              ? 'Checked in ${data.eventInfo.eventName}'
                                              : 'Wave at ${data.waveName}',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          '${data.eventInfo.eventName}   $date  ${data.startTime} - ${data.endTime}',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ])
                                ]),
                            const SizedBox(height: 15),
                            Row(children: [
                              if (data.userType == 'BUSINESS')
                                const SizedBox(width: 30),
                              if (data.userType == 'BUSINESS')
                                Column(children: [
                                  Row(children: [
                                    Text(data.waveRating.toString()),
                                    const Icon(Icons.star, color: Colors.yellow)
                                  ]),
                                  Row(children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ReviewComment());
                                      },
                                      label: const Icon(Icons.edit_location_alt,
                                          size: 20, color: Colors.black),
                                      icon: Text('Review',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300)),
                                    )
                                  ]),
                                ]),
                              const SizedBox(width: 50),
                              Expanded(
                                  child: Text(data.eventDetail,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)))
                            ]),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MapScreenRegular(
                                                    longitute: data.longitude,
                                                    latitute: data.lattitude,
                                                    image: data.avatar,
                                                  )));
                                    },
                                    label: const Icon(Icons.location_on,
                                        color: Color.fromRGBO(42, 124, 202, 1)),
                                    icon: Text('See Location',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                42, 124, 202, 1)))),
                                const SizedBox(width: 15),
                                TextButton(
                                    onPressed: !data.isCheckedIn
                                        ? () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => CheckIn(
                                                    data.id,
                                                    _check,
                                                    data.media.first.location,
                                                    data.waveName,
                                                    data.eventInfo.eventName));
                                          }
                                        : null,
                                    child: Text(
                                        !data.isCheckedIn
                                            ? _isCheckIn
                                                ? 'Already checked-In'
                                                : 'Check-In'
                                            : 'Already checked-In',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                42, 124, 202, 1)))),
                              ],
                            )
                          ])),
                      // const SizedBox(height: 5),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       Text(
                      //         'COMMENTS',
                      //         style: GoogleFonts.quicksand(
                      //             fontSize: 19, fontWeight: FontWeight.w300),
                      //       ),
                      //       TextButton(
                      //           onPressed: () {
                      //             showDialog(
                      //                 context: context,
                      //                 builder: (_) => LeaveComment(data.id));
                      //           },
                      //           child: Text(
                      //             'Leave a comment+',
                      //             style: GoogleFonts.quicksand(
                      //                 fontSize: 13,
                      //                 color:
                      //                     const Color.fromRGBO(42, 124, 202, 1),
                      //                 fontWeight: FontWeight.w300),
                      //           ))
                      //     ]),
                      const SizedBox(height: 5),
                      CommentScreen(data.waveComments, data.id, data.userId)
                    ],
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<SingleWaveModel> singleWavebyRegular() async {
    var data;
    http.Response response = await http.post(Uri.parse(SingleWaveView),
        body: {'wave_id': widget.WaveId, 'user_id': user_id});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = SingleWaveModel.fromJson(jsonMap);
    return data;
  }
}
