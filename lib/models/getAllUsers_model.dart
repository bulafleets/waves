// To parse this JSON data, do
//
//     final getAllUsersModel = getAllUsersModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetAllUsersModel getAllUsersModelFromJson(String str) =>
    GetAllUsersModel.fromJson(json.decode(str));

String getAllUsersModelToJson(GetAllUsersModel data) =>
    json.encode(data.toJson());

class GetAllUsersModel {
  GetAllUsersModel({
    required this.status,
    required this.nearbyUsers,
  });

  int status;
  List<NearbyUser> nearbyUsers;

  factory GetAllUsersModel.fromJson(Map<String, dynamic> json) =>
      GetAllUsersModel(
        status: json["status"],
        nearbyUsers: List<NearbyUser>.from(
            json["nearbyUsers"].map((x) => NearbyUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "nearbyUsers": List<dynamic>.from(nearbyUsers.map((x) => x.toJson())),
      };
}

class NearbyUser {
  NearbyUser({
    required this.id,
    required this.avatar,
    required this.userStatus,
    required this.isFaceId,
    required this.email,
    required this.mobileNumber,
    required this.roles,
    required this.username,
    required this.biography,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.age,
    required this.dob,
    required this.isFriend,
  });

  String id;
  String avatar;
  bool userStatus;
  bool isFaceId;
  String email;
  String mobileNumber;
  String roles;
  String username;
  String biography;
  double latitude;
  double longitude;
  String address;
  var age;
  var dob;
  bool isFriend;

  factory NearbyUser.fromJson(Map<String, dynamic> json) => NearbyUser(
        id: json["_id"],
        avatar: json["avatar"],
        userStatus: json["user_status"],
        isFaceId: json["isFaceId"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        roles: json["roles"],
        username: json["username"],
        biography: json["biography"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        address: json["address"],
        age: json["age"] == null ? null : json["age"],
        dob: json["dob"] == null ? null : json["dob"],
        isFriend: json["isFriend"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "user_status": userStatus,
        "isFaceId": isFaceId,
        "email": email,
        "mobile_number": mobileNumber,
        "roles": roles,
        "username": username,
        "biography": biography,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "age": age == null ? null : age,
        "dob": dob == null ? null : dob,
        "isFriend": isFriend,
      };
}
