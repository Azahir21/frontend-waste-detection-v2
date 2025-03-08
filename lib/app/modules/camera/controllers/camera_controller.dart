import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_waste_management/app/data/models/predict_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as img;
import 'package:sensors_plus/sensors_plus.dart';

class CameraViewController extends GetxController {
  Predict predict = Predict();
  bool isPile = Get.arguments;
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
  final Rx<FlashMode> _flashMode = FlashMode.off.obs;
  Rx<FlashMode> get flashMode => _flashMode;

  // Aspect ratio for the preview (1:1, 3:4, 16:9, or full screen)
  final RxDouble _currentAspectRatio = (9 / 16).obs;

  // Zoom variables
  RxDouble _currentZoom = 1.0.obs;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _baseZoom = 1.0; // To store zoom at the start of pinch

  // Getters
  CameraController get cameraController => _cameraController;
  bool get isLoading => _isLoading.value;
  String? get filePath => _filePath.value;
  Position? get position => _position.value;
  double get currentAspectRatio => _currentAspectRatio.value;
  RxDouble get currentZoom => _currentZoom;

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

  Future<void> _initCameraController(CameraDescription description) async {
    _cameraController = CameraController(
      description,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      await _cameraController.setFlashMode(_flashMode.value);
      await _cameraController.setFocusMode(FocusMode.auto);

      // Initialize zoom parameters after the controller is ready
      _currentZoom.value = 1.0;
      _minZoom = await _cameraController.getMinZoomLevel();
      _maxZoom = await _cameraController.getMaxZoomLevel();
    } catch (e) {
      Get.snackbar('Error', 'Camera initialization failed: $e');
    }
  }

  /// Called when the user starts a pinch gesture.
  void onScaleStart(ScaleStartDetails details) {
    _baseZoom = _currentZoom.value;
  }

  /// Called when the user updates the pinch gesture.
  Future<void> onScaleUpdate(ScaleUpdateDetails details) async {
    double newZoom = _baseZoom * details.scale;
    // Clamp the new zoom level between min and max values.
    newZoom = newZoom.clamp(_minZoom, _maxZoom);
    _currentZoom.value = newZoom;
    try {
      await _cameraController.setZoomLevel(_currentZoom.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to set zoom level: $e');
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
      if (file == null) return;

      // Get device orientation directly from sensors rather than UI
      DeviceOrientation deviceOrientation =
          await _getPhysicalDeviceOrientation();
      debugPrint('Device orientation: $deviceOrientation');

      // Get camera sensor orientation
      int sensorOrientation = _cameras[_currentCameraIndex].sensorOrientation;
      debugPrint('Camera sensor orientation: $sensorOrientation');

      // Determine if rotation is needed
      if (deviceOrientation == DeviceOrientation.landscapeLeft ||
          deviceOrientation == DeviceOrientation.landscapeRight ||
          deviceOrientation == DeviceOrientation.portraitDown) {
        await _rotateImageBasedOnSensor(
            File(file.path), deviceOrientation, sensorOrientation);
      }

      await postImage(file, true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to take picture: $e');
    }
  }

  /// Get the physical device orientation using accelerometer data
  Future<DeviceOrientation> _getPhysicalDeviceOrientation() async {
    try {
      // Import: import 'package:sensors_plus/sensors_plus.dart';
      final accelerometerValues = await accelerometerEvents.first;
      final x = accelerometerValues.x;
      final y = accelerometerValues.y;

      // Determine orientation based on accelerometer values
      if (x.abs() > y.abs()) {
        // Device is in landscape
        return x > 0
            ? DeviceOrientation.landscapeLeft
            : DeviceOrientation.landscapeRight;
      } else {
        // Device is in portrait
        return y > 0
            ? DeviceOrientation.portraitUp
            : DeviceOrientation.portraitDown;
      }
    } catch (e) {
      debugPrint('Error getting physical orientation: $e');
      // Default to portrait if can't determine
      return DeviceOrientation.portraitUp;
    }
  }

  /// Rotate the image based on device and sensor orientation
  Future<void> _rotateImageBasedOnSensor(File imageFile,
      DeviceOrientation deviceOrientation, int sensorOrientation) async {
    try {
      // Import: import 'package:image/image.dart' as img;
      final bytes = await imageFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage != null) {
        // Calculate required rotation
        int rotationAngle = 0;

        // First, adjust for the device orientation
        switch (deviceOrientation) {
          case DeviceOrientation.portraitUp:
            rotationAngle = 0;
            break;
          case DeviceOrientation.landscapeLeft:
            rotationAngle = 180;
            break;
          case DeviceOrientation.portraitDown:
            rotationAngle = 90;
            break;
          case DeviceOrientation.landscapeRight:
            rotationAngle = 360;
            break;
        }

        // Then adjust for sensor orientation
        // The sensor orientation is the angle that the sensor is rotated relative
        // to the natural orientation of the device
        print('Applying Sensor orientation: $sensorOrientation');
        print('Applying Rotation angle: $rotationAngle');
        rotationAngle = (rotationAngle + sensorOrientation) % 360;

        debugPrint('Applying rotation of $rotationAngle degrees');

        final rotatedImage =
            img.copyRotate(originalImage, angle: rotationAngle);
        await imageFile.writeAsBytes(img.encodeJpg(rotatedImage));
      }
    } catch (e) {
      debugPrint('Error rotating image: $e');
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
      _flashMode.value =
          _flashMode.value == FlashMode.off ? FlashMode.torch : FlashMode.off;
      await _cameraController.setFlashMode(_flashMode.value);
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
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, requestFullMetadata: true);

    if (image == null) {
      return;
    }
    await postImage(image, false);
  }

  Future<void> _initLocation() async {
    try {
      _position.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
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

  Future<void> postImage(XFile picture, bool fromCamera) async {
    var startTime = DateTime.now();
    _isLoading.value = true;
    try {
      OverlayLoadingProgress.start();
      debugPrint('File size: ${File(picture.path).lengthSync()} bytes');

      LatLng? position = await getCurrentPosition();
      var response = await ApiServices().uploadFile(
        UrlConstants.predict,
        GetStorage().read("username"),
        position!.longitude,
        position.latitude,
        fromCamera,
        isPile,
        File(picture.path),
      );
      var responseData = jsonDecode(response);
      print(responseData);
      if (responseData.containsKey('detail')) {
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.action_not_continue,
            responseData['detail']);
        OverlayLoadingProgress.stop();
        return;
      }
      predict = Predict.fromJson(responseData);
      int point = GetStorage().read("point");
      predict.totalpoint =
          point + (predict.subtotalpoint != null ? predict.subtotalpoint! : 0);
      predict.address = await getAddressFromLatLng(position);
      // for (var countedObject in predict.countedObjects!) {
      //   countedObject.name = await translate(countedObject.name!);
      // }
      OverlayLoadingProgress.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed("/checkout", arguments: predict);
      });
    } catch (e) {
      debugPrint('Error occurred while posting image: $e');
    } finally {
      _isLoading.value = false;
      print('Time taken: ${DateTime.now().difference(startTime).inSeconds} s');
    }
  }

  @override
  void onClose() {
    _cameraController.dispose();
    super.onClose();
  }
}
