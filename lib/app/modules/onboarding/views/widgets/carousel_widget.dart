import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/onboarding_model.dummy.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomCarouselView extends StatelessWidget {
  const CustomCarouselView({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final List<OnBoardModel> onBoardingList = [
      OnBoardModel(
        image: "assets/images/onboarding1.png",
        title: AppLocalizations.of(context)!.onboarding_1_title,
        description: AppLocalizations.of(context)!.onboarding_1_content,
      ),
      OnBoardModel(
        image: "assets/images/onboarding2.png",
        title: AppLocalizations.of(context)!.onboarding_2_title,
        description: AppLocalizations.of(context)!.onboarding_2_content,
      ),
      OnBoardModel(
        image: "assets/images/onboarding3.png",
        title: AppLocalizations.of(context)!.onboarding_3_title,
        description: AppLocalizations.of(context)!.onboarding_3_content,
      ),
    ];

    var data = onBoardingList[index];
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    data.image,
                  ),
                  fit: BoxFit.contain),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: AppText.labelBigEmphasis(data.title,
              textAlign: TextAlign.center, context: context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: AppText.textPrimary(
            data.description,
            textAlign: TextAlign.center,
            context: context,
            color: Theme.of(context).appColors.textSecondary,
          ),
        )
      ],
    );
  }
}
