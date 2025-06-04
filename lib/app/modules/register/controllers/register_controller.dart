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
  // Add to RegisterController class
  final fullNameError = Rxn<String>();
  final genderError = Rxn<String>();
  final usernameError = Rxn<String>();
  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

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

  bool validateInputs() {
    // Reset all errors
    fullNameError.value = null;
    genderError.value = null;
    usernameError.value = null;
    emailError.value = null;
    passwordError.value = null;

    bool isValid = true;

    // Validate fullName
    if (fullName.isEmpty) {
      fullNameError.value = AppLocalizations.of(Get.context!)!.name_required;
      isValid = false;
    }

    // Validate gender
    if (gender.isEmpty) {
      genderError.value = AppLocalizations.of(Get.context!)!.gender_required;
      isValid = false;
    }

    // Validate username
    if (username.isEmpty) {
      usernameError.value =
          AppLocalizations.of(Get.context!)!.username_required;
      isValid = false;
    }

    // Validate email
    if (email.isEmpty) {
      emailError.value = AppLocalizations.of(Get.context!)!.email_required;
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = AppLocalizations.of(Get.context!)!.email_not_valid;
      isValid = false;
    }

    // Validate password
    validatePassword(password);
    if (!validPassword.value) {
      passwordError.value = massage.value;
      isValid = false;
    }

    return isValid;
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
        print('Registration failed: ${response.body}');
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.register_error, message);
        throw ('Registration error: ${response.body}');
      }
      showSuccessSnackbar(
        AppLocalizations.of(Get.context!)!.register_success,
        AppLocalizations.of(Get.context!)!.register_success_message,
      );
      print('Registration successful: ${response.body}');
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
