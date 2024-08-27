import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final box = GetStorage();
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

  final String username = GetStorage().read('username');

  void logout() {
    box.remove('token');
    box.remove('username');
    Get.offAllNamed('/onboarding');
  }
}
