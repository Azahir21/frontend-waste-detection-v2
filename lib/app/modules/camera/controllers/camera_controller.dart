import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraViewController extends GetxController {
  // Available cameras (front and back)
  List<CameraDescription> _cameras = [];

  // Current CameraController instance
  late CameraController _cameraController;

  // Reactive state variables
  final RxBool _isLoading = true.obs;
  final RxString _filePath = ''.obs;
  final Rx<Position?> _position = Rx<Position?>(null);

  // Index of the current camera in _cameras
  int _currentCameraIndex = 0;

  // Flash mode (toggle between off and torch)
  FlashMode _flashMode = FlashMode.off;

  // Aspect ratio for the preview (1:1, 3:4, 16:9, or full screen)
  final RxDouble _currentAspectRatio = (9 / 16).obs;

  // Getters
  CameraController get cameraController => _cameraController;
  bool get isLoading => _isLoading.value;
  String? get filePath => _filePath.value;
  Position? get position => _position.value;
  double get currentAspectRatio => _currentAspectRatio.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeEverything();
  }

  Future<void> _initializeEverything() async {
    // 1. Get available cameras.
    _cameras = await availableCameras();
    // Default to back camera if available.
    int backCameraIndex = _cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    _currentCameraIndex = backCameraIndex != -1 ? backCameraIndex : 0;

    // 3. Initialize camera controller with the current camera.
    if (_cameras.isNotEmpty) {
      await _initCameraController(_cameras[_currentCameraIndex]);
    }

    _isLoading.value = false;
  }

  Future<void> _initLocation() async {
    try {
      _position.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    }
  }

  Future<void> _initCameraController(CameraDescription description) async {
    _cameraController = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      await _cameraController.setFlashMode(_flashMode);
      await _cameraController.setFocusMode(FocusMode.auto);
    } catch (e) {
      Get.snackbar('Error', 'Camera initialization failed: $e');
    }
  }

  /// Reinitialize the camera without changing the currently selected camera.
  Future<void> reinitializeCamera() async {
    _isLoading.value = true;
    await _cameraController.dispose();
    await _initCameraController(_cameras[_currentCameraIndex]);
    _isLoading.value = false;
  }

  /// Capture an image and save it to the app's documents directory.
  Future<void> takePicture() async {
    if (_cameraController.value.isTakingPicture) return;
    try {
      final XFile file = await _cameraController.takePicture();
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(file.path);
      final String savedPath = path.join(appDir.path, fileName);
      await File(file.path).copy(savedPath);
      _filePath.value = savedPath;
      await _initLocation(); // Update location after capturing
    } catch (e) {
      Get.snackbar('Error', 'Failed to take picture: $e');
    }
  }

  /// Switch between the available cameras.
  Future<void> switchCamera() async {
    if (_cameras.isEmpty) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await reinitializeCamera();
  }

  /// Toggle the flashlight (flash mode) between off and torch.
  Future<void> toggleFlash() async {
    try {
      _flashMode =
          _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _cameraController.setFlashMode(_flashMode);
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle flashlight: $e');
    }
  }

  /// Set focus and exposure points based on tap location.
  Future<void> setFocusPoint(Offset offset, Size size) async {
    if (!_cameraController.value.isInitialized) return;
    final double x = offset.dx / size.width;
    final double y = offset.dy / size.height;
    try {
      await _cameraController.setFocusPoint(Offset(x, y));
      await _cameraController.setExposurePoint(Offset(x, y));
    } catch (e) {
      Get.snackbar('Error', 'Focus failed: $e');
    }
  }

  /// Pick an image from the gallery.
  Future<void> pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _filePath.value = image.path;
    }
  }

  @override
  void onClose() {
    _cameraController.dispose();
    super.onClose();
  }
}
