import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/models/point_model.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final String username = GetStorage().read('username');
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final RxInt point = 0.obs;
  final picker = ImagePicker().obs;
  Predict predict = Predict();
  final RxBool loadingAI = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
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
      Get.toNamed("/checkout", arguments: predict);
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
}
