import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:frontend_waste_management/app/modules/onboarding/views/widgets/carousel_widget.dart';
import 'package:frontend_waste_management/app/modules/onboarding/views/widgets/circle_indicator.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/app/data/models/onboarding_model.dummy.dart';
import 'package:get/get.dart';

class SmallScreenOnboardingView extends GetView<OnboardingController> {
  SmallScreenOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: Theme.of(context).appColors.backgroundGradient,
          ),
          child: Column(
            children: [
              _buildCarousel(context, size),
              Obx(() => Visibility(
                    visible: !controller.lastIndex,
                    child: const Spacer(),
                  )),
              _buildNavigationRow(context),
              VerticalGap.formBig(),
              Obx(() => Visibility(
                    visible: controller.lastIndex,
                    child: _buildBottomButtons(context),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, Size size) {
    return Obx(() {
      return SizedBox(
        height: controller.lastIndex ? size.height * 0.65 : size.height * 0.7,
        child: PageView.builder(
          itemCount: onBoardingList.length,
          physics: const ClampingScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (index) =>
              controller.onPageChanged(index, onBoardingList.length),
          itemBuilder: (context, index) {
            return CustomCarouselView(index: index);
          },
        ),
      );
    });
  }

  Widget _buildNavigationRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => Visibility(
              visible: controller.firstIndex,
              replacement: SizedBox(
                width: controller.getStringWidth(
                  "Lewati",
                  const TextStyle(fontSize: 16),
                ),
              ),
              child: CustomTextButton.primary(
                text: "Lewati",
                onPressed: () => controller.skipToEnd(onBoardingList.length),
                context: context,
              ),
            )),
        CircleIndicator(currentPageNotifier: controller.currentPageNotifier),
        Obx(() => Visibility(
              visible: controller.firstIndex || !controller.lastIndex,
              replacement: SizedBox(
                width: controller.getStringWidth(
                  "Lanjut",
                  const TextStyle(fontSize: 16),
                ),
              ),
              child: CustomTextButton.primary(
                text: "Lanjut",
                onPressed: controller.goToNextPage,
                context: context,
              ),
            )),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        CenteredTextButton.primary(
          label: "Masuk",
          onTap: () => Get.toNamed("/login"),
          context: context,
        ),
        VerticalGap.formMedium(),
        CenteredTextButton.secondary(
          label: "Daftar",
          onTap: () => Get.toNamed("/register"),
          context: context,
        ),
      ],
    );
  }
}
