import 'dart:convert';

class Sampah {
  int? id;
  String? address;
  DateTime? captureTime;
  int? point;

  Sampah({
    this.id,
    this.address,
    this.captureTime,
    this.point,
  });

  factory Sampah.fromRawJson(String str) => Sampah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sampah.fromJson(Map<String, dynamic> json) => Sampah(
        id: json["id"],
        address: json["address"],
        captureTime: json["captureTime"] == null
            ? null
            : DateTime.parse(json["captureTime"]),
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "captureTime": captureTime?.toIso8601String(),
        "point": point,
      };
}

List<Sampah> parseSampah(String str) {
  final parsed = json.decode(str).cast<Map<String, dynamic>>();
  return parsed.map<Sampah>((json) => Sampah.fromJson(json)).toList();
}
