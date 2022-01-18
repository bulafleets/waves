import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/widget/permission_denied.dart';

class MapSample extends StatefulWidget {
  final void Function(String address) addressFn;
  MapSample(this.addressFn);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;
  late LatLng _initialPosition;
  Completer<GoogleMapController> _mapController = Completer();
  var searchAddr;
  TextEditingController _textEditingController = TextEditingController();
  var isLoading = false;

  _mapTapped(LatLng location) async {
    print('ss');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;

      print(placemarks);
      Placemark place = placemarks[0];
      var Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      _textEditingController.text = Address.toString();

      print(Address);
    });
  }

  @override
  void initState() {
    _mapTapped(LatLng(latitude, longitude));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              GoogleMap(
                myLocationEnabled: true,
                onTap: _mapTapped,
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 17,
                ),
                onMapCreated: (GoogleMapController mapController) {
                  _mapController.complete(mapController);
                },
                zoomControlsEnabled: false,
                onCameraMove: (position) {
                  // _cameraPosition = cameraPosition;
                  _mapTapped(LatLng(
                      position.target.latitude, position.target.longitude));
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
              ),
              Center(
                  child: Image.asset('assets/pick_marker.png',
                      height: 50, width: 50)),
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
                    //    onTap: () {
                    //       _textEditingController.text = '';
                    //     },
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter Address..',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 15, top: 15),
                      prefixIcon: Icon(Icons.location_on,
                          size: 25, color: Theme.of(context).primaryColor),
                      suffixIcon: IconButton(
                          onPressed: () => searchNavigator(),
                          icon: const Icon(Icons.search),
                          iconSize: 30),
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
                  widget.addressFn(_textEditingController.text);
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
          content: Text('you_have_to_allow'),
          behavior: SnackBarBehavior.floating
          // backgroundColor: Colors.green,
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
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    print(locations);
  }
}
