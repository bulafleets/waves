import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/my_activity_model.dart';
import 'package:waves/screens/TYPE/regular_type/activity/widget/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:waves/screens/TYPE/regular_type/wave/create_wave.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late Future<MyactivityModel> _future;

  @override
  void initState() {
    _future = activityData();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _future = activityData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(80.0), // here the desired height
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 5),
                  child: IconButton(
                    iconSize: 24,
                    alignment: Alignment.bottomLeft,
                    icon: const FaIcon(FontAwesomeIcons.plus),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateWaveScreen()));
                    },
                  ),
                )
              ],
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
        body: FutureBuilder<MyactivityModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.myActivityList.isNotEmpty) {
                  return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          itemCount: snapshot.data!.myActivityList.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.myActivityList[index];
                            // var date = DateFormat('yyyy/MM/dd').format(data.date);
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
                            return Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 102,
                                    // padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromRGBO(
                                            188, 220, 243, 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 102,
                                          // color: Colors.black,
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                radius: 60,
                                                backgroundColor: Colors.black,
                                                child: CircleAvatar(
                                                  radius: 48,
                                                  backgroundImage: NetworkImage(
                                                      data.waveImage.first
                                                          .location),
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 17,
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundImage: NetworkImage(
                                                      data.profileImage),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.activityType == 'wave'
                                                        ? 'My Wave'
                                                        : 'My Check-In',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                  const SizedBox(width: 30),
                                                  Text(
                                                    tt,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              if (data.activityType == 'wave')
                                                Expanded(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    child: Text(
                                                      'Wave at ${data.waveName}',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                ),
                                              if (data.activityType != 'wave')
                                                Expanded(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    child: Text(
                                                      'Checked into at ${data.waveName}',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(height: 5),
                                            ]),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: 15,
                                    // padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                        iconSize: 30,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  ShowDialogScreen());
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.solidTimesCircle,
                                          color: Colors.black,
                                        )),
                                  ),
                                ]);
                          }));
                } else {
                  return const Center(child: Text('Don\'t have any Activity'));
                }
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null) {
                return const Center(child: Text('Don\'t have any Activity'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<MyactivityModel> activityData() async {
    var data;
    http.Response response =
        await http.post(Uri.parse(MyActivity), body: {'user_id': user_id});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = MyactivityModel.fromJson(jsonMap);
    return data;
  }
}
