import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewModel {
  final String? lang;

  /// Instead of storing the entire XFile (which cannot be serialized directly),
  /// store only the path for serialization.
  final String? imagePath;

  /// If you still want to use XFile in your UI logic, you can hold it separately
  /// and mark it with `transient` usage. Or you can reconstruct it from `imagePath` as needed.
  final double? longitude;
  final double? latitude;
  final String? address;
  final bool? useGarbagePileModel;
  final DateTime? captureDate;
  final bool? fromCamera;

  // This field is purely for runtime usage, and won't appear in JSON.
  // Mark it as transient (i.e., not for JSON).
  final XFile? xfile;

  ReviewModel({
    this.lang,
    this.imagePath,
    this.longitude,
    this.latitude,
    this.address,
    this.useGarbagePileModel,
    this.captureDate,
    this.fromCamera,
    this.xfile,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    debugPrint("captureDate type: ${json['captureDate'].runtimeType}");
    return ReviewModel(
      lang: json['lang'] as String?,
      imagePath: json['imagePath'] as String?,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      address: json['address'] as String?,
      useGarbagePileModel: json['useGarbagePileModel'] as bool?,
      captureDate: json['captureDate'] != null
          ? (json['captureDate'] is String
              ? DateTime.parse(json['captureDate'] as String)
              : json['captureDate'] as DateTime)
          : null,
      fromCamera: json['fromCamera'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lang': lang,
      'imagePath': imagePath,
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
      'useGarbagePileModel': useGarbagePileModel,
      'captureDate': captureDate!.toIso8601String(),
      'fromCamera': fromCamera,
    };
  }
}
