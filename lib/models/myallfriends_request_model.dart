// To parse this JSON data, do
//
//     final myAllFriendRequestsModel = myAllFriendRequestsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyAllFriendRequestsModel myAllFriendRequestsModelFromJson(String str) =>
    MyAllFriendRequestsModel.fromJson(json.decode(str));

String myAllFriendRequestsModelToJson(MyAllFriendRequestsModel data) =>
    json.encode(data.toJson());

class MyAllFriendRequestsModel {
  MyAllFriendRequestsModel({
    required this.status,
    required this.myAllFriendRequests,
  });

  int status;
  List<MyAllFriendRequest> myAllFriendRequests;

  factory MyAllFriendRequestsModel.fromJson(Map<String, dynamic> json) =>
      MyAllFriendRequestsModel(
        status: json["status"],
        myAllFriendRequests: List<MyAllFriendRequest>.from(
            json["myAllFriendRequests"]
                .map((x) => MyAllFriendRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "myAllFriendRequests":
            List<dynamic>.from(myAllFriendRequests.map((x) => x.toJson())),
      };
}

class MyAllFriendRequest {
  MyAllFriendRequest({
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

  factory MyAllFriendRequest.fromJson(Map<String, dynamic> json) =>
      MyAllFriendRequest(
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
