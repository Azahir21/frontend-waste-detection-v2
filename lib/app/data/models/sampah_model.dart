import 'dart:convert';

class SampahList {
  List<Sampah>? data;
  int? totalCount;
  int? page;
  int? pageSize;
  int? totalPages;

  SampahList({
    this.data,
    this.totalCount,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory SampahList.fromRawJson(String str) =>
      SampahList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SampahList.fromJson(Map<String, dynamic> json) => SampahList(
        data: json["data"] == null
            ? []
            : List<Sampah>.from(json["data"]!.map((x) => Sampah.fromJson(x))),
        totalCount: json["total_count"],
        page: json["page"],
        pageSize: json["page_size"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_count": totalCount,
        "page": page,
        "page_size": pageSize,
        "total_pages": totalPages,
      };
}

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
