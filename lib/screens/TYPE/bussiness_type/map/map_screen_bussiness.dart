import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/contants/common_widgets.dart';
import 'package:waves/contants/map_pop_screen.dart';
import 'package:waves/models/map_listing_model.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:waves/screens/TYPE/bussiness_type/wave/create_wave_bussiness.dart';
import 'package:waves/screens/TYPE/regular_type/wave/create_wave.dart';

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
    data = MapListingModel.fromJson(jsonMap).wavesList;
    for (int j = 0;
        j < MapListingModel.fromJson(jsonMap).wavesList.length;
        j++) {
      var modelData = MapListingModel.fromJson(jsonMap).wavesList[j];
      // final File markerImageFile = await DefaultCacheManager()
      //     .getSingleFile(MapListingModel.fromJson(jsonMap).wavesList[j].avatar);
      // final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

      // ui.Codec codec =
      //     await ui.instantiateImageCodec(markerImageBytes, targetWidth: 50);
      // ui.FrameInfo fi = await codec.getNextFrame();

      // final Uint8List markerImage =
      //     (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      //         .buffer
      //         .asUint8List();
      final File markerImageFile = await DefaultCacheManager()
          .getSingleFile(MapListingModel.fromJson(jsonMap).wavesList[j].avatar);
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      int size = 200;
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..color;
      final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );
      final double radius = size / 2;

      //make canvas clip path to prevent image drawing over the circle
      final Path clipPath = Path();
      clipPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          const Radius.circular(100)));
      clipPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
          const Radius.circular(100)));
      canvas.clipPath(clipPath);

      //paintImage
      final Uint8List imageUint8List = await markerImageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
      final ui.FrameInfo imageFI = await codec.getNextFrame();
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          image: imageFI.image);

      //convert canvas as PNG bytes
      final _image = await pictureRecorder
          .endRecording()
          .toImage(size, (size * 1.1).toInt());
      final data = await _image.toByteData(format: ui.ImageByteFormat.png);

      //convert PNG bytes as BitmapDescriptor
      final Uint8List markerImage = data!.buffer.asUint8List();
      // BitmapDescriptor.fromBytes(data!.buffer.asUint8List()) as Uint8List;

      userIdMarkerMap[MapListingModel.fromJson(jsonMap).wavesList[j].avatar] =
          markerImage;
      setState(() {
        //call your function to build google map
        markers.add(Marker(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => MapPopScreen(
                    image: modelData.media.first.location,
                    waveName: modelData.waveName,
                    waveDetail: modelData.eventDetail,
                    waveHistory: ''));
          },
          // infoWindow: InfoWindow(
          //   // popup info
          //   title: MapListingModel.fromJson(jsonMap)
          //       .wavesList[j]
          //       .waveName,
          //   snippet: MapListingModel.fromJson(jsonMap)
          //       .wavesList[j]
          //       .eventDetail,
          // ),
          markerId: MarkerId(MapListingModel.fromJson(jsonMap).wavesList[j].id),
          position: LatLng(
              MapListingModel.fromJson(jsonMap).wavesList[j].lattitude,
              MapListingModel.fromJson(jsonMap).wavesList[j].longitude),
          icon: MapListingModel.fromJson(jsonMap).wavesList[j] != null
              ? BitmapDescriptor.fromBytes(userIdMarkerMap[
                  MapListingModel.fromJson(jsonMap).wavesList[j].avatar]!)
              : BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            // leading: Padding(
            //   padding: const EdgeInsets.only(top: 17.0, right: 5),
            //   child: IconButton(
            //     iconSize: 24,
            //     alignment: Alignment.bottomLeft,
            //     icon: const FaIcon(FontAwesomeIcons.addressCard),
            //     onPressed: () {},
            //   ),
            // ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, right: 5),
                child: IconButton(
                  iconSize: 24,
                  alignment: Alignment.bottomLeft,
                  icon: const FaIcon(FontAwesomeIcons.plus),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AccountType == 'REGULAR'
                            ? const CreateWaveScreen()
                            : const CreateWaveScreenBussiness()));
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
