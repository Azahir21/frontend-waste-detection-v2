import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/data/services/network_controller.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final isLoading = true.obs;
  final NetworkController networkController = Get.find<NetworkController>();

  @override
  void onInit() {
    super.onInit();
    String? savedLanguageCode = box.read('language');
    Locale newLocale;

    if (savedLanguageCode != null) {
      switch (savedLanguageCode) {
        case 'id':
          newLocale = const Locale('id', 'ID');
          break;
        case 'ja':
          newLocale = const Locale('ja', 'JP');
          break;
        default:
          newLocale = const Locale('en', 'US');
          break;
      }
      Get.updateLocale(newLocale);
    } else {
      // If no saved preference, fallback to default
      box.write('language', 'en');
      Get.updateLocale(const Locale('en', 'US'));
    }

    Future.delayed(const Duration(seconds: 5), () {
      networkController.setSplashScreenStatus(false);
      if (box.hasData('token')) {
        if (JwtDecoder.isExpired(box.read('token'))) {
          box.remove('token');
          showSuccessSnackbar(
            AppLocalizations.of(Get.context!)!.session_expired,
            AppLocalizations.of(Get.context!)!.please_login_again,
          );
          Get.offAllNamed("/onboarding");
        } else {
          Get.offAllNamed("/bottomnav");
        }
      } else {
        Get.offAllNamed("/onboarding");
      }
    });
  }
}
