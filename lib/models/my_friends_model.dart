// To parse this JSON data, do
//
//     final myAllFriendModel = myAllFriendModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyAllFriendModel myAllFriendModelFromJson(String str) =>
    MyAllFriendModel.fromJson(json.decode(str));

String myAllFriendModelToJson(MyAllFriendModel data) =>
    json.encode(data.toJson());

class MyAllFriendModel {
  MyAllFriendModel({
    required this.status,
    required this.myAllFriends,
  });

  int status;
  List<MyAllFriend> myAllFriends;

  factory MyAllFriendModel.fromJson(Map<String, dynamic> json) =>
      MyAllFriendModel(
        status: json["status"],
        myAllFriends: List<MyAllFriend>.from(
            json["myAllFriends"].map((x) => MyAllFriend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "myAllFriends": List<dynamic>.from(myAllFriends.map((x) => x.toJson())),
      };
}

class MyAllFriend {
  MyAllFriend({
    required this.userId,
    required this.name,
    required this.avatar,
    required this.age,
    required this.isBussinessUser,
  });

  String userId;
  String name;
  String avatar;
  int age;
  bool isBussinessUser;

  factory MyAllFriend.fromJson(Map<String, dynamic> json) => MyAllFriend(
        userId: json["user_id"],
        name: json["name"],
        avatar: json["avatar"],
        age: json["age"],
        isBussinessUser: json["isBussinessUser"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "avatar": avatar,
        "age": age,
        "isBussinessUser": isBussinessUser,
      };
}
