import 'dart:convert';

WaveListingRegularModel waveListingRegularModelFromJson(String str) =>
    WaveListingRegularModel.fromJson(json.decode(str));

String waveListingRegularModelToJson(WaveListingRegularModel data) =>
    json.encode(data.toJson());

class WaveListingRegularModel {
  WaveListingRegularModel({
    required this.status,
    required this.message,
    required this.wavesList,
  });

  int status;
  String message;
  List<WavesList> wavesList;

  factory WaveListingRegularModel.fromJson(Map<String, dynamic> json) =>
      WaveListingRegularModel(
        status: json["status"],
        message: json["message"],
        wavesList: List<WavesList>.from(
            json["WavesList"].map((x) => WavesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "WavesList": List<dynamic>.from(wavesList.map((x) => x.toJson())),
      };
}

class WavesList {
  WavesList({
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
    required this.eventInfo,
    required this.waveComments,
    required this.totalWaveCommentsCount,
    required this.waveRating,
    required this.isFriendAdd,
    required this.isBusinessUser,
    required this.avatar,
    required this.username,
  });

  String id;
  List<dynamic> media;
  List<String> inviteTags;
  List<dynamic> friendTags;
  String userId;
  String userType;
  String eventId;
  String date;
  bool isFriend;
  bool isInvite;
  double lattitude;
  double longitude;
  String wavesLocation;
  String eventDetail;
  Location location;
  var startTime;
  var endTime;
  String createdAt;
  String updatedAt;
  int v;
  List<EventInfo> eventInfo;
  List<dynamic> waveComments;
  int totalWaveCommentsCount;
  int waveRating;
  bool isFriendAdd;
  bool isBusinessUser;
  String avatar;
  String username;

  factory WavesList.fromJson(Map<String, dynamic> json) => WavesList(
        id: json["_id"],
        media: List<dynamic>.from(json["media"].map((x) => x)),
        inviteTags: List<String>.from(json["invite_tags"].map((x) => x)),
        friendTags: List<dynamic>.from(json["friend_tags"].map((x) => x)),
        userId: json["user_id"],
        userType: json["user_type"],
        eventId: json["event_id"],
        date: json["date"],
        isFriend: json["isFriend"],
        isInvite: json["isInvite"],
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        wavesLocation: json["waves_location"],
        eventDetail: json["event_detail"],
        location: Location.fromJson(json["location"]),
        startTime: json["start_time"] == null ? null : json["start_time"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        v: json["__v"],
        eventInfo: List<EventInfo>.from(
            json["eventInfo"].map((x) => EventInfo.fromJson(x))),
        waveComments: List<dynamic>.from(json["wave_comments"].map((x) => x)),
        totalWaveCommentsCount: json["totalWaveCommentsCount"],
        waveRating: json["waveRating"],
        isFriendAdd: json["isFriendAdd"],
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
        "date": date,
        "isFriend": isFriend,
        "isInvite": isInvite,
        "lattitude": lattitude,
        "longitude": longitude,
        "waves_location": wavesLocation,
        "event_detail": eventDetail,
        "location": location.toJson(),
        "start_time": startTime == null ? null : startTime,
        "end_time": endTime == null ? null : endTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "__v": v,
        "eventInfo": List<dynamic>.from(eventInfo.map((x) => x.toJson())),
        "wave_comments": List<dynamic>.from(waveComments.map((x) => x)),
        "totalWaveCommentsCount": totalWaveCommentsCount,
        "waveRating": waveRating,
        "isFriendAdd": isFriendAdd,
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
