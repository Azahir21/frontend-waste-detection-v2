import 'dart:convert';

class Point {
  int? point;
  int? badgeId;
  String? badgeName;
  DateTime? updatedAt;

  Point({
    this.point,
    this.badgeId,
    this.updatedAt,
  });

  factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        point: json["point"],
        badgeId: json["badgeId"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "point": point,
        "badgeId": badgeId,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
