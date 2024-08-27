import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/profile/views/largescreen_profile_view.dart';
import 'package:frontend_waste_management/app/modules/profile/views/smallscreen_profile_view.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenProfileView();
        } else {
          return LargeScreenProfileView();
        }
      }),
    );
  }
}
