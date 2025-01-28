import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend_waste_management/app/modules/recycle/controllers/recycle_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/core/theme/text_theme.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';

class RecycleView extends GetView<RecycleController> {
  const RecycleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    final AppTextsTheme textStyles =
        Theme.of(context).extension<AppTextsTheme>()!;

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              controller.arguments,
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Markdown(
                        selectable: true,
                        data: controller.recommendation.value,
                        styleSheet: MarkdownStyleSheet(
                          p: textStyles
                              .textPrimary, // Map your primary text style to paragraph text
                          h1: textStyles
                              .labelBigEmphasis, // Mapping your custom style for headers
                          h2: textStyles.labelDefaultEmphasis,
                          h3: textStyles.labelSmallEmphasis,
                          h4: textStyles.labelSmallDefault,
                          h5: textStyles.labelTinyDefault,
                          h6: textStyles.labelTinyDefault,
                          strong: textStyles
                              .labelDefaultEmphasis, // Strong emphasis (bold text)
                          em: textStyles.labelDefaultDefault.copyWith(
                            fontStyle:
                                FontStyle.italic, // Emphasized text (italics)
                          ),
                          code: textStyles.labelTinyDefault.copyWith(
                            backgroundColor:
                                Colors.grey[200], // Code block styling
                            fontFamily:
                                'Courier', // Use monospaced font for code
                          ),
                          blockquote: textStyles.labelSmallDefault.copyWith(
                            color: Colors.grey, // Styling blockquotes
                            fontStyle: FontStyle.italic,
                          ),
                          listBullet: textStyles
                              .labelTinyDefault, // Bullet list styling
                        ),
                        styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
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
