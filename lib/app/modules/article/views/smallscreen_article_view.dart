import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/controllers/article_controller.dart';
import 'package:frontend_waste_management/app/modules/article/views/widgets/article_tiles.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:get/get.dart';

class SmallScreenArticleView extends GetView<ArticleController> {
  const SmallScreenArticleView({super.key});

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
                replacement: const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.labelDefaultEmphasis("Artikel Terbaru",
                            context: context),
                        VerticalGap.formBig(),
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
    );
  }
}
