import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/map/widget/permission_denied.dart';

class MapSample extends StatefulWidget {
  final void Function(String address, String log, String lat) addressFn;
  MapSample(this.addressFn);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // late GoogleMapController _mapController;
  var initialPosition = latitude != null ? true : false;
  late CameraPosition _cameraPosition;
  late LatLng _initialPosition;
  Completer<GoogleMapController> _mapController = Completer();
  var searchAddr;
  TextEditingController _textEditingController = TextEditingController();
  late String log;
  late String lat;
  var isLoading = false;

  _mapTapped(LatLng location) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
      log = location.longitude.toString();
      lat = location.latitude.toString();

      Placemark place = placemarks[0];
      var Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      _textEditingController.text = Address.toString();
    });
  }

  @override
  void initState() {
    determinePosition(context);
    super.initState();
  }

  void determinePosition(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      // showCustomSnackBar('you_have_to_allow'.tr);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('you have to grant permission for an app to access location'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(context: context, builder: (context) => PermissionDialog());
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        initialPosition = true;
      });
      latitude = position.latitude;
      longitude = position.longitude;
      _mapTapped(LatLng(latitude, longitude));

      print(position.latitude);
      print(position.longitude);
    }
  }

  final List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              initialPosition
                  ? GoogleMap(
                      markers: _markers.toSet(),
                      // myLocationEnabled: true,
                      onTap: _mapTapped,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 17,
                      ),
                      onMapCreated: (GoogleMapController mapController) {
                        _mapController.complete(mapController);
                        final marker = Marker(
                          markerId: MarkerId('0'),
                          position: LatLng(latitude, longitude),
                        );

                        _markers.add(marker);
                      },
                      zoomControlsEnabled: false,
                      onCameraMove: (position) {
                        // _cameraPosition = cameraPosition;
                        final marker = Marker(
                          markerId: MarkerId('0'),
                          position: LatLng(position.target.latitude,
                              position.target.longitude),
                        );

                        _markers.add(marker);
                        _mapTapped(LatLng(position.target.latitude,
                            position.target.longitude));
                      },
                      onCameraMoveStarted: () {
                        setState(() {
                          isLoading = true;
                        });
                      },
                      onCameraIdle: () {
                        setState(() {
                          isLoading = false;
                        });
                      },
                    )
                  : Center(
                      child: TextButton(
                          onPressed: () {
                            determinePosition(context);
                          },
                          child: const Text('Permission Denied tap to allow')),
                    ),
              // Center(
              //     child: Image.asset('assets/pick_marker.png',
              //         height: 50, width: 50)),
              if (initialPosition)
                Positioned(
                  top: 20.0,
                  left: 10.0,
                  right: 10.0,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      onSubmitted: (val) {
                        if (val.isNotEmpty) {
                          searchNavigator();
                        }
                      },
                      // onTap: () {
                      //   _textEditingController.text = '';
                      // },
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                            color: Color.fromRGBO(98, 8, 15, 1)),
                        hintText: 'Enter Address..',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 15, top: 15),
                        prefixIcon: Icon(Icons.location_on,
                            size: 25, color: Theme.of(context).primaryColor),
                        suffixIcon: _textEditingController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _textEditingController.text = '';
                                },
                                icon: const Icon(Icons.close),
                                iconSize: 30)
                            : null,
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchAddr = val;
                        });
                      },
                    ),
                  ),
                ),
              Positioned(
                bottom: 80,
                right: 10,
                child: FloatingActionButton(
                  child: Icon(Icons.my_location,
                      color: Theme.of(context).primaryColor),
                  mini: true,
                  backgroundColor: Theme.of(context).cardColor,
                  onPressed: () => _checkPermission(),
                ),
              ),
            ])),
      ),
      floatingActionButton: keyboardIsOpened ? null : nextbutton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
    );
  }

  nextbutton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: const Color.fromRGBO(0, 69, 255, 1),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: isLoading
            ? null
            : () {
                if (_textEditingController.text.isNotEmpty) {
                  widget.addressFn(_textEditingController.text, log, lat);
                  address = _textEditingController.text;
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('please choose address'),
                      behavior: SnackBarBehavior.floating));
                }
              },
        child: const Text(
          "Pick address",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'RobotoBold'),
        ),
      ),
    );
  }

  void _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      // showCustomSnackBar('you_have_to_allow'.tr);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('you have to grant permission for an app to access location'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ));
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(context: context, builder: (context) => PermissionDialog());
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16.4746,
      );
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    }
  }

  searchNavigator() async {
    List<Location> locations =
        await locationFromAddress(_textEditingController.text);
    setState(() {
      latitude = locations[0].latitude;
      longitude = locations[0].longitude;
    });
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(locations[0].latitude, locations[0].longitude),
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    final marker = Marker(
      markerId: MarkerId('0'),
      position: LatLng(locations[0].latitude, locations[0].longitude),
    );

    _markers.add(marker);
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
