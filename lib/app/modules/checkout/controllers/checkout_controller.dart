import 'package:frontend_waste_management/app/data/models/post_sampah.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_kit/overlay_kit.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
  late Predict predict;
  final address = Rxn<String>();
  late LatLng initial;
  late LatLng? fixedLocation;
  final isLoading = false.obs;
  final _tokenService = TokenService();

  @override
  void onInit() async {
    super.onInit();
    predict = Get.arguments;
    initial = LatLng(predict.latitude!, predict.longitude!);
    fixedLocation = null;
    print(fixedLocation);
    if (predict.fromCamera!) {
      address.value = predict.address!;
      fixedLocation = LatLng(predict.latitude!, predict.longitude!);
      print(fixedLocation);
    }
  }

  Future<void> postImageData() async {
    try {
      OverlayLoadingProgress.start();
      isLoading.value = true;
      if (!await _tokenService.checkToken()) {
        return;
      }
      if (fixedLocation == null) {
        Get.snackbar('Some thing error', 'Location not found.');
        return;
      }
      if (predict.detectedObjects!.isEmpty) {
        Get.snackbar('Failed post image', 'There is no object detected.');
        OverlayLoadingProgress.stop();
        Get.offAllNamed("/bottomnav");
        return;
      }
      final response = await ApiServices().post(
        UrlConstants.userSampah,
        {
          "address": predict.address,
          "longitude": fixedLocation!.longitude,
          "latitude": fixedLocation!.latitude,
          "point": predict.subtotalpoint,
          "image": predict.encodedImages,
          "filename": predict.fileName,
          "capture_date": predict.datetime!.toIso8601String(),
          "sampah_items": predict.detectedObjects!
              .map((e) => {"jenisSampahId": e.detectedObjectClass})
              .toList(),
        },
      );
      final data = PostSampah.fromRawJson(response);
      isLoading.value = false;
      OverlayLoadingProgress.stop();
      Get.offAllNamed("/bottomnav");
      Get.snackbar("Success post sampah", "Berhasil post sampah");
      if (data.updatedBadge!) {
        Get.snackbar("Congratulation", "You got ${data.badge} badge");
      }
    } catch (e) {
      Get.snackbar('Some thing error', 'Failed to post image data.');
      print('Post image error: $e');
    }
  }
}
