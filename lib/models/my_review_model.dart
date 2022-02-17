import 'dart:convert';

MyReviewModel myReviewModelFromJson(String str) =>
    MyReviewModel.fromJson(json.decode(str));

String myReviewModelToJson(MyReviewModel data) => json.encode(data.toJson());

class MyReviewModel {
  MyReviewModel({
    required this.status,
    required this.message,
    required this.review,
  });

  int status;
  String message;
  List<Review> review;

  factory MyReviewModel.fromJson(Map<String, dynamic> json) => MyReviewModel(
        status: json["status"],
        message: json["message"],
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "review": List<dynamic>.from(review.map((x) => x.toJson())),
      };
}

class Review {
  Review({
    required this.id,
    required this.rating,
    required this.reviewComment,
    required this.user,
  });

  String id;
  Rating rating;
  String reviewComment;
  User user;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        rating: Rating.fromJson(json["rating"]),
        reviewComment: json["review_comment"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rating": rating.toJson(),
        "review_comment": reviewComment,
        "user": user.toJson(),
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

class User {
  User({
    required this.id,
    required this.avatar,
    required this.username,
    required this.age,
  });

  String id;
  String avatar;
  String username;
  int age;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
