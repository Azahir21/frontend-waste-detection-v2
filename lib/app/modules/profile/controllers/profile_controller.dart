import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final String username = GetStorage().read('username');
  final box = GetStorage();
  final homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
  }

  void updateLocale(String languageCode) {
    Locale newLocale;

    // Determine which locale to set based on the language code
    switch (languageCode) {
      case 'en':
        newLocale = const Locale('en', 'US');
        break;
      case 'id':
        newLocale = const Locale('id', 'ID');
        break;
      case 'ja':
        newLocale = const Locale('ja', 'JP');
        break;
      default:
        newLocale = const Locale('en', 'US'); // Default to English
        break;
    }
    homeController.fetchData();
    Get.updateLocale(newLocale);
    box.write('language', languageCode);
  }

  void logout() {
    box.remove('token');
    box.remove('username');
    Get.offAllNamed('/onboarding');
  }
}
