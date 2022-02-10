// To parse this JSON data, do
//
//     final checkInModel = checkInModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CheckInModel checkInModelFromJson(String str) =>
    CheckInModel.fromJson(json.decode(str));

String checkInModelToJson(CheckInModel data) => json.encode(data.toJson());

class CheckInModel {
  CheckInModel({
    required this.status,
    required this.checkInList,
    required this.message,
  });

  int status;
  List<CheckInList> checkInList;
  String message;

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
        status: json["status"],
        checkInList: List<CheckInList>.from(
            json["checkInList"].map((x) => CheckInList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "checkInList": List<dynamic>.from(checkInList.map((x) => x.toJson())),
        "message": message,
      };
}

class CheckInList {
  CheckInList({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.waveMedia,
    required this.lattitude,
    required this.longitude,
  });

  String id;
  DateTime createdAt;
  String name;
  String avatar;
  List<dynamic> waveMedia;
  double lattitude;
  double longitude;

  factory CheckInList.fromJson(Map<String, dynamic> json) => CheckInList(
        id: json["_id"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        avatar: json["avatar"],
        waveMedia: List<dynamic>.from(json["wave_media"].map((x) => x)),
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt.toIso8601String(),
        "name": name,
        "avatar": avatar,
        "wave_media": List<dynamic>.from(waveMedia.map((x) => x)),
        "lattitude": lattitude,
        "longitude": longitude,
      };
}
