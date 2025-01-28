import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend_waste_management/app/modules/report_detail/controllers/report_detail_controller.dart';
import 'package:frontend_waste_management/app/modules/report_detail/views/widget/Item_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/preview_page.dart';
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
                                                  .captureTime !=
                                              null
                                          ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(controller.reportDetail
                                                  .value.captureTime!)
                                          : "",
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
                                    onTap: () => Get.to(() => PreviewPage(
                                          image: controller
                                              .reportDetail.value.image!,
                                        )),
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
                              AppLocalizations.of(context)!.waste_detected,
                              context: context,
                            ),
                            VerticalGap.formMedium(),
                            if (controller.reportDetail.value.countedObjects !=
                                null)
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.reportDetail.value
                                      .countedObjects!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.toNamed("/recycle",
                                          arguments: controller
                                              .reportDetail
                                              .value
                                              .countedObjects![index]
                                              .name),
                                      child: ItemTiles(
                                        countObject: controller.reportDetail
                                            .value.countedObjects![index],
                                      ),
                                    );
                                  }),
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
