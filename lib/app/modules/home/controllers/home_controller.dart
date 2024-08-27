import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/models/point_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final String username = GetStorage().read('username');
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final RxInt point = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    await getPoint();
    await getArticle();
    isLoading.value = false;
    return Future.value();
  }

  Future<void> getPoint() async {
    try {
      final response = await ApiServices().get(UrlConstants.point);
      Point pointData = Point.fromRawJson(response);
      point.value = pointData.point!;
    } catch (e) {
      Get.snackbar('Some thing error', 'Failed to get koin data.');
      print('Point error: $e');
    }
  }

  Future<List<Article>> getArticle() async {
    try {
      final response = await ApiServices().get('${UrlConstants.article}s');
      articles.value = parseArticles(response);
      return articles;
    } catch (e) {
      Get.snackbar('Article Error', 'Failed to get article. Please try again.');
      throw ('Article error: $e');
    }
  }
}
