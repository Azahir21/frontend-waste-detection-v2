import 'package:get/get.dart';

import '../controllers/review_page_controller.dart';

class ReviewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewPageController>(
      () => ReviewPageController(),
    );
  }
}
