import 'dart:convert';

EventIdModel eventIdModelFromJson(String str) =>
    EventIdModel.fromJson(json.decode(str));

String eventIdModelToJson(EventIdModel data) => json.encode(data.toJson());

class EventIdModel {
  EventIdModel({
    required this.status,
    required this.data,
    required this.message,
  });

  var status;
  List<Datum> data;
  String message;

  factory EventIdModel.fromJson(Map<String, dynamic> json) => EventIdModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.eventName,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.datumId,
  });

  String id;
  String eventName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String datumId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        eventName: json["event_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        v: json["__v"],
        datumId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "event_name": eventName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "__v": v,
        "id": datumId,
      };
}
