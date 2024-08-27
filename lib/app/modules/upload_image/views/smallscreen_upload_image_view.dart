import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/upload_image/controllers/upload_image_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenUploadImageView extends GetView<UploadImageController> {
  const SmallScreenUploadImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Visibility(
            visible: !controller.loadingAI.value,
            replacement: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).appColors.iconDefault,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[200],
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  VerticalGap.formBig(),
                  AppText.labelDefaultEmphasis("Menunggu", context: context),
                  VerticalGap.formSmall(),
                  AppText.labelSmallDefault("Sedang memproses dengan AI",
                      context: context),
                ],
              ),
            ),
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                _handleFocusTap(context, details.localPosition);
              },
              child: Stack(
                children: [
                  controller.isCameraInitialized.value
                      ? _buildCameraPreview(context)
                      : Container(
                          color: Colors.black,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomIconButton.secondary(
                        iconName: AppIconName.backButton,
                        onTap: () {
                          Get.back();
                        },
                        context: context,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomIconButton.secondary(
                        height: 60,
                        width: 60,
                        iconName: AppIconName.scan,
                        onTap: () {
                          controller.takePicture();
                        },
                        context: context,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: controller.cameraController.value.aspectRatio,
        child: CameraPreview(controller.cameraController),
      ),
    );
  }

  void _handleFocusTap(BuildContext context, Offset tapPosition) {
    final x = tapPosition.dx / MediaQuery.of(context).size.width;
    final y = tapPosition.dy / MediaQuery.of(context).size.height;
    final focusPoint = Offset(x, y);
    controller.cameraController.setFocusPoint(focusPoint);
  }
}
