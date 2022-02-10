import 'dart:convert';

import 'package:waves/models/singlewave_model.dart';

MyWaveDetailsBussinessModel myWaveDetailsBussinessModelFromJson(String str) =>
    MyWaveDetailsBussinessModel.fromJson(json.decode(str));

String myWaveDetailsBussinessModelToJson(MyWaveDetailsBussinessModel data) =>
    json.encode(data.toJson());

class MyWaveDetailsBussinessModel {
  MyWaveDetailsBussinessModel({
    required this.status,
    required this.message,
    required this.wave,
  });

  int status;
  String message;
  List<Wave> wave;

  factory MyWaveDetailsBussinessModel.fromJson(Map<String, dynamic> json) =>
      MyWaveDetailsBussinessModel(
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
    required this.eventInfo,
    required this.totalWaveCommentsCount,
    required this.waveRating,
    required this.isFriend,
    required this.isBusinessUser,
    required this.avatar,
    required this.username,
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
  String createdAt;
  String updatedAt;
  int v;
  List<WaveComment> waveComments;
  EventInfo eventInfo;
  int totalWaveCommentsCount;
  int waveRating;
  bool isFriend;
  bool isBusinessUser;
  String avatar;
  String username;

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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        v: json["__v"],
        waveComments: List<WaveComment>.from(
            json["wave_comments"].map((x) => WaveComment.fromJson(x))),
        eventInfo: EventInfo.fromJson(json["eventInfo"]),
        totalWaveCommentsCount: json["totalWaveCommentsCount"],
        waveRating: json["waveRating"],
        isFriend: json["isFriend"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "__v": v,
        "wave_comments":
            List<dynamic>.from(waveComments.map((x) => x.toJson())),
        "eventInfo": eventInfo.toJson(),
        "totalWaveCommentsCount": totalWaveCommentsCount,
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

// class WaveComment {
//   WaveComment({
//     required this.id,
//     required this.commentLikes,
//     required this.commentReply,
//     required this.userId,
//     required this.waveId,
//     required this.comment,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   String id;
//   List<String> commentLikes;
//   List<CommentReply> commentReply;
//   String userId;
//   String waveId;
//   String comment;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;

//   factory WaveComment.fromJson(Map<String, dynamic> json) => WaveComment(
//         id: json["_id"],
//         commentLikes: List<String>.from(json["comment_likes"].map((x) => x)),
//         commentReply: List<CommentReply>.from(
//             json["comment_reply"].map((x) => CommentReply.fromJson(x))),
//         userId: json["user_id"],
//         waveId: json["wave_id"],
//         comment: json["comment"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
//         "comment_reply":
//             List<dynamic>.from(commentReply.map((x) => x.toJson())),
//         "user_id": userId,
//         "wave_id": waveId,
//         "comment": comment,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "__v": v,
//       };
// }

// class CommentReply {
//   CommentReply({
//     required this.userId,
//     required this.waveId,
//     required this.comment,
//     required this.commentLikes,
//   });

//   String userId;
//   String waveId;
//   String comment;
//   List<dynamic> commentLikes;

//   factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
//         userId: json["user_id"],
//         waveId: json["wave_id"],
//         comment: json["comment"],
//         commentLikes: List<dynamic>.from(json["comment_likes"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "user_id": userId,
//         "wave_id": waveId,
//         "comment": comment,
//         "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
//       };
// }
