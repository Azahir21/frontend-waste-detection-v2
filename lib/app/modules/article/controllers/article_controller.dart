import 'dart:convert';

import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/date_convertion.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:simplytranslate/simplytranslate.dart';

class ArticleController extends GetxController {
  //TODO: Implement ArticleController
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final _tokenService = TokenService();
  // final st = SimplyTranslator(EngineType.google);

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
      if (response.statusCode != 200) {
        var message = await translate(jsonDecode(response.body)['detail']);
        Get.snackbar('Article Error', message);
        throw ('Article error: ${response.body}');
      }
      articles.value = parseArticles(response.body);
      for (var article in articles) {
        article.title = await translate(article.title!);
        // article.createdAt = await formatTanggal(article.createdAt!);
      }
      return articles;
    } catch (e) {
      throw ('Article error: $e');
    }
  }
}
