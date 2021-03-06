import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/share_pref.dart';
import 'package:waves/models/waveListing_regular_model.dart';
import 'package:waves/screens/Main/main_page.dart';
import 'package:waves/screens/TYPE/regular_type/wave/create_wave.dart';
import 'package:waves/screens/TYPE/regular_type/wave/mywave_detail_regular.dart';
import 'package:waves/screens/TYPE/regular_type/wave/wave_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/screens/notification/notification_screen.dart';
import 'package:waves/screens/profile/view_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<WaveListingRegularModel> _future;

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
    print(user_id);
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
                  icon: notificationData.isNotEmpty
                      ? Stack(
                          children: <Widget>[
                            const FaIcon(FontAwesomeIcons.solidBell),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${notificationData.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        )
                      : const FaIcon(FontAwesomeIcons.solidBell),
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
                          var date = DateFormat('MM/dd/yy').format(data.date);
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
                                  builder: (context) => data.userId == user_id
                                      ? MyWaveDetailRegular(
                                          data.id,
                                          data.userInfo.age,
                                          data.lattitude,
                                          data.longitude)
                                      : WaveDetailsScreen(
                                          data.id,
                                          data.userInfo.age ?? 0,
                                          data.userId)));
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
                                    child: InkWell(
                                      onTap: () {
                                        if (data.userId != user_id) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProfleScreen(
                                                          profileId:
                                                              data.userId)));
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainPage(3)));
                                        }
                                      },
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
                                              // child: NetworkImage(url)
                                              // CachedNetworkImage(
                                              //   imageUrl:
                                              //       data.media.first.location,
                                              //   imageBuilder:
                                              //       (context, imageProvider) =>
                                              //           Container(
                                              //     width: double.infinity,
                                              //     height: double.infinity,
                                              //     decoration: BoxDecoration(
                                              //       shape: BoxShape.circle,
                                              //       image: DecorationImage(
                                              //           image: imageProvider,
                                              //           fit: BoxFit.cover),
                                              //     ),
                                              //   ),
                                              //   placeholder: (context, url) =>
                                              //       const CircularProgressIndicator(),
                                              //   errorWidget:
                                              //       (context, url, error) =>
                                              //           const Icon(Icons.error),
                                              // ),
                                              // backgroundImage: NetworkImage(
                                              //     data.media.first.location),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 17,
                                            backgroundColor: !data
                                                    .isBusinessUser
                                                ? data.userInfo.age > 17 &&
                                                        data.userInfo.age < 30
                                                    ? const Color.fromRGBO(
                                                        0, 0, 255, 1)
                                                    : data.userInfo.age > 29 &&
                                                            data.userInfo.age <
                                                                50
                                                        ? const Color.fromRGBO(
                                                            255, 255, 0, 1)
                                                        : const Color.fromRGBO(
                                                            0, 255, 128, 1)
                                                : Colors.white,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  data.userInfo.avatar),
                                              // child: CachedNetworkImage(
                                              //   imageUrl: data.avatar,
                                              //   imageBuilder:
                                              //       (context, imageProvider) =>
                                              //           Container(
                                              //     width: double.infinity,
                                              //     height: double.infinity,
                                              //     decoration: BoxDecoration(
                                              //       shape: BoxShape.circle,
                                              //       image: DecorationImage(
                                              //           image: imageProvider,
                                              //           fit: BoxFit.cover),
                                              //     ),
                                              //   ),
                                              //   placeholder: (context, url) =>
                                              //       const CircularProgressIndicator(),
                                              //   errorWidget:
                                              //       (context, url, error) =>
                                              //           const Icon(Icons.error),
                                              // ),
                                              // backgroundImage:
                                              //     NetworkImage(data.avatar),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                                child: InkWell(
                                                  onTap: () {
                                                    if (data.userId !=
                                                        user_id) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewProfleScreen(
                                                                      profileId:
                                                                          data.userId)));
                                                    } else {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      const MainPage(
                                                                          3)));
                                                    }
                                                  },
                                                  child: Text(
                                                    data.userType != 'BUSINESS'
                                                        ? data.userInfo.username
                                                        : data.waveName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
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
                                        Flexible(
                                          child: SizedBox(
                                            width: 200,
                                            child: Text(
                                              data.userType != 'BUSINESS'
                                                  ? data.isCheckedIn
                                                      ? 'Checked into  ${data.eventInfo.eventName}'
                                                      : 'Wave at ${data.waveName}'
                                                  : data.userInfo.username,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                date,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const Spacer(),
                                              Text(
                                                data.startTime,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const Spacer(),
                                              Text(
                                                data.endTime,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const Spacer(),
                                              if (data.userType == 'BUSINESS' &&
                                                  data.isDiscountFollower)
                                                FaIcon(
                                                    FontAwesomeIcons.dollarSign,
                                                    size: 15,
                                                    color: Colors.grey[700])
                                            ],
                                          ),
                                        ),
                                        // SizedBox(
                                        //     // width: MediaQuery.of(context)
                                        //     //         .size
                                        //     //         .width -
                                        //     //     100,
                                        //     child: Row(
                                        //   children: [
                                        //     Text(
                                        //       '$date'
                                        //       '     ${data.startTime}  '
                                        //       '${data.endTime} ',
                                        //       style: GoogleFonts.quicksand(
                                        //           fontSize: 10,
                                        //           fontWeight: FontWeight.w400),
                                        //     ),
                                        //     const SizedBox(width: 10),
                                        //     if (data.userType == 'BUSINESS' &&
                                        //         data.isDiscountFollower)
                                        //       FaIcon(
                                        //           FontAwesomeIcons.dollarSign,
                                        //           size: 15,
                                        //           color: Colors.grey[700])
                                        //   ],
                                        // )),
                                        const SizedBox(height: 5),
                                      ])
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(child: Text('Please add wave'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<WaveListingRegularModel> waveListingRegular() async {
    WaveListingRegularModel data;
    http.Response response = await http.post(Uri.parse(waveListing),
        body: {'user_id': user_id},
        headers: {HttpHeaders.authorizationHeader: "Bearer $authorization"});
    final jsonString = response.body;

    final jsonMap = jsonDecode(jsonString);
    data = WaveListingRegularModel.fromJson(jsonMap);
    return data;
  }
}
