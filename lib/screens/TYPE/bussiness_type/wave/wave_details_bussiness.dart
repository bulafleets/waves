import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/check_in.dart';
import 'package:waves/contants/comment_widget.dart';
import 'package:waves/contants/leave_comment.dart';
import 'package:waves/contants/review_comment.dart';
import 'package:waves/screens/TYPE/regular_type/map/map_screen.dart';
import 'dart:async';

class WaveDetailsBussinessScreen extends StatefulWidget {
  const WaveDetailsBussinessScreen({Key? key}) : super(key: key);

  @override
  _WaveDetailsBussinessScreenState createState() =>
      _WaveDetailsBussinessScreenState();
}

class _WaveDetailsBussinessScreenState
    extends State<WaveDetailsBussinessScreen> {
  Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
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
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    // width: 102,
                    // color: Colors.black,
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/564x/bd/cd/4e/bdcd4e097d609543724874b01aa91c76.jpg"),
                        )),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Wave Name',
                              style: GoogleFonts.quicksand(
                                  fontSize: 19, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 15),
                            FaIcon(
                              FontAwesomeIcons.shieldAlt,
                              color: Color.fromRGBO(0, 149, 242, 1),
                              size: 18,
                            ),
                            SizedBox(width: 30),
                            Text(
                              '2m',
                              style: GoogleFonts.quicksand(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Location Name',
                          style: GoogleFonts.quicksand(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Event Type  21/01/2021  2:00pm - 6:00pm',
                          style: GoogleFonts.quicksand(
                              fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ])
                ]),
                Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width - 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: GoogleMap(
                      myLocationEnabled: true,
                      // onTap: _mapTapped,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(26.838055, 75.7952836),
                        zoom: 17,
                      ),
                      onMapCreated: (GoogleMapController mapController) {
                        _mapController.complete(mapController);
                      },
                      zoomControlsEnabled: false,
                    ))
              ])),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(
              'COMMENTS',
              style: GoogleFonts.quicksand(
                  fontSize: 19, fontWeight: FontWeight.w300),
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => const LeaveComment());
                },
                child: Text(
                  'Check-In List',
                  style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: const Color.fromRGBO(42, 124, 202, 1),
                      fontWeight: FontWeight.w300),
                ))
          ]),
          const SizedBox(height: 5),
          const CommentScreen()
        ],
      ),
    );
  }
}
