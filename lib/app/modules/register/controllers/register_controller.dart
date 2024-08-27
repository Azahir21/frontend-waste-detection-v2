import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController

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

  Future<void> register() async {
    try {
      if (!_isAgree.value) {
        Get.snackbar(
            "Perhatian", "Anda harus menyetujui syarat dan ketentuan kami");
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
      Get.snackbar('Registration Success', 'Registration success');
      Get.offAllNamed("/onboarding", arguments: 3);
    } catch (e) {
      Get.snackbar(
          'Registration Error', 'Failed to Registration. Please try again.');
      print('Registration error: $e');
    }
  }

  bool validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Perhatian", "Email tidak valid");
      return false;
    }
    return true;
  }

  void validatePassword(String password) {
    validPassword.value = true;
    if (password.length < 8) {
      massage.value = "Password harus lebih dari 8 karakter";
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      massage.value = "Password harus mengandung setidaknya satu huruf besar";
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      massage.value = "Password harus mengandung setidaknya satu huruf kecil";
      validPassword.value = false;
      return;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      massage.value = "Password harus mengandung setidaknya satu angka";
      validPassword.value = false;
      return;
    }
    massage.value = "valid";
  }
}
