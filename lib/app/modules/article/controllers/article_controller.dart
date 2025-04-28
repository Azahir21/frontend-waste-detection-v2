import 'dart:convert';

import 'package:frontend_waste_management/app/data/models/article_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticleController extends GetxController {
  //TODO: Implement ArticleController
  final RxBool isLoading = false.obs;
  final RxList<Article> articles = <Article>[].obs;
  final _tokenService = TokenService();
  final RxInt currentPage = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalPage = 0.obs;
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

  Future getNextPage() async {
    isLoading.value = true;
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
    }
    await getArticle();
    isLoading.value = false;
    return Future.value();
  }

  Future getPrevPage() async {
    isLoading.value = true;
    if (currentPage.value > 1) {
      currentPage.value--;
    }
    await getArticle();
    isLoading.value = false;
    return Future.value();
  }

  Future getArticle() async {
    try {
      final response = await ApiServices().get(
          '${UrlConstants.article}s?lang=${Get.locale!.languageCode}&page=${currentPage.value}&page_size=${pageSize.value}');
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.article_error, message);
        throw ('${AppLocalizations.of(Get.context!)!.article_error}: ${response.body}');
      }
      final responseBody = utf8.decode(response.bodyBytes);
      ArticleList articleList = ArticleList.fromJson(jsonDecode(responseBody));
      print(articleList.data![0].title);
      articles.value = articleList.data!;
      currentPage.value = articleList.page!;
      pageSize.value = articleList.pageSize!;
      totalPage.value = articleList.totalPage!;
    } catch (e) {
      throw ('${AppLocalizations.of(Get.context!)!.article_error}: $e');
    }
  }
}
