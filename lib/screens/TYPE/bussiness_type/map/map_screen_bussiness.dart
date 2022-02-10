import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/models/map_listing_model.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:ui' as ui;

class MapScreenBussiness extends StatefulWidget {
  const MapScreenBussiness({Key? key}) : super(key: key);

  @override
  _MapScreenBussinessState createState() => _MapScreenBussinessState();
}

class _MapScreenBussinessState extends State<MapScreenBussiness> {
  Completer<GoogleMapController> _mapController = Completer();
  late Future<MapListingModel> _future;
  Set<Marker> markers = Set();
  @override
  void initState() {
    getMarkerImage();
    determinePosition(context);
    super.initState();
  }

  Map<String, Uint8List> userIdMarkerMap = {};
  Future getMarkerImage() async {
    var data;
    http.Response response = await http.post(
      Uri.parse(MapListing),
      body: {
        'user_id': user_id,
        "lattitude": latitude.toString(),
        "longitude": longitude.toString()
      },
    );
    final jsonString = response.body;
    print(jsonString);
    final jsonMap = jsonDecode(jsonString);
    data = MapListingModel.fromJson(jsonMap).wavesListByLocation;
    for (int j = 0;
        j < MapListingModel.fromJson(jsonMap).wavesListByLocation.length;
        j++) {
      final File markerImageFile = await DefaultCacheManager().getSingleFile(
          MapListingModel.fromJson(jsonMap).wavesListByLocation[j].avatar);
      final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

      ui.Codec codec =
          await ui.instantiateImageCodec(markerImageBytes, targetWidth: 50);
      ui.FrameInfo fi = await codec.getNextFrame();

      final Uint8List markerImage =
          (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
              .buffer
              .asUint8List();

      userIdMarkerMap[MapListingModel.fromJson(jsonMap)
          .wavesListByLocation[j]
          .avatar] = markerImage;
      setState(() {
        //call your function to build google map
        markers.add(Marker(
          infoWindow: InfoWindow(
            // popup info
            title: MapListingModel.fromJson(jsonMap)
                .wavesListByLocation[j]
                .waveName,
            snippet: MapListingModel.fromJson(jsonMap)
                .wavesListByLocation[j]
                .eventDetail,
          ),
          markerId: MarkerId(
              MapListingModel.fromJson(jsonMap).wavesListByLocation[j].id),
          position: LatLng(
              MapListingModel.fromJson(jsonMap)
                  .wavesListByLocation[j]
                  .lattitude,
              MapListingModel.fromJson(jsonMap)
                  .wavesListByLocation[j]
                  .longitude),
          icon: MapListingModel.fromJson(jsonMap).wavesListByLocation[j] != null
              ? BitmapDescriptor.fromBytes(userIdMarkerMap[
                  MapListingModel.fromJson(jsonMap)
                      .wavesListByLocation[j]
                      .avatar]!)
              : BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

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
                icon: const FaIcon(FontAwesomeIcons.addressCard),
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
              markers: markers,
              // onTap: _mapTapped,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 12,
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
            // Center(
            //     child: Image.asset('assets/pick_marker.png',
            //         height: 50, width: 50)),
          ])),
    );
  }

  // Future<MapListingModel> mapListingApi() async {
  //   var data;
  //   http.Response response = await http.post(
  //     Uri.parse(MapListing),
  //     body: {'user_id': user_id},
  //   );
  //   final jsonString = response.body;
  //   print(jsonString);
  //   final jsonMap = jsonDecode(jsonString);
  //   data = MapListingModel.fromJson(jsonMap);
  //   return data;
  // }
}
