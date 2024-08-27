import 'package:flutter/material.dart';
import 'package:frontend_waste_management/app/modules/recycle/views/largescreen_recycle_view.dart';
import 'package:frontend_waste_management/app/modules/recycle/views/smallscreen_recycle_view.dart';

import 'package:get/get.dart';

import '../controllers/recycle_controller.dart';

class RecycleView extends GetView<RecycleController> {
  const RecycleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreenRecycleView();
        } else {
          return LargeScreenRecycleView();
        }
      }),
    );
  }
}
