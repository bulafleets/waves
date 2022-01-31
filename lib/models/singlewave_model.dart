import 'dart:convert';

SingleWaveModel singleWaveModelFromJson(String str) =>
    SingleWaveModel.fromJson(json.decode(str));

String singleWaveModelToJson(SingleWaveModel data) =>
    json.encode(data.toJson());

class SingleWaveModel {
  SingleWaveModel({
    required this.status,
    required this.message,
    required this.wave,
  });

  int status;
  String message;
  List<Wave> wave;

  factory SingleWaveModel.fromJson(Map<String, dynamic> json) =>
      SingleWaveModel(
        status: json["status"],
        message: json["message"],
        wave: List<Wave>.from(json["wave"].map((x) => Wave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "wave": List<dynamic>.from(wave.map((x) => x.toJson())),
      };
}

class Wave {
  Wave({
    required this.id,
    required this.media,
    required this.inviteTags,
    required this.friendTags,
    required this.userId,
    required this.userType,
    required this.eventId,
    required this.date,
    required this.isFriend,
    required this.isInvite,
    required this.lattitude,
    required this.longitude,
    required this.wavesLocation,
    required this.eventDetail,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.waveComments,
    required this.eventInfo,
    required this.totalWaveCommentsCount,
    required this.waveRating,
    required this.isBusinessUser,
    required this.avatar,
    required this.username,
  });

  String id;
  List<dynamic> media;
  List<dynamic> inviteTags;
  List<dynamic> friendTags;
  String userId;
  String userType;
  String eventId;
  DateTime date;
  bool isFriend;
  bool isInvite;
  double lattitude;
  double longitude;
  String wavesLocation;
  String eventDetail;
  Location location;
  String startTime;
  String endTime;
  String createdAt;
  String updatedAt;
  int v;
  List<dynamic> waveComments;
  EventInfo eventInfo;
  int totalWaveCommentsCount;
  int waveRating;
  bool isBusinessUser;
  String avatar;
  String username;

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        id: json["_id"],
        media: List<dynamic>.from(json["media"].map((x) => x)),
        inviteTags: List<dynamic>.from(json["invite_tags"].map((x) => x)),
        friendTags: List<dynamic>.from(json["friend_tags"].map((x) => x)),
        userId: json["user_id"],
        userType: json["user_type"],
        eventId: json["event_id"],
        date: DateTime.parse(json["date"]),
        isFriend: json["isFriend"],
        isInvite: json["isInvite"],
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        wavesLocation: json["waves_location"],
        eventDetail: json["event_detail"],
        location: Location.fromJson(json["location"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        v: json["__v"],
        waveComments: List<dynamic>.from(json["wave_comments"].map((x) => x)),
        eventInfo: EventInfo.fromJson(json["eventInfo"]),
        totalWaveCommentsCount: json["totalWaveCommentsCount"],
        waveRating: json["waveRating"],
        isBusinessUser: json["isBusinessUser"],
        avatar: json["avatar"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "media": List<dynamic>.from(media.map((x) => x)),
        "invite_tags": List<dynamic>.from(inviteTags.map((x) => x)),
        "friend_tags": List<dynamic>.from(friendTags.map((x) => x)),
        "user_id": userId,
        "user_type": userType,
        "event_id": eventId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "isFriend": isFriend,
        "isInvite": isInvite,
        "lattitude": lattitude,
        "longitude": longitude,
        "waves_location": wavesLocation,
        "event_detail": eventDetail,
        "location": location.toJson(),
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "__v": v,
        "wave_comments": List<dynamic>.from(waveComments.map((x) => x)),
        "eventInfo": eventInfo.toJson(),
        "totalWaveCommentsCount": totalWaveCommentsCount,
        "waveRating": waveRating,
        "isBusinessUser": isBusinessUser,
        "avatar": avatar,
        "username": username,
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
