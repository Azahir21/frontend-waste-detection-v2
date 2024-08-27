import 'package:get/get.dart';

import '../controllers/recycle_controller.dart';

class RecycleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecycleController>(
      () => RecycleController(),
    );
  }
}
