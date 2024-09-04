import 'package:frontend_waste_management/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/home/views/widgets/article_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SmallScreenHomeView extends GetView<HomeController> {
  const SmallScreenHomeView({super.key});

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
                              padding: const EdgeInsets.only(left: 32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                              controller.point.value.toString(),
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
                                  VerticalGap.formHuge(),
                                  AppText.labelDefaultEmphasis(
                                      controller.username,
                                      context: context)
                                ],
                              ),
                            ),
                          ),
                          VerticalGap.formBig(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CustomIconButton.primary(
                                    iconName: AppIconName.map,
                                    onTap: () {
                                      Get.toNamed('/maps');
                                    },
                                    context: context,
                                    height: 60,
                                    width: 60,
                                  ),
                                  VerticalGap.formSmall(),
                                  AppText.labelSmallEmphasis(
                                      AppLocalizations.of(context)!.maps,
                                      context: context),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomIconButton.primary(
                                    iconName: AppIconName.scan,
                                    onTap: () async {
                                      await controller.getImageFromCamera();
                                    },
                                    context: context,
                                    height: 60,
                                    width: 60,
                                  ),
                                  VerticalGap.formSmall(),
                                  AppText.labelSmallEmphasis(
                                      AppLocalizations.of(context)!.camera,
                                      context: context),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomIconButton.primary(
                                    iconName: AppIconName.add,
                                    onTap: () async {
                                      await controller.getImageFromGallery();
                                    },
                                    context: context,
                                    height: 60,
                                    width: 60,
                                  ),
                                  VerticalGap.formSmall(),
                                  AppText.labelSmallEmphasis(
                                      AppLocalizations.of(context)!.gallery,
                                      context: context),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomIconButton.primary(
                                    iconName: AppIconName.info,
                                    onTap: () async {
                                      Get.toNamed('/leaderboard');
                                    },
                                    context: context,
                                    height: 60,
                                    width: 60,
                                  ),
                                  VerticalGap.formSmall(),
                                  AppText.labelSmallEmphasis(
                                      AppLocalizations.of(context)!.leaderboard,
                                      context: context),
                                ],
                              ),
                            ],
                          ),
                          VerticalGap.formBig(),
                          AppText.labelDefaultEmphasis(
                              AppLocalizations.of(context)!.article,
                              context: context),
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
}
