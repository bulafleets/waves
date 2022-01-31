import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';

class MapScreenRegular extends StatefulWidget {
  final double longitute;
  final double latitute;
  final String image;
  const MapScreenRegular(
      {Key? key,
      required this.longitute,
      required this.latitute,
      required this.image})
      : super(key: key);

  @override
  _MapScreenRegularState createState() => _MapScreenRegularState();
}

class _MapScreenRegularState extends State<MapScreenRegular> {
  Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(top: 17.0, right: 5),
              child: IconButton(
                iconSize: 24,
                alignment: Alignment.bottomLeft,
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop();
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
                  onPressed: () {},
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
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            GoogleMap(
              myLocationEnabled: true,
              // onTap: _mapTapped,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitute, widget.longitute),
                zoom: 17,
              ),
              onMapCreated: (GoogleMapController mapController) {
                _mapController.complete(mapController);
              },
              zoomControlsEnabled: false,
              // onCameraMove: (position) {
              //   // _cameraPosition = cameraPosition;
              //   _mapTapped(LatLng(
              //       position.target.latitude, position.target.longitude));
              // },
              // onCameraMoveStarted: () {
              //   setState(() {
              //     isLoading = true;
              //   });
              // },
              // onCameraIdle: () {
              //   setState(() {
              //     isLoading = false;
              //   });
              // },
            ),
            Center(
                child: CircleAvatar(
                    radius: 19,
                    child: CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(widget.image))))

            // Image.network(widget.image, height: 50, width: 50)),
          ])),
    );
  }
}
