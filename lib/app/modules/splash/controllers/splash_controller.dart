import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  final box = GetStorage();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      if (box.hasData('token')) {
        Get.offNamed("/bottomnav");
      } else {
        Get.offNamed("/onboarding");
      }
    });
  }
}
