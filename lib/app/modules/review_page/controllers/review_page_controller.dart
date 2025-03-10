import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/review_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewPageController extends GetxController {
  //TODO: Implement ReviewPageController
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

  Future<void> postImageData() async {
    try {
      isLoading.value = true;
      final response = await ApiServices().postSampahV2(
        UrlConstants.userSampah,
        data,
      );

      final responseData = jsonDecode(response);
      print(responseData);

      if (responseData.containsKey('detail')) {
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.action_not_continue,
          responseData['detail'],
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      buttonEnable.value = true;
    }
  }
}
