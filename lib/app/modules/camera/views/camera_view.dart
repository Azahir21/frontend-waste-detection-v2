import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/camera_controller.dart';

class CameraView extends GetView<CameraViewController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _CameraPreview();
      }),
      floatingActionButton: _CaptureButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _CameraPreview extends GetView<CameraViewController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Black background for the entire screen
        Container(color: Colors.black),

        Positioned.fill(
          child: GestureDetector(
            onTapDown: (details) => _onTapFocus(details, size),
            child: Obx(() {
              final previewSize = controller.cameraController.value.previewSize;
              if (previewSize == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              // Calculate the camera's native aspect ratio
              final cameraAspectRatio = isPortrait
                  ? previewSize.height / previewSize.width
                  : previewSize.width / previewSize.height;

              // We fix the target aspect ratio to 9:16
              const targetAspectRatio = 9 / 16;

              // Determine how to size the container
              double containerWidth, containerHeight;
              if (size.width / size.height < targetAspectRatio) {
                // Width constrained
                containerWidth = size.width;
                containerHeight = containerWidth / targetAspectRatio;
              } else {
                // Height constrained
                containerHeight = size.height;
                containerWidth = containerHeight * targetAspectRatio;
              }

              // Calculate the scaling so the camera preview fills the container
              final scale = _calculateScaleFactor(
                cameraAspectRatio,
                targetAspectRatio,
                containerWidth,
                containerHeight,
              );

              return Center(
                child: SizedBox(
                  width: containerWidth,
                  height: containerHeight,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: CameraPreview(controller.cameraController),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const _CenterMarker(),
        const _ControlsOverlay(),
      ],
    );
  }

  // Standard scale factor calculation that works well for 9:16
  double _calculateScaleFactor(
    double cameraAspectRatio,
    double targetAspectRatio,
    double containerWidth,
    double containerHeight,
  ) {
    final widthScale = containerWidth / (containerHeight * cameraAspectRatio);
    final heightScale = (containerWidth / targetAspectRatio) /
        (containerWidth / cameraAspectRatio);

    // Use the larger scale to ensure the preview fills the container
    if (cameraAspectRatio > targetAspectRatio) {
      return heightScale;
    } else {
      return widthScale;
    }
  }

  void _onTapFocus(TapDownDetails details, Size size) {
    final offset = details.localPosition;
    controller.setFocusPoint(offset, size);
    Get.showSnackbar(
      const GetSnackBar(
        message: 'Focus point set',
        duration: Duration(seconds: 1),
      ),
    );
  }
}

class _CenterMarker extends StatelessWidget {
  const _CenterMarker();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _ControlsOverlay extends GetView<CameraViewController> {
  const _ControlsOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery access
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white),
            onPressed: controller.pickImage,
          ),
          // Switch camera
          IconButton(
            icon: const Icon(Icons.switch_camera, color: Colors.white),
            onPressed: controller.switchCamera,
          ),
          // Flashlight toggle
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: controller.toggleFlash,
          ),
          // Removed the aspect ratio IconButton entirely
        ],
      ),
    );
  }
}

class _CaptureButton extends GetView<CameraViewController> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: controller.takePicture,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      child: const Icon(Icons.camera_alt),
    );
  }
}
