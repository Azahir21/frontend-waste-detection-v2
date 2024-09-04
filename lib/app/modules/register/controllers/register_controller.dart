import 'dart:convert';

import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  final RxBool _isAgree = false.obs;
  bool get isAgree => _isAgree.value;
  set isAgree(bool value) => _isAgree.value = value;

  String fullName = "";
  String gender = "";
  String username = "";
  String email = "";
  String password = "";
  final RxBool validPassword = true.obs;
  final massage = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> register() async {
    try {
      if (!_isAgree.value) {
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.attention,
          AppLocalizations.of(Get.context!)!.aggrement_checklist_error,
        );
        return;
      }
      final response = await ApiServices().post(
        UrlConstants.register,
        {
          "fullName": fullName,
          "jenisKelamin": gender,
          "username": username,
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode != 200) {
        var message = await translate(jsonDecode(response.body)['detail']);
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.register_error, message);
        throw ('Registration error: ${response.body}');
      }
      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.register_success,
        AppLocalizations.of(Get.context!)!.register_success_message,
      );
      Get.offAllNamed("/onboarding", arguments: 3);
    } catch (e) {
      print('Registration error: $e');
    }
  }

  bool validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      showFailedSnackbar(AppLocalizations.of(Get.context!)!.attention,
          AppLocalizations.of(Get.context!)!.email_not_valid);
      return false;
    }
    return true;
  }

  void validatePassword(String password) {
    validPassword.value = true;
    if (password.length < 8) {
      massage.value =
          AppLocalizations.of(Get.context!)!.password_has_8_characters;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_uppercase;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_lowercase;
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      massage.value = AppLocalizations.of(Get.context!)!.password_has_number;
      validPassword.value = false;
      return;
    }
    massage.value = "valid";
  }
}
