import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/history/controllers/history_controller.dart';
import 'package:frontend_waste_management/app/modules/history/views/widgets/history_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/pagination_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

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
                        AppText.labelDefaultEmphasis(
                            AppLocalizations.of(context)!.history,
                            context: context),
                        VerticalGap.formBig(),
                        ListView.builder(
                          itemCount: controller.sampahs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return HistoryTiles(
                                sampah: controller.sampahs[index]);
                          },
                        ),
                        Visibility(
                          visible: controller.totalPage.value > 1,
                          child: PaginationButton.primary(
                              currentPage: controller.currentPage.value,
                              totalPage: controller.totalPage.value,
                              onPrevious: () => controller.getPrevPage(),
                              onNext: () => controller.getNextPage(),
                              context: context),
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
