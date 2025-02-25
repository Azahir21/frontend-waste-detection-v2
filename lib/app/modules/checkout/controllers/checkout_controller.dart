import 'dart:convert';

import 'package:frontend_waste_management/app/data/models/post_sampah.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
  late Predict predict;
  final address = Rxn<String>();
  late LatLng initial;
  late LatLng? fixedLocation;
  final isLoading = false.obs;
  final _tokenService = TokenService();
  final buttonEnable = true.obs;

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
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.some_things_wrong,
          AppLocalizations.of(Get.context!)!.location_not_found,
        );
        return;
      }
      if (predict.detectedObjects!.isEmpty) {
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.failed_to_post_data,
          AppLocalizations.of(Get.context!)!.no_object_detected,
        );
        OverlayLoadingProgress.stop();
        Get.offAllNamed("/bottomnav");
        return;
      }
      buttonEnable.value = false;
      print(address.value);
      final response = await ApiServices().post(
        UrlConstants.userSampah,
        {
          // "address": predict.address,
          "address": address.value,
          "longitude": fixedLocation!.longitude,
          "latitude": fixedLocation!.latitude,
          "point": predict.subtotalpoint,
          "image_url": predict.imageUrl,
          "is_waste_pile": predict.isWastePile,
          "capture_date": predict.datetime!.toIso8601String(),
          "sampah_items": predict.detectedObjects!
              .map((e) => {"jenisSampahId": e.detectedObjectClass})
              .toList(),
        },
      );
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.failed_to_post_waste,
          message,
        );
        throw ('${AppLocalizations.of(Get.context!)!.failed_to_post_data}: ${response.body}');
      }
      final data = PostSampah.fromRawJson(response.body);
      isLoading.value = false;
      buttonEnable.value = true;
      OverlayLoadingProgress.stop();
      Get.offAllNamed("/bottomnav");
      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.post_data_success,
        AppLocalizations.of(Get.context!)!.data_has_been_posted,
      );
      if (data.updatedBadge!) {
        showSuccessSnackbar(
          AppLocalizations.of(Get.context!)!.congratulations,
          AppLocalizations.of(Get.context!)!.badge_unlocked(data.badge!),
        );
      }
    } catch (e) {
      print('${AppLocalizations.of(Get.context!)!.failed_to_post_data}: $e');
    }
  }
}
