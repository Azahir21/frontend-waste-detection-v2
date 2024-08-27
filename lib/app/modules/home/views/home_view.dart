import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/home/views/largescreen_home_view.dart';
import 'package:frontend_waste_management/app/modules/home/views/smallscreen_home_view.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenHomeView();
        } else {
          return LargeScreenHomeView();
        }
      }),
    );
  }
}
