import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/check_in.dart';
import 'package:waves/contants/comment_widget.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/review_comment.dart';
import 'package:waves/models/get_following_data_model.dart';
import 'package:waves/models/singlewave_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/screens/TYPE/regular_type/map/map_screen.dart';

class WaveDetailsScreen extends StatefulWidget {
  final String WaveId;
  final String userId;
  final int age;
  const WaveDetailsScreen(this.WaveId, this.age, this.userId, {Key? key})
      : super(key: key);

  @override
  _WaveDetailsScreenState createState() => _WaveDetailsScreenState();
}

class _WaveDetailsScreenState extends State<WaveDetailsScreen> {
  late Future<SingleWaveModel> _future;
  List<Follower> _getFollowingData = [];

  bool _isCheckIn = false;
  bool isFollow = false;
  var _countStar;
  void _check(bool checkIn) {
    setState(() {
      _isCheckIn = checkIn;
    });
  }

  void _starData(int countStart) {
    setState(() {
      _countStar = countStart;
    });
  }

  @override
  void initState() {
    _future = singleWavebyRegular();
    getfollowingNumber();
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
    // print(widget.userId);
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
                                            if (data.userType == 'BUSINESS')
                                              isFollow
                                                  ? _unfollowButon()
                                                  : _getFollowingData
                                                          .map((e) => e.user.id)
                                                          .contains(user_id)
                                                      ? _unfollowButon()
                                                      : _followButon(),
                                            // const FaIcon(
                                            //   FontAwesomeIcons.shieldAlt,
                                            //   color: Color.fromRGBO(
                                            //       0, 149, 242, 1),
                                            //   size: 18,
                                            // ),

                                            const SizedBox(width: 15),
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
                                    Text(
                                        '${_countStar ?? data.waveRating.toString()} '),
                                    const Icon(Icons.star, color: Colors.yellow)
                                  ]),
                                  Row(children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ReviewComment(
                                                  bussinessName: data.username,
                                                  waveId: data.id,
                                                  image:
                                                      data.media.first.location,
                                                  starData: _starData,
                                                ));
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

  _followButon() {
    return Container(
      margin: const EdgeInsets.only(left: 15.0),
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Theme.of(context).primaryColor,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          EasyLoading.show(status: 'Please Wait ...');
          followRequestApi();
        },
        child: const Text(
          "Follow",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> followRequestApi() async {
    final response = await http.post(Uri.parse(Follow),
        body: {'followingId': widget.userId, 'followerId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      setState(() {
        isFollow = true;
        getfollowingNumber();
      });
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));

      if (status == "400") {
        String message = jsonDecode(data)['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    }
  }

  _unfollowButon() {
    return Container(
      margin: const EdgeInsets.only(left: 15.0),
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black,
          primary: const Color.fromRGBO(188, 220, 243, 1),
          minimumSize: const Size(70, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          EasyLoading.show(status: 'Please Wait ...');
          unfollowRequestApi();
        },
        child: const Text(
          "Unfollow",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  Future<void> unfollowRequestApi() async {
    final response = await http.post(Uri.parse(UnFollow),
        body: {'followingId': widget.userId, 'followerId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    EasyLoading.dismiss();

    String data = response.body;
    print(data);
    String status = jsonDecode(data)['status'].toString();

    if (status == "200") {
      setState(() {
        isFollow = false;
        getfollowingNumber();
      });
      String message = jsonDecode(data)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));

      if (status == "400") {
        String message = jsonDecode(data)['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    }
  }

  Future<GetFollowingDataModel> getfollowingNumber() async {
    GetFollowingDataModel data;
    http.Response response = await http.post(Uri.parse(MyFollows),
        body: {'followingId': widget.userId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = GetFollowingDataModel.fromJson(jsonMap);

    String apidata = response.body;
    // print(apidata);
    String status = jsonDecode(apidata)['status'].toString();
    if (status == "200") {
      _getFollowingData = GetFollowingDataModel.fromJson(jsonMap).followers;
    }
    setState(() {});
    return data;
  }
}
