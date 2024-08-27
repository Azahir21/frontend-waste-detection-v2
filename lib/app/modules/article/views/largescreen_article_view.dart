import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/article/controllers/article_controller.dart';
import 'package:get/get.dart';

class LargeScreenArticleView extends GetView<ArticleController> {
  const LargeScreenArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("articleview is working on large screen"),
      ),
    );
  }
}
