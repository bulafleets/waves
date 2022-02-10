import 'dart:convert';

MapListingModel mapListingModelFromJson(String str) =>
    MapListingModel.fromJson(json.decode(str));

String mapListingModelToJson(MapListingModel data) =>
    json.encode(data.toJson());

class MapListingModel {
  MapListingModel({
    required this.status,
    required this.message,
    required this.wavesListByLocation,
  });

  int status;
  String message;
  List<WavesListByLocation> wavesListByLocation;

  factory MapListingModel.fromJson(Map<String, dynamic> json) =>
      MapListingModel(
        status: json["status"],
        message: json["message"],
        wavesListByLocation: List<WavesListByLocation>.from(
            json["WavesListByLocation"]
                .map((x) => WavesListByLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "WavesListByLocation":
            List<dynamic>.from(wavesListByLocation.map((x) => x.toJson())),
      };
}

class WavesListByLocation {
  WavesListByLocation({
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
    required this.waveName,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.userInfo,
    required this.eventInfo,
    required this.waveComments,
    required this.totalWaveCommentsCount,
    required this.waveRating,
    required this.isFriendAdd,
    required this.isCheckedIn,
    required this.isBusinessUser,
    required this.avatar,
    required this.username,
  });

  String id;
  List<Media> media;
  List<dynamic> inviteTags;
  List<dynamic> friendTags;
  String userId;
  String userType;
  String eventId;
  DateTime date;
  bool isFriend;
  bool isInvite;
  double lattitude;
  double longitude;
  String wavesLocation;
  String eventDetail;
  Location location;
  String startTime;
  String endTime;
  String waveName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  UserInfo userInfo;
  EventInfo eventInfo;
  List<WaveComment> waveComments;
  int totalWaveCommentsCount;
  int waveRating;
  bool isFriendAdd;
  bool isCheckedIn;
  bool isBusinessUser;
  String avatar;
  String username;

  factory WavesListByLocation.fromJson(Map<String, dynamic> json) =>
      WavesListByLocation(
        id: json["_id"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        inviteTags: List<dynamic>.from(json["invite_tags"].map((x) => x)),
        friendTags: List<dynamic>.from(json["friend_tags"].map((x) => x)),
        userId: json["user_id"],
        userType: json["user_type"],
        eventId: json["event_id"],
        date: DateTime.parse(json["date"]),
        isFriend: json["isFriend"],
        isInvite: json["isInvite"],
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        wavesLocation: json["waves_location"],
        eventDetail: json["event_detail"],
        location: Location.fromJson(json["location"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        waveName: json["wave_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        userInfo: UserInfo.fromJson(json["userInfo"]),
        eventInfo: EventInfo.fromJson(json["eventInfo"]),
        waveComments: List<WaveComment>.from(
            json["wave_comments"].map((x) => WaveComment.fromJson(x))),
        totalWaveCommentsCount: json["totalWaveCommentsCount"],
        waveRating: json["waveRating"],
        isFriendAdd: json["isFriendAdd"],
        isCheckedIn: json["isCheckedIn"],
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
        "user_type": userType,
        "event_id": eventId,
        "date": date.toIso8601String(),
        "isFriend": isFriend,
        "isInvite": isInvite,
        "lattitude": lattitude,
        "longitude": longitude,
        "waves_location": wavesLocation,
        "event_detail": eventDetail,
        "location": location.toJson(),
        "start_time": startTime,
        "end_time": endTime,
        "wave_name": waveName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
        "userInfo": userInfo.toJson(),
        "eventInfo": eventInfo.toJson(),
        "wave_comments":
            List<dynamic>.from(waveComments.map((x) => x.toJson())),
        "totalWaveCommentsCount": totalWaveCommentsCount,
        "waveRating": waveRating,
        "isFriendAdd": isFriendAdd,
        "isCheckedIn": isCheckedIn,
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
    required this.firebaseToken,
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
  String firebaseToken;
  int noOfLoggedin;
  dynamic lastLoginTime;
  bool isFaceId;
  String email;
  String password;
  String mobileNumber;
  String roles;
  String username;
  String biography;
  int age;
  double latitude;
  String dob;
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
        firebaseToken: json["firebase_token"],
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
        "firebase_token": firebaseToken,
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
    required this.v,
  });

  String id;
  List<String> commentLikes;
  List<CommentReply> commentReply;
  String userId;
  String waveId;
  String comment;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

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
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
        "comment_reply":
            List<dynamic>.from(commentReply.map((x) => x.toJson())),
        "user_id": userId,
        "wave_id": waveId,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
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
  dynamic username;
  dynamic avatar;
  DateTime createdAt;

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
        userId: json["user_id"],
        waveId: json["wave_id"],
        comment: json["comment"],
        commentLikes: List<dynamic>.from(json["comment_likes"].map((x) => x)),
        username: json["username"],
        avatar: json["avatar"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "wave_id": waveId,
        "comment": comment,
        "comment_likes": List<dynamic>.from(commentLikes.map((x) => x)),
        "username": username,
        "avatar": avatar,
        "created_at": createdAt.toIso8601String(),
      };
}
