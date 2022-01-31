import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/models/waveListing_regular_model.dart';
import 'package:waves/screens/TYPE/regular_type/wave/create_wave.dart';
import 'package:waves/screens/TYPE/regular_type/wave/wave_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    setState(() {
      _future = waveListingRegular();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
                return RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.builder(
                      itemCount: snapshot.data!.wavesList.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.wavesList[index];
                        // DateTime tempDate = DateFormat("yyyy-MMM-dd hh:mm:ss")
                        //     .parse(data.createdAt);
                        // var time =
                        //     DateTime.now().difference(tempDate).inMinutes;
                        // print(time);
                        // if (index == 0) {
                        //   return const SizedBox(height: 15);
                        // }
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    WaveDetailsScreen(data.id)));
                          },
                          child: Container(
                            height: 102,
                            // padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromRGBO(188, 220, 243, 1)),
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
                                      const CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage(
                                              "https://i.pinimg.com/564x/bd/cd/4e/bdcd4e097d609543724874b01aa91c76.jpg"),
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 17,
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
                                      Row(
                                        children: [
                                          Text(
                                            data.username,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 15),
                                          const FaIcon(
                                              FontAwesomeIcons.solidIdBadge),
                                          const SizedBox(width: 30),
                                          Text(
                                            '2m',
                                            style: GoogleFonts.quicksand(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Wave at ${data.eventInfo.first.eventName}',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${data.date}       '
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
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<WaveListingRegularModel> waveListingRegular() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var userId = _prefs.getString('user_id');
    print(userId);
    var data;
    http.Response response = await http.post(Uri.parse(waveListing),
        body: {'user_id': userId},
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    final jsonString = response.body;
    print(jsonString);
    final jsonMap = jsonDecode(jsonString);
    data = WaveListingRegularModel.fromJson(jsonMap);
    return data;
  }
}
