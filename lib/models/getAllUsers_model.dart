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
    required this.firebaseToken,
    required this.lastLoginTime,
    required this.isFaceId,
    required this.email,
    required this.roles,
    required this.username,
    required this.biography,
    required this.age,
    required this.latitude,
    // required this.dob,
    required this.longitude,
    required this.address,
  });

  String id;
  String avatar;
  bool userStatus;
  dynamic firebaseToken;
  dynamic lastLoginTime;
  bool isFaceId;
  String email;
  String roles;
  String username;
  String biography;
  String age;
  double latitude;
  // String dob;
  double longitude;
  String address;

  factory NearbyUser.fromJson(Map<String, dynamic> json) => NearbyUser(
        id: json["_id"],
        avatar: json["avatar"] ?? "null",
        userStatus: json["user_status"],
        firebaseToken: json["firebase_token"],
        lastLoginTime: json["last_login_time"],
        isFaceId: json["isFaceId"],
        email: json["email"],
        roles: json["roles"],
        username: json["username"],
        biography: json["biography"],
        age: json["age"],
        latitude: json["latitude"].toDouble(),
        // dob: json["dob"],
        longitude: json["longitude"].toDouble(),
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "user_status": userStatus,
        "firebase_token": firebaseToken,
        "last_login_time": lastLoginTime,
        "isFaceId": isFaceId,
        "email": email,
        "roles": roles,
        "username": username,
        "biography": biography,
        "age": age,
        "latitude": latitude,
        // "dob": dob,
        "longitude": longitude,
        "address": address,
      };
}
