import 'dart:convert';

WaveListingRegularModel waveListingRegularModelFromJson(String str) =>
    WaveListingRegularModel.fromJson(json.decode(str));

String waveListingRegularModelToJson(WaveListingRegularModel data) =>
    json.encode(data.toJson());

class WaveListingRegularModel {
  WaveListingRegularModel({
    required this.status,
    required this.message,
    required this.wavesList,
  });

  int status;
  String message;
  List<WavesList> wavesList;

  factory WaveListingRegularModel.fromJson(Map<String, dynamic> json) =>
      WaveListingRegularModel(
        status: json["status"],
        message: json["message"],
        wavesList: List<WavesList>.from(
            json["WavesList"].map((x) => WavesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "WavesList": List<dynamic>.from(wavesList.map((x) => x.toJson())),
      };
}

class WavesList {
  WavesList({
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
    required this.isDiscountFollower,
    required this.isDiscountAll,
    required this.discountDetail,
    required this.isAdult,
    required this.isSendFollower,
    required this.radius,
    required this.additionalDetail,
  });

  String id;
  List<Media> media;
  List<String> inviteTags;
  List<String> friendTags;
  String userId;
  var userType;
  var eventId;
  DateTime date;
  var isFriend;
  var isInvite;
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
  var waveRating;
  bool isFriendAdd;
  bool isCheckedIn;
  bool isBusinessUser;
  String avatar;
  String username;
  var isDiscountFollower;
  var isDiscountAll;
  var discountDetail;
  var isAdult;
  var isSendFollower;
  var radius;
  var additionalDetail;

  factory WavesList.fromJson(Map<String, dynamic> json) => WavesList(
        id: json["_id"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        inviteTags: List<String>.from(json["invite_tags"].map((x) => x)),
        friendTags: List<String>.from(json["friend_tags"].map((x) => x)),
        userId: json["user_id"],
        userType: json["user_type"],
        eventId: json["event_id"],
        date: DateTime.parse(json["date"]),
        isFriend: json["isFriend"] == null ? null : json["isFriend"],
        isInvite: json["isInvite"] == null ? null : json["isInvite"],
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
        isDiscountFollower: json["isDiscountFollower"] == null
            ? null
            : json["isDiscountFollower"],
        isDiscountAll:
            json["isDiscountAll"] == null ? null : json["isDiscountAll"],
        discountDetail:
            json["discount_detail"] == null ? null : json["discount_detail"],
        isAdult: json["isAdult"] == null ? null : json["isAdult"],
        isSendFollower:
            json["isSendFollower"] == null ? null : json["isSendFollower"],
        radius: json["radius"] == null ? null : json["radius"].toDouble(),
        additionalDetail: json["additional_detail"] == null
            ? null
            : json["additional_detail"],
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
        "isFriend": isFriend == null ? null : isFriend,
        "isInvite": isInvite == null ? null : isInvite,
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
        "isDiscountFollower":
            isDiscountFollower == null ? null : isDiscountFollower,
        "isDiscountAll": isDiscountAll == null ? null : isDiscountAll,
        "discount_detail": discountDetail == null ? null : discountDetail,
        "isAdult": isAdult == null ? null : isAdult,
        "isSendFollower": isSendFollower == null ? null : isSendFollower,
        "radius": radius == null ? null : radius,
        "additional_detail": additionalDetail == null ? null : additionalDetail,
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

  var id;
  var eventName;
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
    // required this.firebaseToken,
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
  // String firebaseToken;
  int noOfLoggedin;
  dynamic lastLoginTime;
  bool isFaceId;
  String email;
  String password;
  String mobileNumber;
  var roles;
  String username;
  String biography;
  var age;
  double latitude;
  var dob;
  double longitude;
  var address;
  Location location;
  int v;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["_id"],
        avatar: json["avatar"],
        otp: json["otp"],
        isEmailVerified: json["isEmailVerified"],
        userStatus: json["user_status"],
        //  firebaseToken: json["firebase_token"],
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
        //  "firebase_token": firebaseToken,
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
  var userId;
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

  var userId;
  String waveId;
  String comment;
  List<dynamic> commentLikes;
  var username;
  String avatar;
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
