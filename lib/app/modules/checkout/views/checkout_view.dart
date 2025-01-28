import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_waste_management/app/data/services/location_handler.dart';
import 'package:frontend_waste_management/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:frontend_waste_management/app/modules/checkout/views/Item_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/preview_page.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:latlng_picker/latlng_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => PreviewPage(
                                    image: controller.predict.encodedImages!,
                                  )),
                              child: Container(
                                height: size.width * 0.35,
                                width: size.width * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(23.0),
                                  image: DecorationImage(
                                    image:
                                        // AssetImage('assets/images/onboarding3.png'),
                                        Image.memory(base64Decode(controller
                                                .predict.encodedImages!))
                                            .image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            HorizontalGap.formBig(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                              label:
                                                  AppLocalizations.of(context)!
                                                      .set_location,
                                              onTap: () {
                                                Get.dialog(
                                                  pickLocation(
                                                      context,
                                                      size.height * 0.5,
                                                      size.width * 0.8),
                                                );
                                              },
                                              context: context),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () => Get.dialog(
                                          pickLocation(
                                              context,
                                              size.height * 0.5,
                                              size.width * 0.8),
                                        ),
                                        child: AppText.labelSmallDefault(
                                          controller.address.value ?? "",
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        VerticalGap.formMedium(),
                        AppText.labelDefaultEmphasis(
                          AppLocalizations.of(context)!.your_waste,
                          context: context,
                        ),
                        VerticalGap.formMedium(),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                controller.predict.countedObjects!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Get.toNamed("/recycle",
                                    arguments: controller
                                        .predict.countedObjects![index].name),
                                child: ItemTiles(
                                  countObject:
                                      controller.predict.countedObjects![index],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurStyle: BlurStyle.outer,
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.labelSmallDefault(
                              AppLocalizations.of(context)!.subtotal,
                              context: context),
                          AppText.labelSmallDefault(
                              AppLocalizations.of(context)!.number_of_points(
                                  controller.predict.subtotalpoint!),
                              color: color.textSecondary,
                              context: context),
                        ],
                      ),
                      VerticalGap.formSmall(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText.labelSmallEmphasis(
                              AppLocalizations.of(context)!.total_points,
                              context: context),
                          AppText.labelSmallEmphasis(
                              AppLocalizations.of(context)!.number_of_points(
                                  controller.predict.totalpoint!),
                              color: color.textSecondary,
                              context: context),
                        ],
                      ),
                      VerticalGap.formBig(),
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
                    ],
                  ),
                ),
              ),
            ],
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
            initialCenter: controller.fixedLocation ?? controller.initial,
            initialZoom: 13.0,
          ),
          onConfirm: (p0) async {
            controller.fixedLocation = p0[0];
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
