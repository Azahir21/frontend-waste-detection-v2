import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/models/point_model.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void onInit() async {
    super.onInit();
    print("re init");
    await fetchData();
  }

  Future<void> fetchData() async {
    print("re frase");
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
      Point pointData = Point.fromRawJson(response);
      point.value = pointData.point!;
      badgeName.value = convertBadgeIdtoBadgeName(pointData.badgeId!);
    } catch (e) {
      Get.snackbar('Some thing error', 'Failed to get koin data.');
      print('Point error: $e');
    }
  }

  Future<List<Article>> getArticle() async {
    try {
      final response = await ApiServices().get('${UrlConstants.article}s');
      articles.value = parseArticles(response);
      return articles;
    } catch (e) {
      Get.snackbar('Article Error', 'Failed to get article. Please try again.');
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
        Get.snackbar("error", "No image selected");
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
        Get.snackbar("error", "No image selected");
        return;
      }
      print('Image path: ${pickedFile.path}');
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
        return 'Newcomer';
      case 2:
        return 'Junior Reporter';
      case 3:
        return 'Field Reporter';
      case 4:
        return 'Senior Reporter';
      case 5:
        return 'Lead Reporter';
      case 6:
        return 'Chief Reporter';
      case 7:
        return 'Crowdsourcing Hero';
      default:
        return 'Unknown';
    }
  }
}
