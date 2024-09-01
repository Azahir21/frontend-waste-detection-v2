import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/leaderboard_model.dart';
import 'package:frontend_waste_management/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:get/get.dart';

class SmallScreenLeaderboardView extends GetView<LeaderboardController> {
  SmallScreenLeaderboardView({super.key});

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
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.labelDefaultEmphasis("Leaderboard",
                            context: context),
                        VerticalGap.formBig(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CenteredTextButton.primary(
                                width: 100,
                                label: "Minggu",
                                onTap: () {
                                  controller.show.value = controller.weekly;
                                },
                                context: context),
                            CenteredTextButton.primary(
                                width: 100,
                                label: "Monthly",
                                onTap: () {
                                  controller.show.value = controller.monthly;
                                },
                                context: context),
                            CenteredTextButton.primary(
                                width: 100,
                                label: "All Time",
                                onTap: () {
                                  controller.show.value = controller.allTime;
                                },
                                context: context),
                          ],
                        ),
                        ListView.builder(
                          itemCount: controller.show.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(
                                  controller.show[index].ranking.toString()),
                              title: Text(controller.show[index].username!),
                              subtitle: Text(controller.show[index].totalPoints
                                  .toString()),
                              trailing: controller.show[index].isQueryingUser!
                                  ? const Icon(Icons.star)
                                  : null,
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
    );
  }
}
