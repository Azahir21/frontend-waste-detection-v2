import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management/app/modules/maps/controllers/maps_controller.dart';
import 'package:frontend_waste_management/app/modules/report_detail/views/widget/Item_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/preview_page.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Popup extends GetView<MapsController> {
  Popup({Key? key, required this.detail}) : super(key: key);
  final SampahDetail detail;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 1.0,
      minChildSize: 0.12,
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent == notification.minExtent) {
              controller.selectedMarkerDetail.value = null;
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalGap.formMedium(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ],
                  ),
                  VerticalGap.formHuge(),
                  if (detail.image != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        detail.image!,
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
                              borderRadius: BorderRadius.circular(23.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  detail.image!,
                                ),
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
                              if (detail.address != null)
                                AppText.labelSmallDefault(
                                  detail.address!,
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
                  AppText.labelSmallDefault(
                      DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(detail.captureTime!),
                      context: context),
                  VerticalGap.formMedium(),
                  AppText.labelDefaultEmphasis(
                    AppLocalizations.of(context)!.waste_detected,
                    context: context,
                  ),
                  VerticalGap.formMedium(),
                  if (detail.countedObjects != null)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: detail.countedObjects!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (detail.countedObjects![index].name !=
                                "Garbage") {
                              Get.toNamed("/recycle",
                                  arguments:
                                      detail.countedObjects![index].name);
                            } else {
                              showFailedSnackbar(
                                  AppLocalizations.of(context)!
                                      .action_not_continue,
                                  AppLocalizations.of(context)!
                                      .illegal_dumping_recycle_error);
                            }
                          },
                          child: ItemTiles(
                            countObject: detail.countedObjects![index],
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
                        visible: detail.isPickup!,
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
                    visible: detail.isPickup!,
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
                                detail.pickupByUser ?? "N/A",
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
                                detail.pickupAt != null
                                    ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(detail.pickupAt!)
                                    : "N/A",
                                context: context,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
