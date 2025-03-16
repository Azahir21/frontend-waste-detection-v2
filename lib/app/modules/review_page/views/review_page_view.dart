import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlng_picker/latlng_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/review_page_controller.dart';

class ReviewPageView extends GetView<ReviewPageController> {
  const ReviewPageView({super.key});
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalGap.formHuge(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton.secondary(
                      iconName: AppIconName.backButton,
                      onTap: () {
                        Get.back();
                      },
                      context: context,
                    ),
                    Visibility(
                      visible: controller.data.useGarbagePileModel!,
                      replacement: AppText.labelDefaultEmphasis(
                          AppLocalizations.of(context)!.illegal_trash,
                          context: context),
                      child: AppText.labelDefaultEmphasis(
                          AppLocalizations.of(context)!.illegal_dumping_site,
                          context: context),
                    ),
                    CustomIconButton.secondary(
                      iconName: AppIconName.info,
                      onTap: () {
                        Get.dialog(
                          toolsTips(context),
                        );
                      },
                      context: context,
                    ),
                  ],
                ),
                VerticalGap.formMedium(),
                GestureDetector(
                  onTap: () {
                    // create dialog
                    Get.dialog(
                      Dialog(
                        child: Stack(
                          children: [
                            InteractiveViewer(
                              child: Image.file(
                                File(controller.data.xfile!.path),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: size.height * 0.28,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(23.0),
                      image: DecorationImage(
                        image:
                            // AssetImage('assets/images/onboarding3.png'),
                            FileImage(File(controller.data.xfile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                VerticalGap.formMedium(),
                Row(
                  children: [
                    AppIcon.custom(
                        size: 20,
                        appIconName: AppIconName.locationv2,
                        context: context),
                    HorizontalGap.formSmall(),
                    AppText.labelSmallEmphasis(
                      AppLocalizations.of(context)!.location,
                      context: context,
                    ),
                  ],
                ),
                VerticalGap.formMedium(),
                Obx(
                  () => Visibility(
                    visible: controller.address.value != null,
                    replacement: Column(
                      children: [
                        AppText.labelTinyDefault(
                            AppLocalizations.of(context)!
                                .location_not_specified,
                            context: context),
                        VerticalGap.formSmall(),
                        CenteredTextButton.primary(
                            label: AppLocalizations.of(context)!.set_location,
                            onTap: () {
                              Get.dialog(
                                pickLocation(context, size.height * 0.5,
                                    size.width * 0.8),
                              );
                            },
                            context: context),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => Get.dialog(
                        pickLocation(
                            context, size.height * 0.5, size.width * 0.8),
                      ),
                      child: AppText.labelSmallDefault(
                        controller.address.value ?? "",
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        context: context,
                      ),
                    ),
                  ),
                ),
                VerticalGap.formMedium(),
                AppText.labelSmallEmphasis(
                    AppLocalizations.of(context)!.capture_time,
                    context: context),
                VerticalGap.formSmall(),
                AppText.labelSmallDefault(
                    DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(controller.data.captureDate!),
                    context: context),
                Spacer(),
                Obx(
                  () => CenteredTextButton.primary(
                    label: AppLocalizations.of(context)!.submit_now,
                    onTap: () async {
                      await controller.postImageData();
                      // Get.offAllNamed("/bottomnav");
                    },
                    isEnabled: controller.buttonEnable.value,
                    context: context,
                  ),
                ),
                VerticalGap.formHuge()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toolsTips(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.information),
      content: AppText.labelSmallDefault(
          AppLocalizations.of(context)!.checkout_information,
          context: context),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  Widget pickLocation(BuildContext context, double height, double width) {
    return AlertDialog(
      title: AppText.labelSmallEmphasis(AppLocalizations.of(context)!.location,
          context: context),
      content: SizedBox(
        height: height,
        width: width,
        child: LatLngPicker(
          options: MapOptions(
            initialCenter: controller.fixedLocation.value ?? controller.initial,
            initialZoom: 13.0,
          ),
          onConfirm: (p0) async {
            controller.fixedLocation.value = p0[0];
            controller.address.value = await getAddressFromLatLng(p0[0]);
            Get.back();
          },
        ),
      ),
      actions: [
        Center(
          child: CustomTextButton.secondary(
            text: AppLocalizations.of(context)!.cancel,
            onPressed: () {
              Get.back();
            },
            context: context,
          ),
        ),
      ],
    );
  }
}
