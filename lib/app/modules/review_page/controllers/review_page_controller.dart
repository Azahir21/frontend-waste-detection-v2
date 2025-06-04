import 'dart:async';
import 'dart:convert';
import 'package:frontend_waste_management/app/data/models/review_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/local_notifications.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewPageController extends GetxController {
  late ReviewModel data;
  final address = Rxn<String>();
  late LatLng initial;
  final fixedLocation = Rxn<LatLng>();
  final isLoading = false.obs;
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

  Future<void> postImageData() async {
    if (fixedLocation.value == null) {
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.some_things_wrong,
        AppLocalizations.of(Get.context!)!.location_not_found,
      );
      return;
    }

    // Fill the model once
    data = ReviewModel.fromJson({
      ...data.toJson(),
      'address': address.value,
      'latitude': fixedLocation.value!.latitude,
      'longitude': fixedLocation.value!.longitude,
    });

    // Tell the user we’re on it
    showSuccessSnackbar(
      AppLocalizations.of(Get.context!)!.we_will_be_back_soon,
      AppLocalizations.of(Get.context!)!.report_reviewed_by_system,
    );

    // Kick off the upload **without** awaiting
    unawaited(_uploadInBackground(data));

    // Immediately go to the main screen
    Get.offAllNamed('/bottomnav');
  }

  /// Actual upload runs silently in the background.
  Future<void> _uploadInBackground(ReviewModel payload) async {
    try {
      final raw =
          await ApiServices().postSampahV2(UrlConstants.userSampah, payload);
      final res = jsonDecode(raw);

      if (res.containsKey('detail')) {
        await _notify(
          success: false,
          message: res['detail'],
        );
      } else {
        await _notify(
          success: true,
          message: res['message'],
          payload: res['report-id'].toString(),
        );
      }
    } catch (e) {
      await _notify(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Centralised notification helper so we only build the text once.
  Future<void> _notify({
    required bool success,
    required String message,
    String payload = 'error',
  }) async {
    final lang = GetStorage().read('language');
    final id = lang == 'id';
    final ja = lang == 'ja';

    final title = success
        ? (id
            ? 'Laporan Berhasil'
            : ja
                ? '報告が成功しました'
                : 'Report Success')
        : (id
            ? 'Laporan Gagal'
            : ja
                ? '報告に失敗しました'
                : 'Report Failed');

    await LocalNotifications.showSimpleNotification(
      title: title,
      body: message,
      payload: payload,
    );
  }
}
