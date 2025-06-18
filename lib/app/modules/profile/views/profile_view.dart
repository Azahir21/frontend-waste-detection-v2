import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/profile/controllers/profile_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/centered_text_button.dart';
import 'package:frontend_waste_management/app/widgets/dropdown.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    final languages = {
      'en': 'English',
      'id': 'Indonesian',
      'ja': 'Japanese',
    };
    String initialLanguage = controller.box.read('language') ?? 'en';

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconButton.secondary(
                        iconName: AppIconName.profile,
                        onTap: () {},
                        context: context,
                      ),
                      HorizontalGap.formBig(),
                      AppText.labelDefaultEmphasis(
                        controller.username,
                        context: context,
                      ),
                      const Spacer(),
                      _buildLanguageButton(context, languages, initialLanguage),
                    ],
                  ),
                  VerticalGap.formHuge(),
                  AppText.labelSmallEmphasis(
                      AppLocalizations.of(context)!.general,
                      color: color.textSecondary,
                      context: context),
                  VerticalGap.formHuge(),
                  _buildSettingButton(
                    context,
                    AppIconName.profile,
                    AppLocalizations.of(context)!.account_setting,
                    () {
                      Get.toNamed("/account-setting");
                    },
                  ),
                  VerticalGap.formMedium(),
                  _buildSettingButton(
                    context,
                    AppIconName.article,
                    AppLocalizations.of(context)!.terms_and_conditions,
                    () {},
                  ),
                  VerticalGap.formMedium(),
                  _buildSettingButton(
                    context,
                    AppIconName.article,
                    AppLocalizations.of(context)!.privacy_policy,
                    () {},
                  ),
                  VerticalGap.formMedium(),
                  // VerticalGap.formHuge(),
                  // CustomDropdown(
                  //   // initialValue: languages[initialLanguage],
                  //   onChanged: (value) async {
                  //     String? languageCode = languages.keys.firstWhere(
                  //       (code) => languages[code] == value,
                  //       orElse: () => 'en',
                  //     );
                  //     controller.updateLocale(languageCode);
                  //   },
                  //   dropDownItems: languages.values.toList(),
                  //   hintText: languages[initialLanguage],
                  //   width: double.infinity,
                  //   height: 70,
                  // ),
                  VerticalGap.formHuge(),
                  CenteredTextButton.secondary(
                    label: AppLocalizations.of(context)!.logout,
                    onTap: () {
                      controller.logout();
                    },
                    context: context,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingButton(BuildContext context, AppIconName appIconName,
      String label, void Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          AppIcon.main(appIconName: appIconName, context: context),
          HorizontalGap.formBig(),
          AppText.labelSmallEmphasis(label, context: context),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context,
      Map<String, String> languages, String initialLanguage) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 75,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.backgroundActionIconSecondary,
          borderRadius: BorderRadius.circular(23.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.labelSmallDefault(
              initialLanguage.toUpperCase(),
              context: context,
            ),
            HorizontalGap.formSmall(),
            Center(
              child: Image.asset(
                _getFlagAssetPath(initialLanguage),
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
      onSelected: (value) {
        String? languageCode = languages.keys.firstWhere(
          (code) => languages[code] == value,
          orElse: () => 'en',
        );
        controller.updateLocale(languageCode);
      },
      itemBuilder: (context) => languages.entries
          .map((entry) => PopupMenuItem<String>(
                value: entry.value,
                child: Row(
                  children: [
                    // Show flag icon for each language in the menu
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: entry.key == initialLanguage
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: entry.key == initialLanguage
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.blue)
                          : null,
                    ),
                    HorizontalGap.formSmall(),
                    Image.asset(
                      _getFlagAssetPath(entry.key),
                      width: 20,
                      height: 20,
                    ),
                    HorizontalGap.formSmall(),
                    Text(entry.value),
                  ],
                ),
              ))
          .toList(),
    );
  }

// Helper method to get the flag asset path based on language code
  String _getFlagAssetPath(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'assets/icons/flag_en.png'; // Path to English flag
      case 'id':
        return 'assets/icons/flag_id.png'; // Path to Indonesian flag
      case 'ja':
        return 'assets/icons/flag_ja.png'; // Path to Japanese flag
      default:
        return 'assets/icons/flag_en.png'; // Default to English flag
    }
  }
}
