import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_waste_management/app/modules/report_detail/controllers/report_detail_controller.dart';
import 'package:frontend_waste_management/app/modules/report_detail/views/widget/Item_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({Key? key}) : super(key: key);

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
          child: Obx(
            () => Visibility(
              visible: !controller.isLoading.value,
              replacement: Center(
                child: CircularProgressIndicator(),
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
                                      controller.reportDetail.value
                                                  .isWastePile ??
                                              false
                                          ? AppLocalizations.of(context)!
                                              .illegal_dumping_site
                                          : AppLocalizations.of(context)!
                                              .illegal_trash,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            VerticalGap.formMedium(),
                            if (controller.reportDetail.value.image != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.dialog(
                                        Dialog(
                                          child: Stack(
                                            children: [
                                              InteractiveViewer(
                                                child: Image.network(
                                                  controller.reportDetail.value
                                                      .image!,
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
                                      height: size.width * 0.35,
                                      width: size.width * 0.35,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(23.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            controller
                                                .reportDetail.value.image!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  HorizontalGap.formBig(),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            AppIcon.custom(
                                                size: 20,
                                                appIconName:
                                                    AppIconName.locationv2,
                                                context: context),
                                            HorizontalGap.formSmall(),
                                            AppText.labelSmallEmphasis(
                                              AppLocalizations.of(context)!
                                                  .location,
                                              context: context,
                                            ),
                                          ],
                                        ),
                                        VerticalGap.formMedium(),
                                        if (controller
                                                .reportDetail.value.address !=
                                            null)
                                          AppText.labelSmallDefault(
                                            controller
                                                .reportDetail.value.address!,
                                            textOverflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            context: context,
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            VerticalGap.formMedium(),
                            AppText.labelDefaultEmphasis(
                                AppLocalizations.of(context)!.capture_time,
                                context: context),
                            VerticalGap.formSmall(),
                            if (controller.reportDetail.value.captureTime !=
                                null)
                              AppText.labelSmallDefault(
                                DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                    controller.reportDetail.value.captureTime!),
                                context: context,
                              ),
                            VerticalGap.formMedium(),
                            AppText.labelDefaultEmphasis(
                              AppLocalizations.of(context)!.waste_detected,
                              context: context,
                            ),
                            VerticalGap.formMedium(),
                            if (controller.reportDetail.value.countedObjects !=
                                null)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller
                                    .reportDetail.value.countedObjects!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (controller.reportDetail.value
                                              .countedObjects![index].name !=
                                          "Garbage") {
                                        Get.toNamed("/recycle",
                                            arguments: controller
                                                .reportDetail
                                                .value
                                                .countedObjects![index]
                                                .name);
                                      } else {
                                        showFailedSnackbar(
                                            AppLocalizations.of(context)!
                                                .action_not_continue,
                                            AppLocalizations.of(context)!
                                                .illegal_dumping_recycle_error);
                                      }
                                    },
                                    child: ItemTiles(
                                      countObject: controller.reportDetail.value
                                          .countedObjects![index],
                                    ),
                                  );
                                },
                              ),
                            VerticalGap.formBig(),
                            Row(
                              children: [
                                AppText.labelDefaultEmphasis(
                                  AppLocalizations.of(context)!.status,
                                  context: context,
                                ),
                                Visibility(
                                  visible:
                                      controller.reportDetail.value.isPickup ??
                                          false,
                                  replacement: AppText.labelDefaultEmphasis(
                                    "   (${AppLocalizations.of(context)!.pickup_false})",
                                    context: context,
                                    color: Colors.red,
                                  ),
                                  child: AppText.labelDefaultEmphasis(
                                    "   (${AppLocalizations.of(context)!.pickup_true})",
                                    context: context,
                                    color: color.textButton,
                                  ),
                                ),
                              ],
                            ),
                            VerticalGap.formMedium(),
                            Visibility(
                              visible: controller.reportDetail.value.isPickup ??
                                  false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.labelDefaultEmphasis(
                                    "${AppLocalizations.of(context)!.detail_information_pickup} :",
                                    context: context,
                                  ),
                                  VerticalGap.formSmall(),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppText.labelSmallEmphasis(
                                          "${AppLocalizations.of(context)!.pickup_by}: ",
                                          context: context,
                                        ),
                                      ),
                                      Flexible(
                                        child: AppText.labelSmallDefault(
                                          controller.reportDetail.value
                                                  .pickupByUser ??
                                              "N/A",
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalGap.formSmall(),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppText.labelSmallEmphasis(
                                          "${AppLocalizations.of(context)!.pickup_at}: ",
                                          context: context,
                                        ),
                                      ),
                                      Flexible(
                                        child: AppText.labelSmallDefault(
                                          controller.reportDetail.value
                                                      .pickupAt !=
                                                  null
                                              ? DateFormat(
                                                      'yyyy-MM-dd HH:mm:ss')
                                                  .format(controller
                                                      .reportDetail
                                                      .value
                                                      .pickupAt!)
                                              : "N/A",
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  VerticalGap.formSmall(),
                                  if (controller.reportDetail.value.evidence !=
                                      null)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.labelSmallEmphasis(
                                            "${AppLocalizations.of(context)!.evidence_image}:",
                                            context: context),
                                        VerticalGap.formSmall(),
                                        GestureDetector(
                                          onTap: () {
                                            Get.dialog(
                                              Dialog(
                                                child: Stack(
                                                  children: [
                                                    InteractiveViewer(
                                                      child: Image.network(
                                                          controller
                                                              .reportDetail
                                                              .value
                                                              .evidence!),
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
                                            height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(23.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  controller.reportDetail.value
                                                      .evidence!,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  VerticalGap.formMedium(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
