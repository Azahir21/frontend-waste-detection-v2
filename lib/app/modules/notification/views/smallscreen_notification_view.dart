import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/notification/controllers/notification_controller.dart';
import 'package:frontend_waste_management/app/modules/notification/views/widgets/notification_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class SmallScreenNotificationView extends GetView<NotificationController> {
  const SmallScreenNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconButton.secondary(
                      iconName: AppIconName.backButton,
                      onTap: () {
                        Get.back();
                      },
                      context: context,
                    ),
                    Expanded(
                      child: Center(
                        child: AppText.labelDefaultEmphasis(
                          "Notifikasi",
                          context: context,
                        ),
                      ),
                    ),
                  ],
                ),
                VerticalGap.formHuge(),
                VerticalGap.formBig(),
                NotificationTiles(),
                VerticalGap.formMedium(),
                NotificationTiles(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
