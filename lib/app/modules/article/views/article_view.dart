import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/views/largescreen_article_view.dart';
import 'package:frontend_waste_management/app/modules/article/views/smallscreen_article_view.dart';

import 'package:get/get.dart';

import '../controllers/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenArticleView();
        } else {
          return LargeScreenArticleView();
        }
      }),
    );
  }
}
