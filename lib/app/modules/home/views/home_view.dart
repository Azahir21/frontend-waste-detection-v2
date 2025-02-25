import 'package:flutter/widgets.dart';
import 'package:frontend_waste_management/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/home/views/widgets/article_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchData(),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: color.backgroundGradient,
            ),
            child: Obx(
              () => Visibility(
                visible: !controller.isLoading.value,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: Obx(
                  () => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VerticalGap.formBig(),
                          Container(
                            width: double.infinity,
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                              color: color.backgroundActionIconPrimary,
                              borderRadius: BorderRadius.circular(23.0),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/score_board.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.dialog(
                                        barrierDismissible: false,
                                        badgeDialog(context),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        AppIcon.custom(
                                            appIconName: AppIconName.score,
                                            context: context),
                                        HorizontalGap.formSmall(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText.labelTinyDefault(
                                                AppLocalizations.of(context)!
                                                    .point,
                                                context: context),
                                            AppText.labelSmallEmphasis(
                                                controller.point.value
                                                    .toString(),
                                                context: context)
                                          ],
                                        ),
                                        HorizontalGap.formMedium(),
                                        AppText.labelSmallEmphasis("|",
                                            context: context),
                                        HorizontalGap.formMedium(),
                                        AppText.labelSmallEmphasis(
                                            controller.badgeName.value,
                                            context: context),
                                      ],
                                    ),
                                  ),
                                  VerticalGap.formHuge(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText.labelDefaultEmphasis(
                                          controller.username,
                                          context: context),
                                      IconButton(
                                          onPressed: () {
                                            Get.toNamed('/leaderboard');
                                          },
                                          icon: AppIcon.custom(
                                              appIconName:
                                                  AppIconName.leaderboard,
                                              context: context)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          VerticalGap.formBig(),
                          Row(
                            children: [
                              AppText.labelDefaultEmphasis(
                                  AppLocalizations.of(context)!.article,
                                  context: context),
                              const Spacer(),
                              CustomTextButton.primary(
                                  text: "More",
                                  onPressed: () => Get.toNamed('/article'),
                                  context: context)
                            ],
                          ),
                          VerticalGap.formMedium(),
                          ListView.builder(
                            itemCount: controller.articles.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ArticleTiles(
                                article: controller.articles[index],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Dialog chooseTypeWaste(BuildContext context, String label, Function() onTap) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.labelSmallEmphasis(label, context: context),
            VerticalGap.formMedium(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CustomIconButton.primary(
                      iconName: AppIconName.pile,
                      onTap: () async {
                        controller.isPile = true;
                        Get.back();
                        await onTap();
                      },
                      context: context,
                      height: 75,
                      width: 75,
                    ),
                    VerticalGap.formSmall(),
                    AppText.labelSmallEmphasis(
                        AppLocalizations.of(context)!.illegal_dumping_site,
                        context: context),
                  ],
                ),
                Column(
                  children: [
                    CustomIconButton.primary(
                      iconName: AppIconName.pcs,
                      onTap: () async {
                        controller.isPile = false;
                        Get.back();
                        await onTap();
                      },
                      context: context,
                      height: 75,
                      width: 75,
                    ),
                    VerticalGap.formSmall(),
                    AppText.labelSmallEmphasis(
                        AppLocalizations.of(context)!.illegal_trash,
                        context: context),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Dialog badgeDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Title
                AppText.labelDefaultEmphasis(
                  AppLocalizations.of(context)!.tier_information,
                  context: context,
                ),
                const SizedBox(height: 15),

                // Tier 1 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_1,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_1,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 2 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_2,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_2,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 3 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_3,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_3,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 4 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_4,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_4,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 5 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_5,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_5,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 6 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_6,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_6,
                  context: context,
                ),
                const Divider(height: 20),

                // Tier 7 Information
                AppText.labelSmallEmphasis(
                  AppLocalizations.of(context)!.tier_7,
                  context: context,
                ),
                AppText.labelSmallDefault(
                  AppLocalizations.of(context)!.points_needed_tier_7,
                  context: context,
                ),
                const Divider(height: 20),

                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: AppText.labelSmallDefault(
                      AppLocalizations.of(context)!.close_button,
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
