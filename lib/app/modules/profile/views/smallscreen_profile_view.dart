import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/profile/controllers/profile_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenProfileView extends GetView<ProfileController> {
  const SmallScreenProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconButton.secondary(
                        iconName: AppIconName.profile,
                        onTap: () {},
                        context: context,
                      ),
                      HorizontalGap.formBig(),
                      AppText.labelDefaultEmphasis(
                        controller.username,
                        context: context,
                      )
                    ],
                  ),
                  VerticalGap.formHuge(),
                  AppText.labelSmallEmphasis("Umum",
                      color: color.textSecondary, context: context),
                  VerticalGap.formHuge(),
                  _buildSettingButton(
                    context,
                    AppIconName.profile,
                    "Pengaturan Akun",
                    () {
                      Get.toNamed("/account-setting");
                    },
                  ),
                  VerticalGap.formMedium(),
                  _buildSettingButton(
                    context,
                    AppIconName.article,
                    "Syarat dan Ketentuan",
                    () {},
                  ),
                  VerticalGap.formMedium(),
                  _buildSettingButton(
                    context,
                    AppIconName.article,
                    "Kebijakan Privasi",
                    () {},
                  ),
                  VerticalGap.formHuge(),
                  VerticalGap.formHuge(),
                  CenteredTextButton.secondary(
                    label: "Keluar",
                    onTap: () {
                      controller.logout();
                    },
                    context: context,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingButton(BuildContext context, AppIconName appIconName,
      String label, void Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          AppIcon.main(appIconName: appIconName, context: context),
          HorizontalGap.formBig(),
          AppText.labelSmallEmphasis(label, context: context),
        ],
      ),
    );
  }
}
