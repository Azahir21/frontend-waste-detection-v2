import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/account_setting/controllers/account_setting_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingView extends GetView<AccountSettingController> {
  const AccountSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: color.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
            child: Column(
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
                          AppLocalizations.of(context)!.account_setting,
                          context: context,
                        ),
                      ),
                    )
                  ],
                ),
                VerticalGap.formHuge(),
                AppText.labelSmallEmphasis(
                    AppLocalizations.of(context)!.account_info,
                    color: color.textSecondary,
                    context: context),
                VerticalGap.formHuge(),
                _buildInformationTiles(
                    context,
                    AppLocalizations.of(context)!.full_name,
                    GetStorage().read("username")),
                VerticalGap.formBig(),
                _buildInformationTiles(context,
                    AppLocalizations.of(context)!.phone_number, "+62 xxxxxxxx"),
                VerticalGap.formBig(),
                _buildInformationTiles(
                    context, AppLocalizations.of(context)!.gender, "Laki-laki"),
                VerticalGap.formBig(),
                _buildInformationTiles(
                    context,
                    AppLocalizations.of(context)!.email,
                    "${GetStorage().read("username")}@gmail.com"),
                VerticalGap.formBig(),
                _buildInformationTiles(
                    context,
                    AppLocalizations.of(context)!.username,
                    GetStorage().read("username")),
                VerticalGap.formBig(),
                _buildInformationTiles(
                    context,
                    AppLocalizations.of(context)!.address,
                    "Jl. Gebang Wetan No.1, Gebang Putih, Kec. Sukolilo, Surabaya "),
                const Spacer(),
                // CenteredTextButton.secondary(
                //     label: "Ubah",
                //     onTap: () {
                //       Get.toNamed('/edit-profile');
                //     },
                //     context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInformationTiles(
      BuildContext context, String lable, String value) {
    return Row(
      children: [
        AppText.labelSmallDefault(
          lable,
          context: context,
          textAlign: TextAlign.start,
        ),
        HorizontalGap.formSmall(),
        Expanded(
          child: AppText.labelSmallEmphasis(
            value,
            context: context,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
