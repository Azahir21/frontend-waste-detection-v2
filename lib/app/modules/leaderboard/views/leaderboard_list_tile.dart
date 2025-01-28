import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/leaderboard_model.dart';
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/horizontal_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';

class LeaderboardListTile extends StatelessWidget {
  const LeaderboardListTile({super.key, required this.data});

  final Leaderboard data;

  @override
  Widget build(BuildContext context) {
    String rangking = data.ranking.toString();
    if (data.ranking! < 10) {
      rangking = "0${data.ranking}";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 4, 32, 4),
      child: Container(
        child: Row(
          children: [
            Container(
              width: 60,
              alignment: Alignment.center,
              child: AppText.customSize(rangking, size: 40, context: context),
            ),
            HorizontalGap.formBig(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelDefaultEmphasis(data.username!, context: context),
                AppText.labelSmallDefault(
                    "${data.totalPoints!.toString()} ${AppLocalizations.of(context)!.point}",
                    context: context)
              ],
            ),
            const Spacer(),
            if (data.isQueryingUser!)
              AppIcon.custom(appIconName: AppIconName.star, context: context),
            if (data.ranking == 1)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: AppIcon.custom(
                  appIconName: AppIconName.crown,
                  color: Color(0xFFFFB743),
                  context: context,
                ),
              )
            else if (data.ranking == 2)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: AppIcon.custom(
                  appIconName: AppIconName.crown,
                  color: Color(0xFFCDCDCD),
                  context: context,
                ),
              )
            else if (data.ranking == 3)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: AppIcon.custom(
                  appIconName: AppIconName.crown,
                  color: Color(0xFF973B3B),
                  context: context,
                ),
              )
          ],
        ),
      ),
    );
  }
}
