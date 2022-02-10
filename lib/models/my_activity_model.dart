import 'dart:convert';

MyactivityModel myactivityModelFromJson(String str) =>
    MyactivityModel.fromJson(json.decode(str));

String myactivityModelToJson(MyactivityModel data) =>
    json.encode(data.toJson());

class MyactivityModel {
  MyactivityModel({
    required this.status,
    required this.myActivityList,
    required this.message,
  });

  int status;
  List<MyActivityList> myActivityList;
  String message;

  factory MyactivityModel.fromJson(Map<String, dynamic> json) =>
      MyactivityModel(
        status: json["status"],
        myActivityList: List<MyActivityList>.from(
            json["MyActivityList"].map((x) => MyActivityList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "MyActivityList":
            List<dynamic>.from(myActivityList.map((x) => x.toJson())),
        "message": message,
      };
}

class MyActivityList {
  MyActivityList({
    required this.id,
    required this.waveId,
    required this.activityType,
    required this.createdAt,
    required this.userName,
    required this.roles,
    required this.profileImage,
    required this.waveImage,
    required this.waveName,
    required this.wavesLocation,
    required this.eventName,
  });

  String id;
  String waveId;
  String activityType;
  DateTime createdAt;
  String userName;
  String roles;
  String profileImage;
  List<WaveImage> waveImage;
  String waveName;
  String wavesLocation;
  String eventName;

  factory MyActivityList.fromJson(Map<String, dynamic> json) => MyActivityList(
        id: json["_id"],
        waveId: json["wave_id"] ?? json['check_in_id'],
        activityType: json["activity_type"],
        createdAt: DateTime.parse(json["created_at"]),
        userName: json["user_name"],
        roles: json["roles"],
        profileImage: json["profile_image"],
        waveImage: List<WaveImage>.from(
            json["wave_image"].map((x) => WaveImage.fromJson(x))),
        waveName: json["wave_name"],
        wavesLocation: json["waves_location"],
        eventName: json["event_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "wave_id": waveId,
        "activity_type": activityType,
        "created_at": createdAt.toIso8601String(),
        "user_name": userName,
        "roles": roles,
        "profile_image": profileImage,
        "wave_image": List<dynamic>.from(waveImage.map((x) => x.toJson())),
        "wave_name": waveName,
        "waves_location": wavesLocation,
        "event_name": eventName,
      };
}

class WaveImage {
  WaveImage({
    required this.location,
  });

  String location;

  factory WaveImage.fromJson(Map<String, dynamic> json) => WaveImage(
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
      };
}
