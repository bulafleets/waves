import 'dart:convert';

MyWaveModel myWaveModelFromJson(String str) =>
    MyWaveModel.fromJson(json.decode(str));

String myWaveModelToJson(MyWaveModel data) => json.encode(data.toJson());

class MyWaveModel {
  MyWaveModel({
    required this.status,
    required this.message,
    required this.waves,
  });

  int status;
  String message;
  List<Wave> waves;

  factory MyWaveModel.fromJson(Map<String, dynamic> json) => MyWaveModel(
        status: json["status"],
        message: json["message"],
        waves: List<Wave>.from(json["waves"].map((x) => Wave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "waves": List<dynamic>.from(waves.map((x) => x.toJson())),
      };
}

class Wave {
  Wave({
    required this.id,
    required this.media,
    required this.inviteTags,
    required this.friendTags,
    required this.userId,
    required this.eventId,
    required this.date,
    required this.lattitude,
    required this.longitude,
    required this.wavesLocation,
    required this.eventDetail,
    required this.location,
    required this.userType,
    required this.waveName,
    required this.isDiscountFollower,
    required this.isDiscountAll,
    required this.discountDetail,
    required this.isAdult,
    required this.isSendFollower,
    required this.radius,
    required this.additionalDetail,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.eventInfo,
  });

  String id;
  List<dynamic> media;
  List<dynamic> inviteTags;
  List<dynamic> friendTags;
  String userId;
  String eventId;
  DateTime date;
  double lattitude;
  double longitude;
  String wavesLocation;
  String eventDetail;
  Location location;
  String userType;
  String waveName;
  bool isDiscountFollower;
  bool isDiscountAll;
  String discountDetail;
  bool isAdult;
  bool isSendFollower;
  int radius;
  String additionalDetail;
  String startTime;
  String endTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<EventInfo> eventInfo;

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        id: json["_id"],
        media: List<dynamic>.from(json["media"].map((x) => x)),
        inviteTags: List<dynamic>.from(json["invite_tags"].map((x) => x)),
        friendTags: List<dynamic>.from(json["friend_tags"].map((x) => x)),
        userId: json["user_id"],
        eventId: json["event_id"],
        date: DateTime.parse(json["date"]),
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        wavesLocation: json["waves_location"],
        eventDetail: json["event_detail"],
        location: Location.fromJson(json["location"]),
        userType: json["user_type"],
        waveName: json["wave_name"],
        isDiscountFollower: json["isDiscountFollower"],
        isDiscountAll: json["isDiscountAll"],
        discountDetail: json["discount_detail"],
        isAdult: json["isAdult"],
        isSendFollower: json["isSendFollower"],
        radius: json["radius"],
        additionalDetail: json["additional_detail"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        eventInfo: List<EventInfo>.from(
            json["eventInfo"].map((x) => EventInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "media": List<dynamic>.from(media.map((x) => x)),
        "invite_tags": List<dynamic>.from(inviteTags.map((x) => x)),
        "friend_tags": List<dynamic>.from(friendTags.map((x) => x)),
        "user_id": userId,
        "event_id": eventId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "lattitude": lattitude,
        "longitude": longitude,
        "waves_location": wavesLocation,
        "event_detail": eventDetail,
        "location": location.toJson(),
        "user_type": userType,
        "wave_name": waveName,
        "isDiscountFollower": isDiscountFollower,
        "isDiscountAll": isDiscountAll,
        "discount_detail": discountDetail,
        "isAdult": isAdult,
        "isSendFollower": isSendFollower,
        "radius": radius,
        "additional_detail": additionalDetail,
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
        "eventInfo": List<dynamic>.from(eventInfo.map((x) => x.toJson())),
      };
}

class EventInfo {
  EventInfo({
    required this.id,
    required this.eventName,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String eventName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
        id: json["_id"],
        eventName: json["event_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "event_name": eventName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
    required this.id,
  });

  String type;
  List<double> coordinates;
  String id;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "_id": id,
      };
}
