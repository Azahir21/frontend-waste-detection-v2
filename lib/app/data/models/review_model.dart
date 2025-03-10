import 'package:image_picker/image_picker.dart';

class ReviewModel {
  final String? lang;
  final XFile? image;
  final double? longitude;
  final double? latitude;
  final String? address;
  final bool? useGarbagePileModel;
  final DateTime? captureDate;
  final bool? fromCamera;

  ReviewModel({
    this.lang,
    this.image,
    this.longitude,
    this.latitude,
    this.address,
    this.useGarbagePileModel,
    this.captureDate,
    this.fromCamera,
  });
}
