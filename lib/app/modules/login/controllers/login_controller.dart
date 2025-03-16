import 'dart:convert';

import 'package:frontend_waste_management/app/data/models/login_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  String _email = '';
  String _password = '';
  String _resetEmail = '';
  String _resetUsername = '';
  String _resetPassword = '';
  final RxBool validPassword = true.obs;
  final massage = "".obs;
  get email => _email;
  get password => _password;
  get resetEmail => _resetEmail;
  get resetUsername => _resetUsername;
  get resetPassword => _resetPassword;
  set email(value) => _email = value;
  set password(value) => _password = value;
  set resetEmail(value) => _resetEmail = value;
  set resetUsername(value) => _resetUsername = value;
  set resetPassword(value) => _resetPassword = value;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login() async {
    try {
      final response = await ApiServices().post(
          UrlConstants.login,
          {
            'username': _email,
            'password': _password,
          },
          contentType: 'application/x-www-form-urlencoded');
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.login_error, message);
        throw ('Login error: ${response.body}');
      }
      Login loginData = Login.fromRawJson(response.body);
      GetStorage().write('token', loginData.accessToken);
      GetStorage().write('username', loginData.username);
      Get.offAllNamed("/bottomnav");
    } catch (e) {
      print('Login error: $e');
    }
  }

  Future<void> forgotPassword() async {
    try {
      print("object");
      final response = await ApiServices().post(
        UrlConstants.forgotPassword,
        {
          'email': _resetEmail,
          'username': _resetUsername,
          'password': _resetPassword,
        },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.reset_password_error, message);
        throw ('Reset password error: ${response.body}');
      }
      showSuccessSnackbar(
          AppLocalizations.of(Get.context!)!.reset_password_success,
          AppLocalizations.of(Get.context!)!.please_login_new_password);
      Get.offAllNamed("/login");
    } catch (e) {
      print('Reset password error: $e');
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
