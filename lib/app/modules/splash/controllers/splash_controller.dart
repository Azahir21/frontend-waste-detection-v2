import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  final box = GetStorage();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      if (box.hasData('token')) {
        if (JwtDecoder.isExpired(box.read('token'))) {
          box.remove('token');
          Get.snackbar(
            "Session Expired",
            "Please login again",
          );
          Get.offAllNamed("/onboarding");
          return;
        }
        Get.offNamed("/bottomnav");
      } else {
        Get.offNamed("/onboarding");
      }
    });
  }
}
