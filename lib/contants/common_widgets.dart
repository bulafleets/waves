import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waves/contants/common_params.dart';
import 'package:waves/screens/map/widget/permission_denied.dart';
import 'package:http/http.dart' as http;

void determinePosition(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    // showCustomSnackBar('you_have_to_allow'.tr);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('you_have_to_allow'), behavior: SnackBarBehavior.floating
        // backgroundColor: Colors.green,
        ));
  } else if (permission == LocationPermission.deniedForever) {
    showDialog(context: context, builder: (context) => PermissionDialog());
  } else {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    print(position.latitude);
    print(position.longitude);
  }
}
