import 'dart:convert';

class Point {
  int? point;
  DateTime? updatedAt;

  Point({
    this.point,
    this.updatedAt,
  });

  factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        point: json["point"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "point": point,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
