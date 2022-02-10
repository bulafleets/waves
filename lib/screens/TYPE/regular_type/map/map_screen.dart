import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waves/contants/common_params.dart';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'dart:ui' as ui;

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
  Set<Marker> markers = Set();
  Future<void> _data() async {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(widget.image);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    int size = 150;
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
    BitmapDescriptor ico =
        BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
    // final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    // ui.Codec codec =
    //     await ui.instantiateImageCodec(markerImageBytes, targetWidth: 80);
    // ui.FrameInfo fi = await codec.getNextFrame();

    // final Uint8List markerImage =
    //     (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
    //         .buffer
    //         .asUint8List();
    setState(() {
      markers.add(Marker(
          //add start location marker
          markerId: MarkerId(widget.longitute.toString()),
          position:
              LatLng(widget.latitute, widget.longitute), //position of marker
          infoWindow: const InfoWindow(
              //popup info
              // title: 'Car Point ',
              // snippet: 'Car Marker',
              ),
          // icon: BitmapDescriptor.fromBytes(markerImage),
          icon: ico
          //Icon for Marker
          ));
    });
  }

  @override
  void initState() {
    _data();
    // TODO: implement initState
    super.initState();
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
              markers: markers,
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
            //     child: CircleAvatar(
            //         radius: 19,
            //         child: CircleAvatar(
            //             radius: 17,
            //             backgroundImage: NetworkImage(widget.image))))

            // Image.network(widget.image, height: 50, width: 50)),
          ])),
    );
  }
}
