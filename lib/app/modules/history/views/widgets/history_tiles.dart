import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/sampah_model.dart';
import 'package:frontend_waste_management/app/data/services/date_convertion.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTiles extends StatelessWidget {
  const HistoryTiles({Key? key, required this.sampah}) : super(key: key);
  final Sampah sampah;

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;

    return GestureDetector(
      onTap: () => Get.toNamed('/report-detail', arguments: sampah.id),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconButton.primary(
                iconName: AppIconName.trash,
                onTap: () {},
                context: context,
                height: 60,
                width: 60,
              ),
              HorizontalGap.formBig(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.labelSmallEmphasis(
                            formatTanggal(sampah.captureTime!.toString()),
                            context: context),
                        AppText.labelSmallEmphasis(
                            AppLocalizations.of(context)!
                                .number_of_points(sampah.point!),
                            context: context),
                      ],
                    ),
                    VerticalGap.formSmall(),
                    AppText.textPrimary(
                      sampah.address!,
                      context: context,
                      color: color.textSecondary,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          VerticalGap.formMedium()
        ],
      ),
    );
  }
}
