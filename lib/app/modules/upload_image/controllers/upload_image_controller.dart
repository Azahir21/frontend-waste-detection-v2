import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/point_model.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

class UploadImageController extends GetxController {
  late CameraController cameraController;
  RxBool isRearCameraSelected = true.obs;
  RxBool isCameraInitialized = false.obs;
  Predict predict = Predict();
  final RxBool loadingAI = false.obs;

  final List<CameraDescription> cameras = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    initCamera(cameras[0]);
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await cameraController.initialize();
      isCameraInitialized.value = true;
    } on CameraException catch (e) {
      print("Camera error: $e");
    }
  }

  Future<void> switchCamera() async {
    isRearCameraSelected.value = !isRearCameraSelected.value;
    initCamera(cameras[isRearCameraSelected.value ? 0 : 1]);
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized ||
        cameraController.value.isTakingPicture) {
      return;
    }
    try {
      await cameraController.setFlashMode(FlashMode.off);
      XFile picture = await cameraController.takePicture();
      loadingAI.value = true;
      await postImage(picture);
      loadingAI.value = false;
      // Get.to(() => PreviewPage(picture: picture)); // Navigate to preview page
    } on CameraException catch (e) {
      print('Error occurred while taking picture: $e');
    }
  }

  Future<void> postImage(XFile picture) async {
    try {
      int? point = await getUserPoints();
      LatLng? position = await getCurrentPosition();
      var response = await ApiServices().uploadFile(
        UrlConstants.predict,
        GetStorage().read("username"),
        position!.longitude,
        position.latitude,
        File(picture.path),
      );
      predict = Predict.fromJson(jsonDecode(response));
      predict.totalpoint = point + predict.subtotalpoint!;
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

  Future<int> getUserPoints() async {
    try {
      final response = await ApiServices().get(UrlConstants.point);
      Point pointData = Point.fromRawJson(response);
      return pointData.point!;
    } catch (e) {
      Get.snackbar('Some thing error', 'Failed to get koin data.');
      throw ('Point error: $e');
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
