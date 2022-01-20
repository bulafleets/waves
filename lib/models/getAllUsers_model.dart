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
    // required this.lastLoginTime,
    required this.isFaceId,
    required this.email,
    // required this.roles,
    required this.username,
    required this.biography,
    required this.age,
    required this.latitude,
    // required this.dob,
    required this.longitude,
    required this.address,
    required this.mobileNumber,
    required this.isFriend,
  });

  String id;
  var avatar;
  bool userStatus;
  dynamic firebaseToken;
  // DateTime lastLoginTime;
  bool isFaceId;
  String email;
  // Roles roles;
  String username;
  String biography;
  int age;
  double latitude;
  // String dob;
  double longitude;
  String address;
  String mobileNumber;
  bool isFriend;

  factory NearbyUser.fromJson(Map<String, dynamic> json) => NearbyUser(
        id: json["_id"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        userStatus: json["user_status"],
        firebaseToken: json["firebase_token"],
        // lastLoginTime: json["last_login_time"] == null ? null : DateTime.parse(json["last_login_time"]),
        isFaceId: json["isFaceId"],
        email: json["email"],
        // roles: rolesValues.map[json["roles"]],
        username: json["username"],
        biography: json["biography"],
        age: json["age"],
        latitude: json["latitude"].toDouble(),
        // dob: json["dob"] == null ? null : json["dob"],
        longitude: json["longitude"].toDouble(),
        address: json["address"],
        mobileNumber: json["mobile_number"],
        isFriend: json["isFriend"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar == null ? null : avatar,
        "user_status": userStatus,
        "firebase_token": firebaseToken,
        // "last_login_time": lastLoginTime == null ? null : lastLoginTime.toIso8601String(),
        "isFaceId": isFaceId,
        "email": email,
        // "roles": rolesValues.reverse[roles],
        "username": username,
        "biography": biography,
        "age": age,
        "latitude": latitude,
        // "dob": dob == null ? null : dob,
        "longitude": longitude,
        "address": address,
        "mobile_number": mobileNumber,
        "isFriend": isFriend,
      };
}
