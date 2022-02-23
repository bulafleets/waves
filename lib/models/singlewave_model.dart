// To parse this JSON data, do
//
//     final singleWaveModel = singleWaveModelFromJson(jsonString);

import 'package:meta/meta.dart';
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
    required this.waveComments,
    required this.userInfo,
    required this.eventInfo,
    required this.totalWaveCommentsCount,
    required this.isCheckedIn,
    required this.waveRating,
    required this.isFriend,
    required this.isBusinessUser,
    required this.avatar,
    required this.username,
  });

  var id;
  List<Media> media;
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
  var isDiscountFollower;
  var isDiscountAll;
  var discountDetail;
  var isAdult;
  var isSendFollower;
  var radius;
  var additionalDetail;
  String startTime;
  String endTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<WaveComment> waveComments;
  UserInfo userInfo;
  EventInfo eventInfo;
  int totalWaveCommentsCount;
  bool isCheckedIn;
  var waveRating;
  var isFriend;
  bool isBusinessUser;
  String avatar;
  String username;

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        id: json["_id"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
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
        waveComments: List<WaveComment>.from(
            json["wave_comments"].map((x) => WaveComment.fromJson(x))),
        userInfo: UserInfo.fromJson(json["userInfo"]),
        eventInfo: EventInfo.fromJson(json["eventInfo"]),
        totalWaveCommentsCount: json["totalWaveCommentsCount"],
        isCheckedIn: json["isCheckedIn"],
        waveRating: json["waveRating"],
        isFriend: json["isFriend"],
        isBusinessUser: json["isBusinessUser"],
        avatar: json["avatar"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "invite_tags": List<dynamic>.from(inviteTags.map((x) => x)),
        "friend_tags": List<dynamic>.from(friendTags.map((x) => x)),
        "user_id": userId,
        "event_id": eventId,
        "date": date.toIso8601String(),
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
        "wave_comments":
            List<dynamic>.from(waveComments.map((x) => x.toJson())),
        "userInfo": userInfo.toJson(),
        "eventInfo": eventInfo.toJson(),
        "totalWaveCommentsCount": totalWaveCommentsCount,
        "isCheckedIn": isCheckedIn,
        "waveRating": waveRating,
        "isFriend": isFriend,
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

class Media {
  Media({
    required this.location,
  });

  String location;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
      };
}

class UserInfo {
  UserInfo({
    required this.id,
    required this.avatar,
    required this.otp,
    required this.isEmailVerified,
    required this.userStatus,
    required this.noOfLoggedin,
    required this.lastLoginTime,
    required this.isFaceId,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.roles,
    required this.username,
    required this.biography,
    required this.age,
    required this.latitude,
    required this.dob,
    required this.longitude,
    required this.address,
    required this.location,
    required this.v,
  });

  String id;
  String avatar;
  String otp;
  bool isEmailVerified;
  bool userStatus;
  int noOfLoggedin;
  dynamic lastLoginTime;
  bool isFaceId;
  String email;
  String password;
  String mobileNumber;
  String roles;
  String username;
  String biography;
  var age;
  double latitude;
  var dob;
  double longitude;
  String address;
  Location location;
  int v;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["_id"],
        avatar: json["avatar"],
        otp: json["otp"],
        isEmailVerified: json["isEmailVerified"],
        userStatus: json["user_status"],
        noOfLoggedin: json["no_of_loggedin"],
        lastLoginTime: json["last_login_time"],
        isFaceId: json["isFaceId"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobile_number"],
        roles: json["roles"],
        username: json["username"],
        biography: json["biography"],
        age: json["age"],
        latitude: json["latitude"].toDouble(),
        dob: json["dob"],
        longitude: json["longitude"].toDouble(),
        address: json["address"],
        location: Location.fromJson(json["location"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "otp": otp,
        "isEmailVerified": isEmailVerified,
        "user_status": userStatus,
        "no_of_loggedin": noOfLoggedin,
        "last_login_time": lastLoginTime,
        "isFaceId": isFaceId,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "roles": roles,
        "username": username,
        "biography": biography,
        "age": age,
        "latitude": latitude,
        "dob": dob,
        "longitude": longitude,
        "address": address,
        "location": location.toJson(),
        "__v": v,
      };
}

class WaveComment {
  WaveComment({
    required this.id,
    required this.commentLikes,
    required this.commentReply,
    required this.userId,
    required this.waveId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
    required this.username,
  });

  String id;
  List<String> commentLikes;
  List<CommentReply> commentReply;
  String userId;
  String waveId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
  String avatar;
  String username;

  factory WaveComment.fromJson(Map<String, dynamic> json) => WaveComment(
        id: json["_id"],
        commentLikes: List<String>.from(json["comment_likes"].map((x) => x)),
        commentReply: List<CommentReply>.from(
            json["comment_reply"].map((x) => CommentReply.fromJson(x))),
        userId: json["user_id"],
        waveId: json["wave_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        avatar: json["avatar"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
        "comment_reply":
            List<CommentReply>.from(commentReply.map((x) => x.toJson())),
        "user_id": userId,
        "wave_id": waveId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "avatar": avatar,
        "username": username,
      };
}

class CommentReply {
  CommentReply({
    required this.userId,
    required this.waveId,
    required this.comment,
    required this.commentLikes,
    required this.username,
    required this.avatar,
    required this.createdAt,
  });

  String userId;
  String waveId;
  String comment;
  List<dynamic> commentLikes;
  String username;
  String avatar;
  DateTime createdAt;

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
        userId: json["user_id"],
        waveId: json["wave_id"],
        comment: json["comment"],
        commentLikes: List<dynamic>.from(json["comment_likes"].map((x) => x)),
        username: json["username"] == null ? 'null' : json["username"],
        avatar: json["avatar"] == null ? 'null' : json["avatar"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "wave_id": waveId,
        "comment": comment,
        "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
        "username": username == null ? 'null' : username,
        "avatar": avatar == null ? 'null' : avatar,
        "created_at": createdAt == null ? 'null' : createdAt.toIso8601String(),
      };
}
