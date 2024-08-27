import 'package:frontend_waste_management/app/data/models/login_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
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

  String _email = '';
  String _password = '';
  get email => _email;
  get password => _password;
  set email(value) => _email = value;
  set password(value) => _password = value;

  Future<void> login() async {
    try {
      final response = await ApiServices().post(
          UrlConstants.login,
          {
            'username': _email,
            'password': _password,
          },
          contentType: 'application/x-www-form-urlencoded');
      Login loginData = Login.fromRawJson(response);
      GetStorage().write('token', loginData.accessToken);
      GetStorage().write('username', loginData.username);
      Get.offAllNamed("/bottomnav");
    } catch (e) {
      Get.snackbar('Login Error', 'Failed to login. Please try again.');
      print('Login error: $e');
    }
  }
}
