import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';

class ArticleController extends GetxController {
  //TODO: Implement ArticleController
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final _tokenService = TokenService();

  @override
  void onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    if (!await _tokenService.checkToken()) {
      return;
    }
    await getArticle();
    isLoading.value = false;
    return Future.value();
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
