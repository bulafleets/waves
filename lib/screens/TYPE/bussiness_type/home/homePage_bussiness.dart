import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/get_following_data_model.dart';
import 'package:waves/models/mywave_model.dart';
import 'package:waves/screens/TYPE/bussiness_type/wave/create_wave_bussiness.dart';
import 'package:waves/screens/TYPE/bussiness_type/wave/wave_details_bussiness.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeBussiness extends StatefulWidget {
  const HomeBussiness({Key? key}) : super(key: key);

  @override
  _HomeBussinessState createState() => _HomeBussinessState();
}

class _HomeBussinessState extends State<HomeBussiness> {
  late Future<MyHomeBussinessModel> _future;

  @override
  void initState() {
    _future = myWaveList();
    getfollowingNumber();
    getAverageReviews();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _future = myWaveList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(user_id);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
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
                          builder: (context) =>
                              const CreateWaveScreenBussiness()));
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
        body: FutureBuilder<MyHomeBussinessModel>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.waves.isNotEmpty) {
                  return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          itemCount: snapshot.data!.waves.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.waves[index];
                            var date =
                                DateFormat('yyyy-MM-dd').format(data.date);
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
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        WaveDetailsBussinessScreen(
                                            data.id,
                                            data.lattitude.toDouble(),
                                            data.longitude.toDouble())));
                              },
                              child: Container(
                                height: 102,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                        const Color.fromRGBO(188, 220, 243, 1)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 102,
                                      margin: const EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 48,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  data.media.first.location,
                                              imageBuilder:
                                                  (context, imageProvider) =>
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          )),
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: Expanded(
                                                  child: Text(
                                                    data.waveName,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ),
                                              ),
                                              // const SizedBox(width: 10),
                                              Text(
                                                tt,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                130,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  date,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  data.startTime,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  data.endTime,
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Text(
                                          //   '$date       '
                                          //   '     ${data.startTime}  '
                                          //   '${data.endTime}',
                                          //   style: GoogleFonts.quicksand(
                                          //       fontSize: 12,
                                          //       fontWeight: FontWeight.w400),
                                          // ),
                                          const SizedBox(height: 5),
                                        ])
                                  ],
                                ),
                              ),
                            );
                          }));
                } else {
                  return const Center(child: Text('Please add any wave'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<MyHomeBussinessModel> myWaveList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getString('user_id');
    var data;
    http.Response response = await http.post(
      Uri.parse(MyWaveListing),
      body: {'user_id': userId},
    );
    final jsonString = response.body;
    final jsonMap = jsonDecode(jsonString);
    data = MyHomeBussinessModel.fromJson(jsonMap);
    return data;
  }

  Future<GetFollowingDataModel> getfollowingNumber() async {
    GetFollowingDataModel data;
    http.Response response = await http.post(Uri.parse(MyFollows),
        body: {'followingId': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = GetFollowingDataModel.fromJson(jsonMap);
    totalFollowing = GetFollowingDataModel.fromJson(jsonMap).followers.length;
    return data;
  }

  Future<void> getAverageReviews() async {
    http.Response response = await http.post(Uri.parse(GetAverageReview),
        body: {'user_id': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;
    averageReviews = jsonDecode(jsonString)['getReviewTotal'];
  }
}
