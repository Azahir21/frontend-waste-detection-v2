import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/upload_image/controllers/upload_image_controller.dart';
import 'package:get/get.dart';

class LargeScreenUploadImageView extends GetView<UploadImageController> {
  const LargeScreenUploadImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("upload image is working on Large screen"),
      ),
    );
  }
}
