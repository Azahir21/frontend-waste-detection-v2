import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/camera_controller.dart';

class CameraView extends GetView<CameraViewController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    OrientationHelper.initialize(context);
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _CameraPreview();
      }),
      floatingActionButton: Obx(
        () => Visibility(
          visible: !controller.isLoading,
          child: _CaptureButton(),
        ),
      ),
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
            onScaleStart: (details) => controller.onScaleStart(details),
            onScaleUpdate: (details) => controller.onScaleUpdate(details),
            child: Obx(() {
              // Get camera preview size
              final previewSize = controller.cameraController.value.previewSize;
              if (previewSize == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Get current desired aspect ratio
              final targetAspectRatio = controller.currentAspectRatio == 0
                  ? size.width / size.height // Full screen uses device ratio
                  : controller.currentAspectRatio;

              // Determine if camera is rotated (typical for mobile cameras)
              final isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;

              // Calculate camera's native aspect ratio
              // When in portrait, we need to invert the preview size ratio
              final cameraAspectRatio = isPortrait
                  ? previewSize.height / previewSize.width
                  : previewSize.width / previewSize.height;

              return Center(
                child: _buildCameraPreviewWithRatio(
                  targetAspectRatio,
                  cameraAspectRatio,
                  context,
                ),
              );
            }),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Obx(() => Text(
                  'Zoom: ${controller.currentZoom.value.toStringAsFixed(1)}x',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),
        ),
        const _CenterMarker(),
        const _ControlsOverlay(),
      ],
    );
  }

  Widget _buildCameraPreviewWithRatio(
    double targetAspectRatio,
    double cameraAspectRatio,
    BuildContext context,
  ) {
    final screenSize = MediaQuery.of(context).size;

    // Calculate container dimensions based on target aspect ratio
    double containerWidth, containerHeight;

    // For full screen (device aspect ratio)
    if (controller.currentAspectRatio == 0) {
      containerWidth = screenSize.width;
      containerHeight = screenSize.height;
    }
    // For fixed aspect ratios
    else {
      // Check if we should constrain by width or height
      if (screenSize.width / screenSize.height < targetAspectRatio) {
        // Width constrained
        containerWidth = screenSize.width;
        containerHeight = screenSize.width / targetAspectRatio;
      } else {
        // Height constrained
        containerHeight = screenSize.height;
        containerWidth = screenSize.height * targetAspectRatio;
      }
    }

    // Special handling for different aspect ratios
    double scale = 1.0;

    // Different scale calculation approach based on aspect ratio
    if (targetAspectRatio == 1.0) {
      // 1:1 Square
      // For square, we want to ensure we don't crop too much
      // Using a larger scale factor to show more of the scene
      scale = _calculateSquareScaleFactor(
          cameraAspectRatio, containerWidth, containerHeight);
    } else if (targetAspectRatio == 0.75) {
      // 3:4 Portrait
      // For 3:4, we need a different approach to prevent cropping
      scale = _calculate34ScaleFactor(
          cameraAspectRatio, containerWidth, containerHeight);
    } else if (targetAspectRatio == 9.0 / 16.0) {
      // 9:16 Portrait Full
      // The 9:16 ratio is already working well, so we use the original calculation
      scale = _calculateStandardScaleFactor(cameraAspectRatio,
          targetAspectRatio, containerWidth, containerHeight);
    } else {
      // Default calculation for other ratios
      scale = _calculateStandardScaleFactor(cameraAspectRatio,
          targetAspectRatio, containerWidth, containerHeight);
    }

    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: ClipRect(
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: CameraPreview(controller.cameraController),
        ),
      ),
    );
  }

  // Standard scale factor calculation that works well for 9:16
  double _calculateStandardScaleFactor(
    double cameraAspectRatio,
    double targetAspectRatio,
    double containerWidth,
    double containerHeight,
  ) {
    // Calculate scale factors for both dimensions
    final widthScale = containerWidth / (containerHeight * cameraAspectRatio);
    final heightScale = (containerWidth / targetAspectRatio) /
        (containerWidth / cameraAspectRatio);

    // Use the larger scale to ensure the camera preview fills the container
    if (cameraAspectRatio > targetAspectRatio) {
      return heightScale;
    } else {
      return widthScale;
    }
  }

  // Special scale factor calculation optimized for 1:1 square ratio
  double _calculateSquareScaleFactor(
    double cameraAspectRatio,
    double containerWidth,
    double containerHeight,
  ) {
    // For square format, we want to zoom out a bit to show more content
    // This helps prevent excessive cropping of the scene
    final baseScale = containerHeight / (containerWidth / cameraAspectRatio);

    // Apply a modifier to ensure we see more of the scene
    // Lower values = less cropping/more scene visible
    final zoomModifier = 0.8;

    return baseScale * zoomModifier;
  }

  // Special scale factor calculation optimized for 3:4 portrait ratio
  double _calculate34ScaleFactor(
    double cameraAspectRatio,
    double containerWidth,
    double containerHeight,
  ) {
    // For 3:4, we need to ensure we don't crop too much vertically
    // We'll create a slight zoom-out effect to show more of the scene
    final scaleWidth = containerWidth / (containerHeight * cameraAspectRatio);
    final scaleHeight = containerHeight / (containerWidth / cameraAspectRatio);

    // Choose the smaller scale to ensure less cropping
    // and apply a modifier to further reduce cropping
    final baseScale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
    final zoomModifier = 0.85;

    return baseScale * zoomModifier;
  }

  void _onTapFocus(TapDownDetails details, Size size) {
    final offset = details.localPosition;
    controller.setFocusPoint(offset, size);
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
          Obx(() => IconButton(
                icon: Icon(controller.flashMode.value == FlashMode.off
                    ? Icons.flash_on
                    : Icons.flash_off),
                color: Colors.white,
                onPressed: controller.toggleFlash,
              )),
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

class OrientationHelper {
  static Orientation? currentOrientation;

  static void initialize(BuildContext context) {
    final newOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation != newOrientation) {
      currentOrientation = newOrientation;
      // You can notify the controller here if needed
    }
  }
}
