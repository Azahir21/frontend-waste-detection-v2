import 'package:flutter/material.dart';
import 'package:frontend_waste_management/core/theme/color_theme.dart';
import 'package:frontend_waste_management/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management/core/theme/text_theme.dart';
import 'package:frontend_waste_management/dependency_injection.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'app/routes/app_pages.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
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
      ),
    );
  }
}
