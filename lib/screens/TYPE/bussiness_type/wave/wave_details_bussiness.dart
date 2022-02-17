import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/comment_widget.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/models/mywave_details_bussiness.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:waves/contants/check_in_listing.dart';

class WaveDetailsBussinessScreen extends StatefulWidget {
  final String waveId;
  // final String image;
  final double lat;
  final double log;
  const WaveDetailsBussinessScreen(this.waveId, this.lat, this.log, {Key? key})
      : super(key: key);

  @override
  _WaveDetailsBussinessScreenState createState() =>
      _WaveDetailsBussinessScreenState();
}

class _WaveDetailsBussinessScreenState
    extends State<WaveDetailsBussinessScreen> {
  Completer<GoogleMapController> _mapController = Completer();

  late Future<MyWaveDetailsBussinessModel> _future;
  Set<Marker> markers = Set();

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

  Future<MyWaveDetailsBussinessModel> singleWavebyRegular() async {
    // Set<Marker> markers = Set();

    // image = bytes;
    var data;
    var customIcon;
    http.Response response = await http.post(Uri.parse(SingleWaveView),
        body: {'wave_id': widget.waveId, 'user_id': user_id});
    final jsonString = response.body;
    print(jsonString);
    final jsonMap = jsonDecode(jsonString);
    data = MyWaveDetailsBussinessModel.fromJson(jsonMap);
    // var imgu = MyWaveDetailsBussinessModel.fromJson(jsonMap).wave.first.avatar;
    // // print(imgurl);
    // String imgurl = "https://www.fluttercampus.com/img/car.png";
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
    //     .buffer
    //     .asUint8List();
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
                size: Size(150, 188), devicePixelRatio: 500.0),
            'assets/icons/pin.png')
        .then((d) {
      customIcon = d;
    });
    markers.add(Marker(
        //add start location marker
        markerId: MarkerId(widget.lat.toString()),
        position: LatLng(widget.lat, widget.log), //position of marker
        infoWindow: InfoWindow(
            //popup info
            // title: 'Car Point ',
            // snippet: 'Car Marker',
            ),
        // icon: BitmapDescriptor.fromBytes(bytes),
        icon: customIcon
        //Icon for Marker
        ));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    print(user_id);
    print(widget.waveId);
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
      body: FutureBuilder<MyWaveDetailsBussinessModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.wave.first;
              var date = DateFormat('yyyy-MM-dd').format(data.date);
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
                        height: 251,
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
                                  child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 48,
                                        backgroundImage: NetworkImage(
                                            data.media.first.location),
                                      )),
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
                                            data.waveName,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 15),
                                          Image.asset(
                                            'assets/icons/verified.png',
                                            scale: .9,
                                          ),
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
                                        data.wavesLocation,
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12,
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
                                        height: 20,
                                      )
                                    ])
                              ]),
                          Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: GoogleMap(
                                myLocationEnabled: true,
                                // onTap: _mapTapped,
                                initialCameraPosition: CameraPosition(
                                  target:
                                      LatLng(data.lattitude, data.longitude),
                                  zoom: 17,
                                ),
                                onMapCreated:
                                    (GoogleMapController mapController) {
                                  _mapController.complete(mapController);
                                },
                                zoomControlsEnabled: false,
                                markers: markers,
                              ))
                        ])),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'COMMENTS',
                            style: GoogleFonts.quicksand(
                                fontSize: 19, fontWeight: FontWeight.w300),
                          ),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        CheckInListing(widget.waveId));
                              },
                              child: Text(
                                'Check-In List',
                                style: GoogleFonts.quicksand(
                                    fontSize: 13,
                                    color:
                                        const Color.fromRGBO(42, 124, 202, 1),
                                    fontWeight: FontWeight.w300),
                              ))
                        ]),
                    const SizedBox(height: 5),
                    CommentScreen(data.waveComments, data.id, data.userId)
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
