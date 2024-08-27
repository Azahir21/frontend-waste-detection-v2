import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/upload_image/views/largescreen_upload_image_view.dart';
import 'package:frontend_waste_management/app/modules/upload_image/views/smallscreen_upload_image_view.dart';

import 'package:get/get.dart';

import '../controllers/upload_image_controller.dart';

class UploadImageView extends GetView<UploadImageController> {
  const UploadImageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenUploadImageView();
        } else {
          return LargeScreenUploadImageView();
        }
      }),
    );
  }
}
