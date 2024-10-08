import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/models/point_model.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final String username = GetStorage().read('username');
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final point = 0.obs;
  final badgeName = ''.obs;
  final picker = ImagePicker().obs;
  Predict predict = Predict();
  final RxBool loadingAI = false.obs;
  final _tokenService = TokenService();
  // final st = SimplyTranslator(EngineType.google);

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    if (!await _tokenService.checkToken()) {
      return;
    }
    await getPoint();
    await getArticle();
    isLoading.value = false;
    return Future.value();
  }

  Future<void> getPoint() async {
    try {
      final response = await ApiServices().get(UrlConstants.point);
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.point_error, message);
        throw ('Point error: ${response.body}');
      }
      Point pointData = Point.fromRawJson(response.body);
      point.value = pointData.point!;
      badgeName.value = convertBadgeIdtoBadgeName(pointData.badgeId!);
    } catch (e) {
      print('Point error: $e');
    }
  }

  Future<List<Article>> getArticle() async {
    try {
      final response = await ApiServices().get('${UrlConstants.article}s');
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.article_error, message);
        throw ('Article error: ${response.body}');
      }
      articles.value = parseArticles(response.body);
      // for (var article in articles) {
      //   article.title = await translate(article.title!);
      // }
      return articles;
    } catch (e) {
      throw ('Article error: $e');
    }
  }

  Future getImageFromGallery() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    try {
      final XFile? pickedFile = await picker.value
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile == null) {
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.action_not_continue,
            AppLocalizations.of(Get.context!)!.no_image_selected);
        return;
      }
      loadingAI.value = true;
      await postImage(pickedFile, false);
      loadingAI.value = false;
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future getImageFromCamera() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    try {
      final XFile? pickedFile = await picker.value
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (pickedFile == null) {
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.action_not_continue,
            AppLocalizations.of(Get.context!)!.no_image_selected);
        return;
      }
      loadingAI.value = true;
      await postImage(pickedFile, true);
      loadingAI.value = false;
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future<void> postImage(XFile picture, bool fromCamera) async {
    try {
      OverlayLoadingProgress.start();
      LatLng? position = await getCurrentPosition();
      var response = await ApiServices().uploadFile(
        UrlConstants.predict,
        GetStorage().read("username"),
        position!.longitude,
        position.latitude,
        fromCamera,
        File(picture.path),
      );
      predict = Predict.fromJson(jsonDecode(response));
      predict.totalpoint = point.value + predict.subtotalpoint!;
      predict.address = await getAddressFromLatLng(position);
      // for (var countedObject in predict.countedObjects!) {
      //   countedObject.name = await translate(countedObject.name!);
      // }
      OverlayLoadingProgress.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed("/checkout", arguments: predict);
      });
    } catch (e) {
      print('Error occurred while posting image: $e');
    }
  }

  Future<LatLng?> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return const LatLng(0, 0);
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  String convertBadgeIdtoBadgeName(int badgeId) {
    switch (badgeId) {
      case 1:
        return AppLocalizations.of(Get.context!)!.tier_1;
      case 2:
        return AppLocalizations.of(Get.context!)!.tier_2;
      case 3:
        return AppLocalizations.of(Get.context!)!.tier_3;
      case 4:
        return AppLocalizations.of(Get.context!)!.tier_4;
      case 5:
        return AppLocalizations.of(Get.context!)!.tier_5;
      case 6:
        return AppLocalizations.of(Get.context!)!.tier_6;
      case 7:
        return AppLocalizations.of(Get.context!)!.tier_7;
      default:
        return 'Unknown';
    }
  }
}
