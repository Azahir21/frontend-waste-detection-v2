import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/vertical_gap.dart';

class NotificationTiles extends StatelessWidget {
  const NotificationTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Listview
        AppText.labelSmallDefault(
          "Selamat anda mendapat hadiah dari Laraan",
          context: context,
        ),
        VerticalGap.formSmall(),
        AppText.labelTinyDefault("Date", context: context)
      ],
    );
  }
}
