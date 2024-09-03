import 'package:frontend_waste_management/app/data/services/network_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final isLoading = true.obs;
  final NetworkController networkController = Get.find<NetworkController>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      networkController.setSplashScreenStatus(false);
      if (box.hasData('token')) {
        if (JwtDecoder.isExpired(box.read('token'))) {
          box.remove('token');
          Get.snackbar("Token Expired", "Please login again");
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
