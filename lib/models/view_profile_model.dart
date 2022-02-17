// To parse this JSON data, do
//
//     final viewProfileModel = viewProfileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ViewProfileModel viewProfileModelFromJson(String str) =>
    ViewProfileModel.fromJson(json.decode(str));

String viewProfileModelToJson(ViewProfileModel data) =>
    json.encode(data.toJson());

class ViewProfileModel {
  ViewProfileModel({
    required this.status,
    required this.profile,
  });

  int status;
  Profile profile;

  factory ViewProfileModel.fromJson(Map<String, dynamic> json) =>
      ViewProfileModel(
        status: json["status"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "profile": profile.toJson(),
      };
}

class Profile {
  Profile({
    required this.id,
    required this.avatar,
    required this.isEmailVerified,
    required this.userStatus,
    required this.email,
    required this.mobileNumber,
    required this.roles,
    required this.biography,
    required this.address,
    required this.name,
  });

  String id;
  String avatar;
  bool isEmailVerified;
  bool userStatus;
  String email;
  String mobileNumber;
  String roles;
  String biography;
  String address;
  String name;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["_id"],
        avatar: json["avatar"],
        isEmailVerified: json["isEmailVerified"],
        userStatus: json["user_status"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        roles: json["roles"],
        biography: json["biography"],
        address: json["address"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "isEmailVerified": isEmailVerified,
        "user_status": userStatus,
        "email": email,
        "mobile_number": mobileNumber,
        "roles": roles,
        "biography": biography,
        "address": address,
        "name": name,
      };
}
