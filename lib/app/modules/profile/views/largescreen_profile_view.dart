import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class LargeScreenProfileView extends GetView<ProfileController> {
  const LargeScreenProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("profile is working on Large screen"),
      ),
    );
  }
}
