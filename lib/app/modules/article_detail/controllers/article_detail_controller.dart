import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:get/get.dart';

class ArticleDetailController extends GetxController {
  //TODO: Implement ArticleDetailController
  Article article = Get.arguments as Article;

  final count = 0.obs;
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

  void increment() => count.value++;
}
