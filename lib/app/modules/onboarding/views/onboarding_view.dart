import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/onboarding/views/largescreen_onboarding_view.dart';
import 'package:frontend_waste_management/app/modules/onboarding/views/smallscreen_onboarding_view.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart'; // Pastikan untuk mengimport controller yang sesuai

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenOnboardingView();
        } else {
          return LargeScreenOnboardingView();
        }
      }),
    );
  }
}
