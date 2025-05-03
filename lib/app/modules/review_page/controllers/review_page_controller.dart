import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/review_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/local_notifications.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/modules/history/controllers/history_controller.dart';
import 'package:frontend_waste_management/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:workmanager/workmanager.dart';

class ReviewPageController extends GetxController {
  late ReviewModel data;
  final address = Rxn<String>();
  late LatLng initial;
  final fixedLocation = Rxn<LatLng>();
  final isLoading = false.obs;
  final _tokenService = TokenService();
  final buttonEnable = true.obs;

  @override
  void onInit() async {
    super.onInit();
    data = Get.arguments;
    initial = LatLng(data.latitude!, data.longitude!);
    fixedLocation.value = null;
    if (data.fromCamera!) {
      address.value = data.address!;
      fixedLocation.value = LatLng(data.latitude!, data.longitude!);
    }
  }

  // /// Instead of directly calling the API,
  // /// we schedule a background task using Workmanager.
  // Future<void> postImageData() async {
  //   // Optionally disable the button to prevent multiple scheduling.
  //   buttonEnable.value = false;
  //   isLoading.value = true;

  //   // Create a new instance or copy of the data with updated coordinates
  //   data = ReviewModel.fromJson({
  //     ...data.toJson(),
  //     'latitude': fixedLocation.value!.latitude,
  //     'longitude': fixedLocation.value!.longitude,
  //   });

  //   showSuccessSnackbar(AppLocalizations.of(Get.context!)!.we_will_be_back_soon,
  //       AppLocalizations.of(Get.context!)!.report_reviewed_by_system);

  //   print("Posting image data... : ${data.toJson()}");
  //   // Schedule the background task. Here we assume that ReviewModel has a toJson() method.
  //   Workmanager().registerOneOffTask(
  //     "postImageDataTask", // Unique task name
  //     "postImageDataTask", // Task identifier used in callbackDispatcher
  //     inputData: data.toJson(),
  //     constraints: Constraints(
  //       networkType: NetworkType.connected, // Ensure network connectivity.
  //     ),
  //   );

  //   // Since the API call is now handled in the background,
  //   // immediately reset the loading indicator.
  //   isLoading.value = false;
  //   Get.offAllNamed('/bottomnav');
  // }

  Future<void> postImageData() async {
    var startTime = DateTime.now();
    buttonEnable.value = false;
    isLoading.value = true;

    if (fixedLocation.value == null) {
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.some_things_wrong,
        AppLocalizations.of(Get.context!)!.location_not_found,
      );
      buttonEnable.value = true;
      isLoading.value = false;
      return;
    }
    // Update coordinates in the data
    data = ReviewModel.fromJson({
      ...data.toJson(),
      'address': address.value,
      'latitude': fixedLocation.value!.latitude,
      'longitude': fixedLocation.value!.longitude,
    });

    showSuccessSnackbar(
      AppLocalizations.of(Get.context!)!.we_will_be_back_soon,
      AppLocalizations.of(Get.context!)!.report_reviewed_by_system,
    );

    print("Posting image data... : ${data.toJson()}");

    try {
      // Directly call the API
      final response =
          await ApiServices().postSampahV2(UrlConstants.userSampah, data);
      final responseData = jsonDecode(response);

      if (responseData.containsKey('detail')) {
        // Error response
        final message = responseData['detail'];
        var title = (GetStorage().read('language') == 'id')
            ? "Laporan Gagal"
            : (GetStorage().read('language') == 'ja')
                ? "報告に失敗しました"
                : "Report Failed";
        await LocalNotifications.showSimpleNotification(
          title: title,
          body: message,
          payload: "error",
        );
        debugPrint("API call failed: $message");
      } else {
        // Success response
        final reportId = responseData['report-id'].toString();
        final message = responseData['message'];
        var title = (GetStorage().read('language') == 'id')
            ? "Laporan Berhasil"
            : (GetStorage().read('language') == 'ja')
                ? "報告が成功しました"
                : "Report Success";
        await LocalNotifications.showSimpleNotification(
          title: title,
          body: message,
          payload: reportId,
        );
      }
    } catch (e) {
      debugPrint("Error posting image data: $e");
      // Optionally handle error notifications here.
    } finally {
      isLoading.value = false;
      Get.offAllNamed('/bottomnav');
      print("API call completed in: ${DateTime.now().difference(startTime)}");
    }
  }
}
