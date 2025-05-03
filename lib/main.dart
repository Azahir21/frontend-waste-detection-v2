import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/models/review_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/local_notifications.dart';
import 'package:frontend_waste_management/app/modules/history/controllers/history_controller.dart';
import 'package:frontend_waste_management/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_waste_management/core/theme/color_theme.dart';
import 'package:frontend_waste_management/core/theme/dimension_theme.dart';
import 'package:frontend_waste_management/core/theme/text_theme.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:frontend_waste_management/dependency_injection.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:workmanager/workmanager.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await GetStorage.init();
    await LocalNotifications.init();
    final homeController = Get.put(HomeController());
    final historyController = Get.put(HistoryController());
    try {
      // Recreate your ReviewModel from inputData (assumes your model has fromJson/toJson methods)
      final reviewData = ReviewModel.fromJson(inputData!);
      print("Background task data: $reviewData");
      // Perform your API call
      final response =
          await ApiServices().postSampahV2(UrlConstants.userSampah, reviewData);
      final responseData = jsonDecode(response);
      print("Background task response: $responseData");
      // If there's an error message in the response, you might want to handle it here.
      if (responseData.containsKey('detail')) {
        // On error, show a local notification with the error message.
        final message = responseData['detail'];
        print("Background task failed: $message");
        var title;
        if (GetStorage().read('language') == 'id') {
          title = "Laporan Gagal";
        } else if (GetStorage().read('language') == 'ja') {
          title = "報告に失敗しました";
        } else {
          title = "Report Failed";
        }
        await LocalNotifications.showSimpleNotification(
          title: title,
          body: message,
          payload: "error",
        );
        debugPrint("Background task failed: $message");
      } else {
        // On success, extract the report id and message.
        final reportId = responseData['report-id'].toString();
        final message = responseData['message'];
        String title;
        if (GetStorage().read('language') == 'id') {
          title = "Laporan Berhasil";
        } else if (GetStorage().read('language') == 'ja') {
          title = "報告が成功しました";
        } else {
          title = "Report Success";
        }

        // Send a local notification with the report id as payload.
        await LocalNotifications.showSimpleNotification(
          title: title,
          body: message,
          payload: reportId,
        );
        await historyController.fetchData();
        await homeController.fetchData();
      }
    } catch (e) {
      // Optionally handle exceptions here.
      debugPrint("Background task error: $e");
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    // isInDebugMode: true,
  );
  await LocalNotifications.init();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  final box = GetStorage();
  String? savedLanguageCode = box.read('language');
  Locale appLocale;
  switch (savedLanguageCode) {
    case 'id':
      appLocale = const Locale('id', 'ID');
      break;
    case 'ja':
      appLocale = const Locale('ja', 'JP');
      break;
    default:
      appLocale = const Locale('en', 'US'); // Default to English
      break;
  }
  runApp(MyApp(appLocale: appLocale));

  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final Locale appLocale;
  const MyApp({required this.appLocale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
        // title: "Kolekan",
        title: "Lara'an",
        scrollBehavior: MyCustomScrollBehavior(),
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
        locale: appLocale,
        fallbackLocale: const Locale('en', 'US'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('id', 'ID'), // Indonesian
          Locale('ja', 'JP'), // Japanese
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
