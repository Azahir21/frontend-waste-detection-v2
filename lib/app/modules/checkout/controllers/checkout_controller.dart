import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
  Predict predict = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> postImageData() async {
    try {
      if (predict.longitude == null || predict.latitude == null) {
        Get.snackbar('Some thing error', 'Failed to get location data.');
        return;
      }
      if (predict.detectedObjects!.isEmpty) {
        Get.snackbar('Failed post image', 'There is no object detected.');
        return;
      }
      final response = await ApiServices().post(
        UrlConstants.userSampah,
        {
          "address": predict.address,
          "longitude": predict.longitude,
          "latitude": predict.latitude,
          "point": predict.subtotalpoint,
          "image": predict.encodedImages,
          "filename": predict.fileName,
          "capture_date": predict.datetime!.toIso8601String(),
          "sampah_items": predict.detectedObjects!
              .map((e) => {"jenisSampahId": e.detectedObjectClass})
              .toList(),
        },
      );
      Get.snackbar("Success post sampah", "Berhasil post sampah");
    } catch (e) {
      Get.snackbar('Some thing error', 'Failed to post image data.');
      print('Post image error: $e');
    }
  }
}
