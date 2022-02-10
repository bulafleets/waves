import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/models/waveListing_regular_model.dart';
import 'package:waves/screens/TYPE/regular_type/wave/create_wave.dart';
import 'package:waves/screens/TYPE/regular_type/wave/mywave_detail_regular.dart';
import 'package:waves/screens/TYPE/regular_type/wave/wave_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/screens/notification/notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<WaveListingRegularModel> _future;
  var userID;

  @override
  void initState() {
    _future = waveListingRegular();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _future = waveListingRegular();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userID);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 5),
                child: IconButton(
                  iconSize: 24,
                  alignment: Alignment.bottomLeft,
                  icon: const FaIcon(FontAwesomeIcons.solidBell),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
                  },
                ),
              ),
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
        body: FutureBuilder<WaveListingRegularModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.wavesList.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView.builder(
                        itemCount: snapshot.data!.wavesList.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.wavesList[index];
                          var date = DateFormat('yyyy/MM/dd').format(data.date);
                          // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
                          //     .parse(data.createdAt);
                          print(data.isBusinessUser);
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
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => data.userId == userID
                                      ? MyWaveDetailRegular(
                                          data.id,
                                          data.userInfo.age,
                                          data.lattitude,
                                          data.longitude)
                                      : WaveDetailsScreen(
                                          data.id, data.userInfo.age)));
                            },
                            child: Container(
                              height: 102,
                              // padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: data.userType == 'BUSINESS'
                                    ? const Color.fromRGBO(215, 193, 246, 1)
                                    : const Color.fromRGBO(188, 220, 243, 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 102,
                                    // color: Colors.black,
                                    margin: const EdgeInsets.only(right: 20),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 48,
                                            backgroundImage: NetworkImage(
                                                data.media.first.location),
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 17,
                                          backgroundColor:
                                              data.userInfo.age > 17 &&
                                                      data.userInfo.age < 30
                                                  ? const Color.fromRGBO(
                                                      0, 0, 255, 1)
                                                  : data.userInfo.age > 29 &&
                                                          data.userInfo.age < 50
                                                      ? const Color.fromRGBO(
                                                          255, 255, 0, 1)
                                                      : const Color.fromRGBO(
                                                          0, 255, 128, 1),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage:
                                                NetworkImage(data.avatar),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  data.userType != 'BUSINESS'
                                                      ? data.username
                                                      : data.waveName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              if (data.userType != 'BUSINESS')
                                                FaIcon(
                                                  FontAwesomeIcons.solidIdBadge,
                                                  color: data.userInfo.age >
                                                              17 &&
                                                          data.userInfo.age < 30
                                                      ? const Color.fromRGBO(
                                                          0, 0, 255, 1)
                                                      : data.userInfo.age >
                                                                  29 &&
                                                              data.userInfo
                                                                      .age <
                                                                  50
                                                          ? const Color
                                                                  .fromRGBO(
                                                              255, 255, 0, 1)
                                                          : const Color
                                                                  .fromRGBO(
                                                              0, 255, 128, 1),
                                                ),
                                              if (data.userType == 'BUSINESS')
                                                Image.asset(
                                                  'assets/icons/verified.png',
                                                  scale: .9,
                                                ),
                                              // FaIcon(
                                              //   FontAwesomeIcons.shieldAlt,
                                              //   color: Color.fromRGBO(
                                              //       0, 149, 242, 1),
                                              //   size: 18,
                                              // ),
                                              // color: data.userInfo.age >
                                              //             17 &&
                                              //         data.userInfo.age < 30
                                              //     ? const Color.fromRGBO(
                                              //         0, 0, 255, 1)
                                              //     : data.userInfo.age >
                                              //                 29 &&
                                              //             data.userInfo
                                              //                     .age <
                                              //                 50
                                              //         ? const Color
                                              //                 .fromRGBO(
                                              //             255, 255, 0, 1)
                                              //         : const Color
                                              //                 .fromRGBO(
                                              //             0, 255, 128, 1),
                                              // ),
                                              const SizedBox(width: 30),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  tt,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          data.userType != 'BUSINESS'
                                              ? data.isCheckedIn
                                                  ? 'Checked into  ${data.eventInfo.eventName}'
                                                  : 'Wave at ${data.waveName}'
                                              : data.username,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '$date'
                                          '     ${data.startTime}  '
                                          '${data.endTime}',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 5),
                                      ])
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(child: Text('Please add any wave'));
                }
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null) {
                return const Center(child: Text('Please add any wave'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<WaveListingRegularModel> waveListingRegular() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString(Prefs.token);
    var userId = _prefs.getString(Prefs.userId);
    userID = userId;
    var data;
    http.Response response = await http.post(Uri.parse(waveListing),
        body: {'user_id': userId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = WaveListingRegularModel.fromJson(jsonMap);
    return data;
  }
}
