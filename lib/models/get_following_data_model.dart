// To parse this JSON data, do
//
//     final getFollowingDataModel = getFollowingDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetFollowingDataModel getFollowingDataModelFromJson(String str) =>
    GetFollowingDataModel.fromJson(json.decode(str));

String getFollowingDataModelToJson(GetFollowingDataModel data) =>
    json.encode(data.toJson());

class GetFollowingDataModel {
  GetFollowingDataModel({
    required this.status,
    required this.message,
    required this.followers,
  });

  int status;
  String message;
  List<Follower> followers;

  factory GetFollowingDataModel.fromJson(Map<String, dynamic> json) =>
      GetFollowingDataModel(
        status: json["status"],
        message: json["message"],
        followers: List<Follower>.from(
            json["followers"].map((x) => Follower.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
      };
}

class Follower {
  Follower({
    required this.id,
    required this.user,
  });

  String id;
  User user;

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
        id: json["_id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.avatar,
    required this.username,
  });

  String id;
  String avatar;
  String username;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        avatar: json["avatar"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "username": username,
      };
}
