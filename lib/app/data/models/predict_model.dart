import 'dart:convert';

class Predict {
  String? fileName;
  bool? fromCamera;
  bool? isWastePile;
  DateTime? datetime;
  double? longitude;
  double? latitude;
  int? subtotalpoint;
  int? totalpoint;
  String? address;
  List<DetectedObject>? detectedObjects;
  List<CountedObject>? countedObjects;
  String? encodedImages;

  Predict({
    this.fileName,
    this.fromCamera,
    this.isWastePile,
    this.datetime,
    this.longitude,
    this.latitude,
    this.subtotalpoint,
    this.totalpoint,
    this.address,
    this.detectedObjects,
    this.countedObjects,
    this.encodedImages,
  });

  factory Predict.fromRawJson(String str) => Predict.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Predict.fromJson(Map<String, dynamic> json) => Predict(
        fileName: json["file_name"],
        fromCamera: json["from_camera"],
        isWastePile: json["is_garbage_pile"],
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        subtotalpoint: json["subtotalpoint"],
        totalpoint: json["totalpoint"],
        address: json["address"],
        detectedObjects: json["detected_objects"] == null
            ? []
            : List<DetectedObject>.from(json["detected_objects"]!
                .map((x) => DetectedObject.fromJson(x))),
        countedObjects: json["counted_objects"] == null
            ? []
            : List<CountedObject>.from(
                json["counted_objects"]!.map((x) => CountedObject.fromJson(x))),
        encodedImages: json["encoded_images"],
      );

  Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "from_camera": fromCamera,
        "is_garbage_pile": isWastePile,
        "datetime": datetime?.toIso8601String(),
        "longitude": longitude,
        "latitude": latitude,
        "subtotalpoint": subtotalpoint,
        "totalpoint": totalpoint,
        "address": address,
        "detected_objects": detectedObjects == null
            ? []
            : List<dynamic>.from(detectedObjects!.map((x) => x.toJson())),
        "counted_objects": countedObjects == null
            ? []
            : List<dynamic>.from(countedObjects!.map((x) => x.toJson())),
        "encoded_images": encodedImages,
      };
}

class CountedObject {
  String? name;
  int? count;
  int? point;

  CountedObject({
    this.name,
    this.count,
    this.point,
  });

  factory CountedObject.fromRawJson(String str) =>
      CountedObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountedObject.fromJson(Map<String, dynamic> json) => CountedObject(
        name: json["name"],
        count: json["count"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "point": point,
      };
}

class DetectedObject {
  String? name;
  int? detectedObjectClass;
  int? point;

  DetectedObject({
    this.name,
    this.detectedObjectClass,
    this.point,
  });

  factory DetectedObject.fromRawJson(String str) =>
      DetectedObject.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetectedObject.fromJson(Map<String, dynamic> json) => DetectedObject(
        name: json["name"],
        detectedObjectClass: json["class"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "class": detectedObjectClass,
        "point": point,
      };
}
