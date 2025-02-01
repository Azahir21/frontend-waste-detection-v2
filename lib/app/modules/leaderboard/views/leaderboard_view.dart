import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/views/leaderboard_list_tile.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: AppText.labelDefaultEmphasis(
                              AppLocalizations.of(context)!.leaderboard,
                              context: context),
                        ),
                        VerticalGap.formBig(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HorizontalGap.formHuge(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.activeBotton.value == 'weekly'
                                          ? color.textButton
                                          : null,
                                ),
                                onPressed: () {
                                  controller.show.value = controller.weekly;
                                  controller.activeBotton.value = 'weekly';
                                },
                                child: AppText.labelTinyEmphasis(
                                  AppLocalizations.of(context)!.weekly,
                                  color:
                                      controller.activeBotton.value == 'weekly'
                                          ? color.formFieldBorder
                                          : color.textButton,
                                  context: context,
                                ),
                              ),
                              HorizontalGap.formSmall(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.activeBotton.value == 'monthly'
                                          ? color.textButton
                                          : null,
                                ),
                                onPressed: () {
                                  controller.show.value = controller.monthly;
                                  controller.activeBotton.value = 'monthly';
                                },
                                child: AppText.labelTinyEmphasis(
                                  AppLocalizations.of(context)!.monthly,
                                  color:
                                      controller.activeBotton.value == 'monthly'
                                          ? color.formFieldBorder
                                          : color.textButton,
                                  context: context,
                                ),
                              ),
                              HorizontalGap.formSmall(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.activeBotton.value == 'allTime'
                                          ? color.textButton
                                          : null,
                                ),
                                onPressed: () {
                                  controller.show.value = controller.allTime;
                                  controller.activeBotton.value = 'allTime';
                                },
                                child: AppText.labelTinyEmphasis(
                                  AppLocalizations.of(context)!.all_time,
                                  color:
                                      controller.activeBotton.value == 'allTime'
                                          ? color.formFieldBorder
                                          : color.textButton,
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: controller.show.length > 10
                              ? 10
                              : controller.show.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return LeaderboardListTile(
                                data: controller.show[index]);
                          },
                        ),
                        Visibility(
                          visible: controller.show.length > 10,
                          child: Column(
                            children: [
                              VerticalGap.formBig(),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: color.textButton,
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                    ),
                                    VerticalGap.formTiny(),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: color.textButton,
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                    ),
                                    VerticalGap.formTiny(),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: color.textButton,
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              VerticalGap.formMedium(),
                              if (controller.show.length > 10)
                                LeaderboardListTile(data: controller.show[10]),
                            ],
                          ),
                        ),
                        VerticalGap.formBig(),
                      ],
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
