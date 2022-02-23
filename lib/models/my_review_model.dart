import 'dart:convert';

MyReviewModel myReviewModelFromJson(String str) =>
    MyReviewModel.fromJson(json.decode(str));

String myReviewModelToJson(MyReviewModel data) => json.encode(data.toJson());

class MyReviewModel {
  MyReviewModel({
    required this.status,
    required this.message,
    required this.waves,
  });

  int status;
  String message;
  List<Wave> waves;

  factory MyReviewModel.fromJson(Map<String, dynamic> json) => MyReviewModel(
        status: json["status"],
        message: json["message"],
        waves: List<Wave>.from(json["waves"].map((x) => Wave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "waves": List<dynamic>.from(waves.map((x) => x.toJson())),
      };
}

class Wave {
  Wave({
    required this.id,
    required this.waveName,
    required this.reviewData,
  });

  String id;
  String waveName;
  List<ReviewDatum> reviewData;

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        id: json["_id"],
        waveName: json["wave_name"],
        reviewData: List<ReviewDatum>.from(
            json["reviewData"].map((x) => ReviewDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "wave_name": waveName,
        "reviewData": List<dynamic>.from(reviewData.map((x) => x.toJson())),
      };
}

class ReviewDatum {
  ReviewDatum({
    required this.id,
    required this.rating,
    required this.userId,
    required this.reviewComment,
    required this.userData,
  });

  String id;
  Rating rating;
  String userId;
  String reviewComment;
  List<UserDatum> userData;

  factory ReviewDatum.fromJson(Map<String, dynamic> json) => ReviewDatum(
        id: json["_id"],
        rating: Rating.fromJson(json["rating"]),
        userId: json["user_id"],
        reviewComment: json["review_comment"],
        userData: List<UserDatum>.from(
            json["userData"].map((x) => UserDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rating": rating.toJson(),
        "user_id": userId,
        "review_comment": reviewComment,
        "userData": List<dynamic>.from(userData.map((x) => x.toJson())),
      };
}

class Rating {
  Rating({
    required this.numberDecimal,
  });

  String numberDecimal;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        numberDecimal: json["\u0024numberDecimal"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024numberDecimal": numberDecimal,
      };
}

class UserDatum {
  UserDatum({
    required this.id,
    required this.avatar,
    required this.username,
    required this.age,
  });

  String id;
  String avatar;
  String username;
  int age;

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
        id: json["_id"],
        avatar: json["avatar"],
        username: json["username"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "avatar": avatar,
        "username": username,
        "age": age,
      };
}
