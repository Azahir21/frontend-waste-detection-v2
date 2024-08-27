import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/color_theme.dart';
import 'package:frontend_waste_management/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management/core/theme/text_theme.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // title: "Kolekan",
      title: "Lara'an",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        extensions: [
          AppDimensionsTheme.main(View.of(context)),
          AppColorsTheme.light(),
          AppTextsTheme.main(),
        ],
      ),
    );
  }
}
